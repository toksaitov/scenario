#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario
  module Rotatable
    meta_accessor :angle_x, :angle_y, :angle_z, :default => 0.0

    def rotate(*args)
      case args.size
        when 0
          [angle_x, angle_y, angle_z]
        when 1
          arg = args.first

          case arg
            when Hash
              @angle_x = arg[:x] if arg[:x]
              @angle_y = arg[:y] if arg[:y]
              @angle_z = arg[:z] if arg[:z]
            when Symbol
              {:x => angle_x, :y => angle_y, :z => angle_z}[arg]
            else
              @angle_x = @angle_y = @angle_z = arg
          end
        when 2
          @angle_x, @angle_y = args
        when 3
          @angle_x, @angle_y, @angle_z = args
      end
    end
    alias angle rotate
    alias rotation rotate

    private
    def apply_rotation
      glRotate(angle_y, 1, 0, 0)
      glRotate(angle_x, 0, 1, 0)
      glRotate(angle_z, 0, 0, 1)
    end
  end
end
