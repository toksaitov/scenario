#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario

  class Star < Generic
    include Degradable

    meta_accessor :interval, :update_call => true

    def initialize
      @interval = 10

      @quality = 30
      @lighted = false

      super
    end

    def update
      step = step(360.0); angle = 0

      glNewList(list_id, GL_COMPILE)
        glBegin(GL_LINES)
          0.rotate(:to => 360, :by => step) do |x, y|
            glVertex(x, y)

            next_angle = angle + step * @interval

            glVertex(Math.cos(next_angle.degrees),
                     Math.sin(next_angle.degrees))

            angle += step
          end
        glEnd()
      glEndList()
    end
  end

end
