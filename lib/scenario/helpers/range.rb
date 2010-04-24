#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

class Range
  def random
    rand() * (self.last - self.first) + self.first rescue nil
  end
end
