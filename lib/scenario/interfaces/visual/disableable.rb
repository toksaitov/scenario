#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario
  module Disableable
    meta_accessor :enabled, :default => true

    def enable
      @enabled = true
    end

    def disable
      @enabled = false
    end

    def enabled?
      enabled
    end

    def disabled?
      not enabled
    end
  end
end
