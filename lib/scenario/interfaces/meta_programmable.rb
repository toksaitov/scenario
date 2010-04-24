#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario
  module MetaProgrammable
    def method_missing(field_name, *args, &block)
      result = nil

      name = field_name.to_instance_name().to_s()
      value_required = false

      if name[-1] == ?=
        name = name[0..-2]
        value_required = true
      end

      if instance_variable_defined?(name)
        if args.empty? and value_required
          raise(ArgumentError, "Wrong number of arguments (#{args.length} for 1)")
        end

        if args.empty?
          result = instance_variable_get(name)
        else
          value = args

          if value.size == 1
            if value.first.is_a?(Class) and block_given?
              value = value.first.new(&block)
            else
              value = value.first
            end
          end

          result = instance_variable_set(name, value)
        end
      else
        raise(NameError, "Instance variable '#{name}' is not defined")
      end

      result
    end

    def define_method(*args, &block)
      self.class.send(:define_method, *args, &block)
    end
  end
end
