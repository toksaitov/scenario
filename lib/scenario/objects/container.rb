#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario

  class Container < Visual
    include Positionable
    include Rotatable
    include Scalable

    def initialize(&block)
      @objects = []
      @named_objects = {}

      super
    end

    def object(argument, &block)
      result = nil

      case argument
        when Numeric
          result = @objects[argument]
        when Symbol
          result = @named_objects[argument]
        when Hash
          argument.each do |name, value|
            @objects << (value.is_a?(Class) ? value.new(&block) : value)
            @named_objects[name] = @objects.last
          end
        when Class
          result = argument.new(&block)
          @objects << result
        else
          result = argument
          @objects << result
      end

      result
    end

    def paint
      glPushMatrix()
        apply_position()
        apply_rotation()
        apply_scale()

        notify(:@objects, :on_display_event)
      glPopMatrix()
    end

  end

end
