#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

require 'yaml'

require 'scenario/di/helpers'

require 'scenario/di/proxy'
require 'scenario/di/service_factory'

module Scenario
  module DI

    class Container
      class TrapError < Exception; end

      attr_reader :services

      def initialize(&block)
        @services = {}
        @current_service = nil

        instance_eval(&block) if block_given?
      end

      def service(name, &block)
        @current_service = name

        instance_eval(&block) if block_given?

        @current_service = nil
      end

      def on_creation(&block)
        asset(@current_service, &block)
      end

      def asset(name, options = {}, &block)
        instance = nil

        path = options[:file]
        unless path.nil?
          instance = YAML.load_file(path) rescue nil
        end

        if block_given? or not instance.nil?
          service = get_service(name)

          service[:block]    = block
          service[:instance] = instance
          service[:file]     = path
        end
      end

      def interface(name, service_name = nil, &block)
        service_name = @current_service if service_name.nil?

        if block_given?
          service = get_service(service_name)
          service[:interfaces][name.intern()] = block unless service.nil?
        end
      end

      def [](name)
        result = nil

        service_name = name.intern()
        service      = @services[service_name]

        unless service.nil?
          result = service[:instance]
          if result.nil?
            instance = service[:block].call()
            unless instance.nil?
              result = service[:instance] = Proxy.new(instance, service[:interfaces])
            end
          end
        end

        result
      end

      def update(service)
        serialize(service) if service[:file]
      end

      private
      def serialize(service)
        path     = service[:file]
        instance = service[:instance]

        unless path.nil? and instance.nil?
          begin
            File.open(File.expand_path(path), 'w+') do |io|
              io.write(instance.to_yaml())
            end
          rescue Exception => e
            puts("DI container failed to serialize service to #{path}")
            puts(e.message, e.backtrace)
          end
        end
      end

      def get_service(name)
        result = nil

        unless name.nil?
          service_name = name.intern()

          result = @services[service_name]
          if result.nil?
            new_service = DummyServiceFactory.get_service()
            new_service.add_observer(self)

            result = @services[service_name] = new_service
          end
        end

        result
      end
    end

  end
end
