#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

class Array
  unless method_defined?(:sample)
    define_method(:sample) do |*args|
      n = args.first || 1

      result = []

      if n == 1
        result = self[(0..(size - 1)).random.round().to_i()]
      else
        unless empty?
          n.times do
            result << self[(0..(size - 1)).random.round().to_i()]
          end
        end
      end

      result
    end
  end

  def /(value)
    result = nil

    if value.is_a?(Symbol)
      result = self + [value]
    elsif value.is_a?(Array)
      result = self + value
    end

    result
  end

  def to_rgba
    result = [0, 0, 0, 1]

    0.upto(3) do |i|
      next_value = self[i].try(:to_f)
      next_value ||= self[i].try(:to_i)

      result[i] = next_value unless next_value.nil?
    end

    result
  end

  def method_missing(name, *args, &block)
    numerals = [:second, :third, :fourth,
                :fifth,  :sixth, :seventh,
                :eighth, :ninth, :tenth]

    index = numerals.index(name.intern())
    unless index.nil?
      self[index + 1]
    else
      super
    end
  end
end
