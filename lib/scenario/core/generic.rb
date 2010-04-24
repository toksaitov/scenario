#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

require 'scenario/core/visual'

module Scenario

  class Generic < Visual
    include SERVICES[:image_library].delegate rescue nil

    include Colorable
    include Lightable
    include Strokable

    include Positionable
    include Rotatable
    include Scalable

    include Texturable

    include Listable

    def paint
      apply_color()
      apply_line_width()
      apply_pattern()
      apply_texture()

      apply_lighting_status()

      glPushMatrix()
        apply_position()
        apply_rotation()
        apply_scale()

        apply_list()
      glPopMatrix()

      restore_lighting_status()
    end
  end

end
