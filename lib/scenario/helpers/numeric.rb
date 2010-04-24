#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

class Fixnum
  unless method_defined?(:odd?)
    define_method(:odd?) do
      self % 2 != 0
    end
  end

  unless method_defined?(:even?)
    define_method(:even?) do
      self % 2 == 0
    end
  end
end

class Bignum
  unless method_defined?(:odd?)
    define_method(:odd?) do
      self % 2 != 0
    end
  end

  unless method_defined?(:even?)
    define_method(:even?) do
      self % 2 == 0
    end
  end
end

class Numeric
  def milliseconds
    self / 100.0
  end

  def seconds
    self
  end

  def minutes
    self * 60
  end

  def hours
    self * 3600
  end

  def degrees
    self * Math::PI / 180
  end

  def rotate(*args, &block)
    if block_given?
      limit = 360; step = 1

      case args.first
        when Numeric
          limit = args.first
          step  = args.second if args.second.is_a?(Numeric)
        when Hash
          specs = args.first

          limit = specs[:to] unless specs[:to].nil?
          step  = specs[:step] || specs[:by] || step
      end

      self.step(limit, step) do |i|
        yield Math.cos(i.degrees), Math.sin(i.degrees), i
      end
    end
  end

  def to_2d(width, &block)
    x, y = self % width, (self / width).floor()

    yield x, y if block_given?

    [x, y]
  end
end
