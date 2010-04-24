#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Strategies

  group :pile do

    strategy :time_following, :on_initialization do |*args|
      fields     = args[0] || [[:x, :y]]
      time_field = args[1] || :second
      radius     = args[2] || 1
      mode       = args[3] || :angular
      replicate  = args[4] || false

      initial_values = args[5] || []

      if fields.size == 2
        fields = [fields] unless fields.first.is_a?(Array) or
                                 fields.second.is_a?(Array)
      end

      current_proc = case time_field
        when :second, :seconds
          proc { Time.now.sec * 6 }
        when :minute, :minutes
          proc { Time.now.sec * 0.1 +
                 Time.now.min * 6 }
        when :hour, :hours
          proc { Time.now.sec  * 0.6 / 360.0 +
                 Time.now.min  * 0.1
                 Time.now.hour * 30 }
      end

      proc do
        angle = (fields.empty? or current_proc.nil?) ? 0 : current_proc.call()

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

          case mode
            when :angular
              @angle_x = angle + 90
          end

          glutPostRedisplay()
        end
      end
    end

  end

end
