#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario
  module Strokable
    meta_accessor :pattern_factor, :default => 1
    meta_accessor :pattern, :default => 0xFFFF

    meta_accessor :line_width, :default => 1.0

    private
    def apply_pattern
      glEnable(GL_LINE_STIPPLE)
      glLineStipple(pattern_factor, pattern)
    end

    def apply_line_width
      glLineWidth(line_width)
    end
  end
end
