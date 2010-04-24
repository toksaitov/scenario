#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Strategies

    group :motion do

      strategy :path_traversal, :with_init do |path|
        proc do
          specs = path.first

          specs.each do |field, value|
            if value.is_a?(Proc)
              send(field, instance_eval(&value))
            else
              send(field, value)
            end
          end

          path << path.shift()

          glutPostRedisplay()
        end
      end

      strategy :circular_motion, :with_init do |*args|
        fields = args[0] || [[:x, :y]]
        speed  = args[1] || 1
        radius = args[2] || 1
        replicate = args[3] || false

        initial_values = args[3] || []

        if fields.size == 2
          fields = [fields] unless fields.first.is_a?(Array) or
                                   fields.second.is_a?(Array)
        end

        angle = 0

        proc do
          fields.each_with_index do |pair, i|
            unless replicate
              first_value  = initial_values[i].first  rescue 0
              second_value = initial_values[i].second rescue 0
            else
              first_value  = send(pair.first)  rescue 0
              second_value = send(pair.second) rescue 0
            end

            x_angle = first_value  + Math.cos(angle.degrees) * radius
            y_angle = second_value + Math.sin(angle.degrees) * radius

            send(pair.first,  x_angle) rescue nil
            send(pair.second, y_angle) rescue nil
          end

          angle += speed
          angle = angle % 360 if angle > 360
        end
      end

      strategy :periodic_motion, :with_init do |*args|
        fields = args[0] || [:x]
        type   = args[1] || :sin
        speed  = args[2] || 1
        radius = args[3] || 1
        limit  = args[4] || 360
        replicate = args[5] || false

        initial_values = args[6] || []

        angle = 0

        current_proc = case type
          when :sin, :cos, :tan, :atan, :asin, :acos
            proc { Math.send(type, angle.degrees) * radius }
          when :sinh, :cosh, :tanh, :atanh, :asinh, :acosh
            proc { Math.send(type, angle.degrees) * radius }
          when :square_wave
            proc { Math.sgn(Math.sin(angle.degrees)) * radius }
        end

        proc do
          fields.each_with_index do |field, i|
            initial_value = unless replicate
              initial_values[i] || 0
            else
              send(field) rescue 0
            end

            new_value = initial_value + (current_proc.call() rescue 0)

            send(field, new_value) rescue nil
          end

          angle += speed
          angle = angle % limit if angle > limit
        end
      end

    end

end
