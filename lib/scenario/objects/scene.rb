#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario

  class Scene
    include MetaProgrammable
    include EventsResponsible

    include Positionable
    include Rotatable
    include Scalable

    def initialize(container = nil, &block)
      @objects = []
      @named_objects = {}

      @container = container

      @timer_frequency = 100

      setup_strategies()

      instance_eval(&block) if block_given?
    end

    def run
      on_initialization_event()
      setup_event_functions()

      glutMainLoop()
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

    private
    def setup_strategies
      display_strategies << strategies[:scene/:display/:default]

      reshape_strategies << strategies[:scene/:reshape/:perspective]
      reshape_strategies << lambda do |width, height|
        @container.try(:on_reshape_event, width, height)
        notify(:@objects, :on_reshape_event, width, height)
      end

      idle_strategies << lambda do
        notify(:@objects, :on_idle_event)

        glutPostRedisplay()
      end

      timer_strategies << lambda do |value|
        notify(:@objects, :on_timer_tick_event, value)
      end
      timer_strategies << lambda do |value|
        next_proc = method(:on_timer_tick_event).to_proc() rescue nil

        unless @timer_frequency.nil? or next_proc.nil?
          glutTimerFunc(@timer_frequency, next_proc, 0)
        end
      end

      keyboard_strategies << lambda do |key, x, y|
        notify(:@objects, :on_keyboard_event, key, x, y)
      end

      mouse_button_strategies << lambda do |button, state, x, y|
        notify(:@objects, :on_mouse_button_event, button, state, x, y)
      end

      mouse_motion_strategies << lambda do |x, y|
        notify(:@objects, :on_mouse_motion_event, x, y)
      end

      initialization_strategies << strategies[:scene/:initialization/:default]
      initialization_strategies << lambda do
        notify(:@objects, :on_initialization_event)
      end
    end

    def register_event(method_name, nil_acceptable = true)
      result = nil_acceptable ? nil : lambda {}

      begin
        result = method(method_name).to_proc()
      rescue Exception => e
        SERVICES[:environment].log_error(e, 'Scene event was not found')
      end

      result
    end

    def setup_event_functions
      glutDisplayFunc(register_event(:on_display_event, false))
      glutReshapeFunc(register_event(:on_reshape_event))

      glutIdleFunc(register_event(:on_idle_event))
      glutTimerFunc(@timer_frequency, register_event(:on_timer_tick_event), 0)

      glutKeyboardFunc(register_event(:on_keyboard_event))
      glutSpecialFunc(register_event(:on_keyboard_special_event))

      glutMouseFunc(register_event(:on_mouse_button_event))
      glutMotionFunc(register_event(:on_mouse_motion_event))
    end
  end

end
