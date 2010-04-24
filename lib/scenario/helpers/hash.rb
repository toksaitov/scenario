#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

class Hash
  def intern_keys
    inject({}) do |result, (key, value)|
      result[(key.intern() rescue key) || key] = value
      result
    end
  end

  def intern_keys!
    self.replace(self.symbolize_keys)
  end
end
