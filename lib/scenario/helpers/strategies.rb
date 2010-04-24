#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

require 'singleton'

module Strategies
  def self.group(name, &block)
    result = nil

    strategy = Scenario::StrategiesHolder.instance

    if block_given?
      if strategy.scope.empty?
        current_level = strategy

        strategy[name] ||= {}
        strategy.scope.push(strategy[name])
      else
        current_level = strategy.scope.last

        strategy.scope.last[name] ||= {}
        strategy.scope.push(strategy.scope.last[name])
      end

      result = block_given? ? yield : nil

      strategy.scope.pop()
    else
      result = strategy[name]
    end

    result
  end

  def self.strategy(name, with_init = false, &block)
    result = nil

    strategy = Scenario::StrategiesHolder.instance

    if block_given?
      result = with_init ? Scenario::Strategy.new(&block) : block

      if strategy.scope.empty?
        strategy[name] = result
      else
        strategy.scope.last[name] = result
      end
    else
      result = strategy[name]
    end

    result
  end
end

module Scenario

  class Strategy
    attr_accessor :arguments
    attr_accessor :block

    def initialize(*args, &block)
      @arguments = args
      @block = block
    end
  end

  class StrategiesHolder < Hash
    include Singleton

    attr_accessor :scope

    def initialize(hash = nil)
      super()

      replace(hash) unless hash.nil?

      @scope = []
    end

    def [](key, *args)
      path = []

      if key.is_a?(Array)
        path.unshift(*key[1..-1])
        key = key.first
      end

      result = super(key)

      path.each do |item|
        break if result.nil?
        result = result.try(:[], item)
      end

      if result.is_a?(Strategy)
        result = Strategy.new(*args, &result.block)
      end

      result
    end

    def []=(path, value)
      result = nil

      if path.is_a?(Array)
        if path.size == 1
          result = super(path.first, value)
        elsif path.size > 1
          result = self[path.first]

          path[1..-2].each do |item|
            break if result.nil?
            result = result.try(:[], item)
          end

          result = result.try(:[]=, path.last, value)
        end
      else
        result = super(path, value)
      end

      result
    end

    def has_any?(*args)
      result = nil

      args.each do |item|
        if item.is_a?(Array)
          result = self[*item]
        else
          result = self[item]
        end

        break unless result.nil?
      end

      result
    end
  end

end
