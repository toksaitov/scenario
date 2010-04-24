#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario
  module Lightable
    meta_accessor :lighted, :default => true

    private
    def apply_lighting_status
      @__previous_light_status = glIsEnabled(GL_LIGHTING)
      glDisable(GL_LIGHTING) unless lighted
    end

    def restore_lighting_status
      glEnable(GL_LIGHTING) if @__previous_light_status
    end
  end
end
