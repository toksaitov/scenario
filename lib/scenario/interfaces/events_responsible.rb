#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario
  module EventsResponsible
    meta_accessor :initialization_strategies, :default => []
    alias_method :init_strategies, :initialization_strategies

    def on_initialization_event(*args)
      process_strategies(initialization_strategies, *args)
    end

    meta_accessor :display_strategies, :default => []

    def on_display_event
      process_strategies(display_strategies)
    end

    meta_accessor :overlay_display_strategies, :default => []

    def on_overlay_display_event
      process_strategies(overlay_display_strategies)
    end

    meta_accessor :reshape_strategies, :default => []

    def on_reshape_event(width, height)
      process_strategies(reshape_strategies, width, height)
    end

    meta_accessor :idle_strategies, :default => []

    def on_idle_event
      process_strategies(idle_strategies)
    end

    meta_accessor :timer_strategies, :default => []

    def on_timer_tick_event(value)
      process_strategies(timer_strategies, value)
    end

    meta_accessor :window_visibility_change_strategies, :default => []

    def on_window_visibility_change_event(state)
      process_strategies(window_visibility_change_strategies, state)
    end

    meta_accessor :keyboard_strategies, :default => []

    def on_keyboard_event(key, x, y)
      process_strategies(keyboard_strategies, key, x, y)
    end

    meta_accessor :special_keyboard_strategies, :default => []

    def on_keyboard_special_event(key, x, y)
      process_strategies(special_keyboard_strategies, key, x, y)
    end

    meta_accessor :mouse_button_strategies, :default => []

    def on_mouse_button_event(button, state, x, y)
      process_strategies(mouse_button_strategies, button, state, x, y)
    end

    meta_accessor :mouse_motion_strategies, :default => []

    def on_mouse_motion_event(x, y)
      process_strategies(mouse_motion_strategies, x, y)
    end

    meta_accessor :mouse_passive_motion_strategies, :default => []

    def on_mouse_passive_motion_event(x, y)
      process_strategies(mouse_passive_motion_strategies, x, y)
    end

    meta_accessor :mouse_entry_strategies, :default => []

    def on_mouse_entry_event(state)
      process_strategies(mouse_entry_strategies, state)
    end

    meta_accessor :tablet_button_strategies, :default => []

    def on_tablet_button_event(button, state, x, y)
      process_strategies(tablet_button_strategies, button, state, x, y)
    end

    meta_accessor :tablet_motion_strategies, :default => []

    def on_tablet_motion_event(x, y)
      process_strategies(tablet_motion_strategies, x, y)
    end

    meta_accessor :spaceball_button_strategies, :default => []

    def on_spaceball_button_event(button, state)
      process_strategies(spaceball_button_strategies, button, state)
    end

    meta_accessor :spaceball_motion_strategies, :default => []

    def on_spaceball_motion_event(x, y, z)
      process_strategies(spaceball_motion_strategies, x, y, z)
    end

    meta_accessor :spaceball_rotation_strategies, :default => []

    def on_spaceball_rotation_event(x, y, z)
      process_strategies(spaceball_rotation_strategies, x, y, z)
    end

    meta_accessor :button_box_strategies, :default => []

    def on_button_box_event(button, state)
      process_strategies(button_box_strategies, button, state)
    end

    meta_accessor :dials_strategies, :default => []

    def on_dials_event(dial, value)
      process_strategies(dials_strategies, dial, value)
    end

    def strategies
      StrategiesHolder.instance
    end

    private
    def process_strategies(strategies, *args)
      strategies.try(:each_with_index) do |strategy, i|
        if strategy.is_a?(Strategy)
          while strategy.is_a?(Strategy)
            strategy = instance_exec(*strategy.arguments, &strategy.block)
          end

          strategies[i] = strategy
        end

        instance_exec(*args, &strategy)
      end
    end

    def notify(field_name, event, *args)
      actual_field_name = field_name.to_instance_name()

      if instance_variable_defined?(actual_field_name)
        actual_object = instance_variable_get(actual_field_name)
      else
        actual_object = send(field_name)
      end

      actual_object.try(:each) do |instance|
        if instance.is_a?(Disableable)
          instance.try(event, *args) if instance.enabled?()
        else
          instance.try(event, *args)
        end
      end
    end
  end
end
