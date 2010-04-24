#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario

  class Visual
    include MetaProgrammable
    include EventsResponsible

    include Disableable

    def initialize(&block)
      display_strategies << method(:paint)

      @__initializing = true
      instance_eval(&block) if block_given?
      @__initializing = false

      update()
    end

    def paint
    end

    def update
    end
  end

end
