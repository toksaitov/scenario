#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Strategies

  group :scene do
    group :timer do

      strategy :rotation_and_scale, :on_initialization do
        @inertia_by_x ||= 0
        @inertia_by_y ||= 0

        @angle_x ||= 0
        @angle_y ||= 0

        proc do
          @angle_x += @inertia_by_x
          @angle_y += @inertia_by_y

          glutPostRedisplay()
        end
      end

    end

    group :mouse_button do

      strategy :rotation_and_scale, :on_initialization do
        @mouse_x ||= -1; @mouse_y ||= -1

        @mouse_x_incr ||= 0
        @mouse_y_incr ||= 0

        @inertia_by_x ||= 0
        @inertia_by_y ||= 0

        @key_modifiers ||= 0

        inertia_limit ||= 1.0
        inertia_factor ||= 1

        proc do |button, state, x, y|
          @key_modifiers = glutGetModifiers()

          if button == GLUT_LEFT_BUTTON
            if state == GLUT_UP
              @mouse_x = @mouse_y = -1

              if @mouse_x_incr > inertia_limit
                @inertia_by_x = (@mouse_x_incr - inertia_limit) * inertia_factor
              end
              if -@mouse_x_incr > inertia_limit
                @inertia_by_x = (@mouse_x_incr + inertia_limit) * inertia_factor
              end

              if @mouse_y_incr > inertia_limit
                @inertia_by_y = (@mouse_y_incr - inertia_limit) * inertia_factor
              end
              if -@mouse_y_incr > inertia_limit
                @inertia_by_y = (@mouse_y_incr + inertia_limit) * inertia_factor
              end
            else
              @inertia_by_x = 0
              @inertia_by_y = 0
            end

            @mouse_x_incr = 0
            @mouse_y_incr = 0
          end

          glutPostRedisplay()
        end
      end

    end

    group :mouse_motion do

      strategy :rotation_and_scale, :on_initialization do
        @mouse_x ||= -1; @mouse_y ||= -1

        @mouse_x_incr ||= 0
        @mouse_y_incr ||= 0

        @key_modifiers ||= 0

        scale_factor ||= 0.01

        proc do |x, y|
          if @mouse_x != -1 or @mouse_y != -1
            @mouse_x_incr = x - @mouse_x
            @mouse_y_incr = y - @mouse_y

            if @key_modifiers & GLUT_ACTIVE_CTRL != 0
              if @mouse_x != -1
                @angle_z += @mouse_x_incr

                increment = @mouse_y_incr * scale_factor / 2.0

                @scale_x += increment
                @scale_y += increment
                @scale_z += increment
              end
            else
              if @mouse_x != -1
                @angle_x += @mouse_x_incr / 2.0
                @angle_y += @mouse_y_incr / 2.0
              end
            end
          end

          @mouse_x = x
          @mouse_y = y

          glutPostRedisplay()
        end
      end

    end
  end

end
