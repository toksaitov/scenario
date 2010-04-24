#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario

  class Sphere < Generic
    include Degradable

    include Math

    meta_accessor :radius, :update_call => true

    def initialize
      @radius = 1
      @quality = 20

      super
    end

    def update
      glNewList(list_id, GL_COMPILE)
        glEnable(GL_TEXTURE_GEN_S)
        glEnable(GL_TEXTURE_GEN_T)

        glTexGen(GL_S, GL_TEXTURE_GEN_MODE, GL_SPHERE_MAP)
        glTexGen(GL_T, GL_TEXTURE_GEN_MODE, GL_SPHERE_MAP)

        glBegin(GL_QUADS)
          phi = -PI / 2.0
          hphi = PI / @quality

          0.upto(@quality) do
            psi = 0.0
            hpsi = 2 * PI / @quality

            0.upto(@quality) do
              x, y, z = cos(phi) * cos(psi),
                        sin(phi),
                        cos(phi) * sin(psi)

              define_vertex(x, y, z)

              x, y, z = cos(phi) * cos(psi + hpsi),
                        sin(phi),
                        cos(phi) * sin(psi + hpsi)

              define_vertex(x, y, z)

              x, y, z = cos(phi + hphi) * cos(psi + hpsi),
                        sin(phi + hphi),
                        cos(phi + hphi) * sin(psi + hpsi)

              define_vertex(x, y, z)

              x, y, z = cos(phi + hphi) * cos(psi),
                        sin(phi + hphi),
                        cos(phi + hphi) * sin(psi)

              define_vertex(x, y, z)

              psi += hpsi
            end

            phi += hphi
          end
        glEnd()

        glDisable(GL_TEXTURE_GEN_S)
        glDisable(GL_TEXTURE_GEN_T)
      glEndList()
    end

    private
    def define_vertex(x, y, z)
      glNormal(x, y, z)
      glVertex(@radius * x, @radius * y, @radius * z)
    end
  end

end
