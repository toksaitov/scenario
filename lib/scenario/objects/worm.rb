#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario

  class Worm < Generic
    meta_accessor :length, :update_call => true

    meta_accessor :x_diff,  :y_diff,  :update_call => true
    meta_accessor :x_range, :y_range, :update_call => true

    meta_accessor :sync, :update_call => true

    def initialize
      @length = 20

      @x_diff = 0.2
      @y_diff = 0.1

      @x_range = -1..1
      @y_range = -1..1

      @sync = false

      @vertices = [[0, 0]]

      @lighted = false

      idle_strategies << method(:update)

      super
    end

    def x(*args)
      unless args.empty?
        @x = args.first
        @vertices = [[@x, @y]]

        update()
      end

      @x
    end

    def y(*args)
      unless args.empty?
        @y = args.first
        @vertices = [[@x, @y]]

        update()
      end

      @y
    end

    def position(*args)
      case args.size
        when 1
          @x = @y = args
          @vertices = [[@x, @y]]

          update()
        when 2
          @x, @y = args
          @vertices = [[@x, @y]]

          update()
      end

      [@x, @y]
    end

    def update
      previous_node = @vertices.first

      x = previous_node[0] + @x_diff
      y = previous_node[1] + @y_diff

      direction_changed = false

      unless @x_range.include?(x)
        next_diff = @sync ? @x_diff * -1 :
                            @x_range.random()

        @x_diff = next_diff; direction_changed = true
      end

      unless @y_range.include?(y)
        next_diff = @sync ? @y_diff * -1 :
                            @y_range.random()

        @y_diff = next_diff; direction_changed = true
      end

      unless direction_changed
        @vertices.unshift([x, y])
        @vertices.pop() if @vertices.size > @length
      end

      glNewList(list_id, GL_COMPILE)
        glBegin(GL_LINE_STRIP)
          @vertices.each { |vertex| glVertex(*vertex) }
        glEnd()
      glEndList()
    end
  end

end
