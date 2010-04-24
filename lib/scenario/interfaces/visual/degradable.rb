#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario
  module Degradable
    meta_accessor :quality, :default => 10, :update_call => true

    private
    def step(limit)
      limit / quality
    end
  end
end
