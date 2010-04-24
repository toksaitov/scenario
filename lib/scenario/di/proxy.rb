#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario
  module DI

    class Proxy
      class ProxyError < Exception; end

      instance_methods.each do |method|
        undef_method(method) unless method =~ /(^__|^send$|^object_id$)/
      end

      attr_reader :delegate, :interfaces

      def initialize(delegate, interfaces = {})
        @delegate   = delegate
        @interfaces = interfaces
      end

      private
      def method_missing(name, *args, &block)
        result = nil

        interface = @interfaces[name.intern()]
        unless interface.nil?
          result = interface.call(@delegate, *args, &block)
        else
          result = @delegate.send(name, *args, &block)
        end

        result
      end
    end

  end
end
