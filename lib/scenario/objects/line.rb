#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario

  class Line < Generic
    meta_accessor :x1, :y1, :z1, :x2, :y2, :z2,
                  :update_call => true

    def initialize
      @x1 = @y1 = @z1 = @x2 = @y2 = @z2 = 0.0

      @lighted = false

      super
    end

    def update
      glNewList(list_id, GL_COMPILE)
        glBegin(GL_LINES)
          glVertex(@x1, @y1, @z1)
          glVertex(@x2, @y2, @z2)
        glEnd()
      glEndList()
    end
  end

end
