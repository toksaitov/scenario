#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

class Symbol
  def to_instance_name
    if self.to_s()[0] != ?@
      "@#{self}".intern()
    else
      self
    end
  end

  def /(value)
    result = nil

    if value.is_a?(Symbol)
      result = [self, value]
    elsif value.is_a?(Array)
      result = [self] + value.unshift
    end

    result
  end

  unless method_defined?(:to_proc)
    define_method(:to_proc) do
      proc { |object, *args| object.send(self, *args) }
    end
  end

  unless method_defined?(:intern)
    define_method(:intern) do
      self.to_s().intern()
    end
  end
end
