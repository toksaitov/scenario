#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario

  class Cone < Generic
    include Degradable

    meta_accessor :height, :update_call => true

    def initialize
      @height  = 2
      @quality = 10

      super
    end

    def update
      glNewList(list_id, GL_COMPILE)
        glBegin(GL_TRIANGLE_FAN)
          glNormal(0, 0, @height)
          glVertex(0, 0, @height / Math.sqrt(@height ** 2))

          0.rotate(:to => 360, :by => step(360.0)) do |x, y, i|
            magnitude = Math.sqrt(x ** 2 + y ** 2).to_f()
            glNormal(x / magnitude, y / magnitude, 0)

            glVertex(x, y, 0)
          end
        glEnd()

        glBegin(GL_TRIANGLE_FAN)
          glNormal(0, 0, -1)
          glVertex(0, 0, 0)

          0.rotate(:to => 360, :by => step(360.0)) do |x, y, i|
            glNormal(x, y, -1); glVertex(x, y, 0)
          end
        glEnd()
      glEndList()
    end
  end

end
