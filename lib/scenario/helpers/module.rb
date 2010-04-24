#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

class Module
  def meta_accessor(*args)
    default_value = nil
    update_required = false

    list_range = args.size - 1

    if args.last.is_a?(Hash)
      default_value   = args.last[:default_value] || args.last[:default]
      update_required = args.last[:update_call_required] || args.last[:update_call]

      list_range -= 1
    end

    (0..list_range).each do |i|
      field_name = args[i]
      instance_name = field_name.to_instance_name()

      define_method(field_name.intern()) do |*method_args|
        case method_args.size
          when 0
            unless instance_variable_defined?(instance_name)
              new_value = default_value.clone rescue default_value
              instance_variable_set(instance_name, new_value)

              try(:update) if update_required and not @__initializing
            end

            instance_variable_get(instance_name)
          when 1
            argument = method_args.first

            if argument.respond_to?(:new)
              instance_variable_set(instance_name, argument.new())
            else
              instance_variable_set(instance_name, argument)
            end

            try(:update) if update_required and not @__initializing
          else
            instance_variable_set(instance_name, method_args)

            try(:update) if update_required and not @__initializing
        end
      end

      define_method("#{field_name}=".intern()) do |value|
        instance_variable_set(instance_name, value)

        try(:update) if update_required and not @__initializing
      end

    end
  end
end
