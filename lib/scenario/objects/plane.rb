#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario

  class Plane < Generic
    meta_accessor :step_x, :step_y, :update_call => true

    def initialize
      @step_x = @step_y = 0.1

      @lighted = false

      super
    end

    def step(*args)
      case args.size
        when 0
          [@step_x ||= 0.1,
           @step_y ||= 0.1]
        when 1
          arg = args.first

          if arg.is_a?(Hash)
            @step_x = arg[:x] if arg[:x]
            @step_y = arg[:y] if arg[:y]
          else
            @step_x = @step_y = arg
          end
        when 2
          @step_x, @step_y = args
      end
    end

    def update
      glNewList(list_id, GL_COMPILE)
        glBegin(GL_LINES)
          -1.step 1, @step_y do |y|
            glVertex(-1, y, 0)
            glVertex( 1, y, 0)
          end

          -1.step 1, @step_x do |x|
            glVertex(x, -1, 0)
            glVertex(x,  1, 0)
          end
        glEnd()
      glEndList()
    end
  end

end
