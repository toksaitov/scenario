#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario
  module Colorable
    def color(*args)
      @color ||= [1.0, 1.0, 1.0, 1.0]

      case args.size
        when 0
          @color
        when 1
          arg = args.first

          case arg
            when Hash
              red   = arg[:r] || arg[:red]
              green = arg[:g] || arg[:green]
              blue  = arg[:b] || arg[:blue]

              alpha = arg[:a] || arg[:alpha]

              @color[0] = red   if red
              @color[1] = green if green
              @color[2] = blue  if blue
              @color[3] = alpha if alpha
            when Symbol
              {:r => @color[0],
               :g => @color[1],
               :b => @color[2],
               :a => @color[3]}[arg] ||
              {:red   => @color[0],
               :green => @color[1],
               :blue  => @color[2],
               :alpha => @color[3]}[arg]
            else
              @color[0] = @color[1] = @color[2] = arg
          end
        when 2
          @color[0], @color[1] = args
        when 3
          @color[0], @color[1], @color[2] = args
        when 4
          @color = args
      end
    end
    alias colour color
    alias rgb color
    alias rgba color

    private
    def apply_color
      glColor(*color)
    end
  end
end
