#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

include *Scenario::SERVICES[:gl].delegate

module Kernel
  def scenario(name, &block)
    Scenario.module_eval do
      self::GLOBALS[:scenarios] ||= []
      self::GLOBALS[:scenarios] << self::Script.new(name, &block)
    end
  end
end

module Scenario
  class Core
    def initialize
      @environment = SERVICES[:environment]
      @options = @environment.options

      @scenario = @options[:scenario]
      @scenario_parameters = @options[:scenario_parameters]

      load_objects()
    end

    def run
      loaded = false

      Kernel.send(:remove_method, :y)

      DIRECTORIES[:all_scenarios].each do |directory|
        begin
          require(File.expand_path(File.join(directory, @scenario)))
        rescue LoadError => e
          next
        rescue Exception => e
          @environment.log_error(e, 'Failed to execute scenario global code')
        end

        loaded = true; break
      end

      unless loaded
        begin
          require(File.expand_path(@scenario))
        rescue LoadError => e
          @environment.log_error(e, 'Failed to load scenario')
        rescue Exception => e
          @environment.log_error(e, 'Failed to execute scenario global code')
        end
      end

      begin
        GLOBALS[:scenarios].last.run()
      rescue Exception => e
        @environment.log_error(e, 'Failed execute scenario')
      end
    end

    private
    def load_objects
      DIRECTORIES[:all_objects].each do |directory|
        load_from_directory(directory)
      end

      DIRECTORIES[:all_strategies].each do |directory|
        load_from_directory(directory)
      end
    end

    def load_from_directory(directory)
      Dir[File.join(directory, '**', '*.{rb}')].each do |file|
        begin
          require(file)
        rescue Exception => e
          @environment.log_error(e, 'Failed to load object')
        end
      end
    end
  end

end
