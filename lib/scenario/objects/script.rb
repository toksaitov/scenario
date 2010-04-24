#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario

  class Script
    include MetaProgrammable

    def initialize(name, &block)
      @name = name

      @parameters = SERVICES[:environment].options[:scenario_parameters]

      @scenes = {}
      @container = nil

      instance_eval(&block) if block_given?
    end

    def run
      default_scene = @scenes[:default_scene]
      default_scene.run() if default_scene
    end

    def container(*args, &block)
      unless args.empty?
        @container = args.first.new(&block)
        @scenes.each do |name, instance|
          instance.try(:container, @container)
        end
      end

      @container
    end

    def scene(definition, &block)
      definition.each do |name, klass|
        new_instance = klass.new(&block)
        new_instance.try(:container, @container)

        @scenes[name] = new_instance
      end
    end
  end

end
