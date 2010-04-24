#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario

  class Cube < Generic
    def initialize
      @texture_coords = [[0, 0],
                         [0, 1],
                         [1, 1],
                         [1, 0]]

      super
    end

    def update
      glNewList(list_id, GL_COMPILE)
        glPushMatrix()
          angles = [[90,  0, 1, 0],
                    [90,  0, 1, 0],
                    [90,  0, 1, 0],
                    [90,  0, 1, 0],
                    [90,  1, 0, 0],
                    [180, 1, 0, 0]]

          angles.each do |angle|
            glRotate(*angle)

            glBegin(GL_QUADS)
              glNormal(0, 0, 1)

              define_vertex(-1, -1, 1)
              define_vertex(-1,  1, 1)
              define_vertex( 1,  1, 1)
              define_vertex( 1, -1, 1)
            glEnd()
          end
        glPopMatrix()
      glEndList()
    end

    private
    def define_vertex(x, y, z)
      apply_next_texture_coords(); glVertex(x, y, z)
    end
  end

end
