#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario

  class Axe < Generic
    def initialize
      @lighted = false

      super
    end

    def update
      vertices = [[0, -1, 0],
                  [0, 1, 0],
                  [-0.2, 0.8, 0],
                  [0, 1, 0],
                  [0.2, 0.8, 0]]

      glNewList(list_id, GL_COMPILE)
        glBegin(GL_LINE_STRIP)
          vertices.each { |vertex| glVertex(*vertex) }
        glEnd()
      glEndList()
    end

  end

end
