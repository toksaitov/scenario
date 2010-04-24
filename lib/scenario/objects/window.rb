#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario

  class Window
    include MetaProgrammable
    include EventsResponsible

    def initialize(&block)
      @width, @height = 640, 480

      @title = FULL_NAME
      @display_mode = GLUT_RGB | GLUT_DOUBLE |
                      GLUT_ALPHA | GLUT_DEPTH

      setup_strategies()

      instance_eval(&block) if block_given?

      @window = create_window()
    end

    def display_mode(*args)
      unless args.empty?
        @display_mode = args.first
        args[1..-1].each do |mode|
          @display_mode |= mode
        end
      end

      @display_mode
    end

    def reshape(width, height)
      @width  = width
      @height = height
    end

    private
    def create_window
      glutInit()
      glutInitDisplayMode(@display_mode)
      glutInitWindowSize(@width, @height)

      @window = glutCreateWindow(@title)
    end

    def setup_strategies
      reshape_strategies << method(:reshape)
    end
  end

end
