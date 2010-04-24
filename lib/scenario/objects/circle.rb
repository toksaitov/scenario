#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario

  class Circle < Generic
    include Degradable

    def initialize
      @jagged  = false

      @quality = 50
      @lighted = false

      super
    end

    def update
      glNewList(list_id, GL_COMPILE)
        glBegin(@jagged ? GL_LINES : GL_LINE_STRIP)
          0.rotate(:to => 360, :by => step(360.0)) do |x, y|
            glVertex(x, y)
          end
        glEnd()
      glEndList()
    end
  end

end
