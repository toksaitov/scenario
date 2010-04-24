#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario
  module Positionable
    meta_accessor :x, :y, :z, :default => 0.0
    meta_accessor :w, :default => 1.0

    def position(*args)
      case args.size
        when 0
          [x, y, z, w]
        when 1
          arg = args.first

          case arg
            when Hash
              @x = arg[:x] if arg[:x]
              @y = arg[:y] if arg[:y]
              @z = arg[:z] if arg[:z]
              @w = arg[:w] if arg[:w]
            when Symbol
              {:x => x, :y => y, :z => z, :w => w}[arg]
            else
              @x = @y = @z = arg
          end
        when 2
          @x, @y = args
        when 3
          @x, @y, @z = args
        when 4
          @x, @y, @z, @w = args
      end
    end
    alias coords position
    alias coordinates position
    alias location position
    alias center position

    private
    def apply_position
      glTranslate(x, y, z)
    end
  end
end
