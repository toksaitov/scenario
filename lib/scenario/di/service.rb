#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

require 'observer'

module Scenario
  module DI

    class Service
      include Observable

      attr_reader :definition

      def initialize(definition = default_definition())
        @definition = definition

        state_update()
      end

      def [](key)
        @definition[key]
      end

      def []=(key, value)
        previous_value = @definition[key]
        @definition[key] = value

        state_update() if previous_value != value

        value
      end

      def nil?
        @definition.nil?
      end

      private
      def state_update
        changed(); notify_observers(@definition)
      end

      def default_definition
        {:block => nil, :instance => nil, :interfaces => nil, :file => nil}
      end
    end

  end
end
