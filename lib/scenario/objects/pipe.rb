#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario

  class Pipe < Generic
    include Degradable

    meta_accessor :radius, :level, :update_call => true

    def initialize
      @radius = 0.5
      @level  = 0.3

      @quality = 30

      super
    end

    def update
      glNewList(list_id, GL_COMPILE)
        glPushMatrix()
          step  = step(360.0)
          level = @level / 2.0

          angle = 0.0

          glBegin(GL_QUADS)
            0.upto(@quality) do |i|
              x, y = Math.cos(angle.degrees),
                     Math.sin(angle.degrees)

              define_vertex(x, y,  level)
              define_vertex(x, y, -level)

              angle += step
              x, y = Math.cos(angle.degrees),
                     Math.sin(angle.degrees)

              define_vertex(x, y, -level)
              define_vertex(x, y,  level)
            end
          glEnd()
        glPopMatrix()
      glEndList()
    end

    private
    def define_vertex(x, y, z)
      glNormal(x, y, z)
      glVertex(x * @radius, y * @radius, z)
    end
  end

end
