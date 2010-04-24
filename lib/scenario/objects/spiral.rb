#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario

  class Spiral < Generic
    include Degradable

    meta_accessor :windings, :update_call => true
    meta_accessor :height,   :update_call => true

    def initialize
      @windings = 5
      @height   = 1

      @quality = 5
      @lighted = false

      super
    end

    def update
      step = step(100.0)
      height_step = @height / (@windings * (360.0 / step))

      z = -@height

      glNewList(list_id, GL_COMPILE)
        glBegin(GL_LINE_STRIP)
          1.upto(@windings) do
            0.rotate(:to => 360, :by => step) do |x, y|
              x /= 2.0; y /= 2.0
              z += height_step

              glVertex(x, y, z)
            end
          end
        glEnd()
      glEndList()
    end
  end

end
