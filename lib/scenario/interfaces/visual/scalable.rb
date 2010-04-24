#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario
  module Scalable
    meta_accessor :scale_x, :scale_y, :scale_z, :default => 1.0

    def scale(*args)
      case args.size
        when 0
          [scale_x, scale_y, scale_z]
        when 1
          arg = args.first

          case arg
            when Hash
              @scale_x = arg[:x] if arg[:x]
              @scale_y = arg[:y] if arg[:y]
              @scale_z = arg[:z] if arg[:z]
            when Symbol
              {:x => scale_x, :y => scale_y, :z => scale_z}[arg]
            else
              @scale_x = @scale_y = @scale_z = arg
          end
        when 2
          @scale_x, @scale_y = args
        when 3
          @scale_x, @scale_y, @scale_z = args
      end
    end
    alias size scale

    private
    def apply_scale
      glScale(scale_x, scale_y, scale_z)
    end
  end
end
