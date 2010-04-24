#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

class Object
  def valid?(item, *args, &block)
    result = item.nil? ? false : true

    if result
      args.each do |object|
        unless object
          result = false; break
        end
      end

      yield if block_given?
    end

    result
  end

  def try(method_name, *args, &block)
    send(method_name, *args, &block) if respond_to?(method_name, true)
  end

  unless method_defined?(:instance_exec)

    module InstanceExecHelper; end
    include InstanceExecHelper

    #noinspection RubyScope,RubyDeadCode
    def instance_exec(*args, &block)
      method_name = "__instance_exec_#{Thread.current.object_id.abs}_#{object_id.abs}"

      InstanceExecHelper.module_eval { define_method(method_name, &block) }

      result = nil

      begin
        result = send(method_name, *args)
      ensure
        InstanceExecHelper.module_eval { undef_method(method_name) } rescue nil
      end

      result
    end

  end
end
