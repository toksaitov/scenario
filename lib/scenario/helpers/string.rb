#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

class String
  def to_instance_name
    if self[0] != ?@
      "@#{self}".intern()
    else
      self.intern()
    end
  end
end
