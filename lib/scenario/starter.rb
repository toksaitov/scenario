#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

require 'optparse'

module Scenario

  class Starter
    SPECS =
      {:scenario_flag =>
         ['-s', '--scenario PATH', "Specifies the scenario file"],
       :scenario_parameters_flag =>
         ['-p', '--parameters value[ value]', "Specifies parameters for the scenario"],
       :version_flag =>
         ['-v', '--version', 'Displays version information and exits.'],
       :help_flag =>
         ['-h', '--help', 'Displays this help message and exits.'],
       :quiet_flag =>
         ['-q', '--quiet', 'Starts in quiet mode.'],
       :verbose_flag =>
         ['-V', '--verbose', 'Starts in verbose mode (ignored in quiet mode).'],
       :debug_flag =>
         ['-d', '--debug', 'Starts in debug mode.']}

    def initialize
      @environment = SERVICES[:environment]

      @options = @environment.options
      @modes   = @environment.modes
      @tasks   = @environment.tasks

      @parser = OptionParser.new()
    end

    def run
      if options_parsed?()
        begin
          if @modes[:verbose]
            @environment.show_message("#{FULL_NAME} has started", :log)
          end

          SERVICES[:executor].run()

          if @modes[:verbose]
            @environment.show_message("#{FULL_NAME} has finished all tasks", :log)
          end
        rescue Exception => e
          @environment.log_error(e, 'Command line interface failure')
        end
      end

      GLOBALS[:errors_number] || 0
    end

    def options
      SPECS
    end

    private
    def options_parsed?
      result = false

      begin
        on_argument(:version_flag) { @tasks[:show_version] = true }
        on_argument(:help_flag)    { @tasks[:show_help]    = true }

        on_argument(:verbose_flag) do
          @modes[:verbose] = true if not @modes[:quiet]
        end
        on_argument(:quiet_flag) do
          @modes[:quiet]   = true
          @modes[:verbose] = false
        end
        on_argument(:debug_flag) do
          @modes[:debug] = true
        end

        on_argument(:scenario_flag) do |scenario|
          @options[:scenario] = scenario
        end

        on_argument(:scenario_parameters_flag) do |params|
          @options[:scenario_parameters] ||= []
          @options[:scenario_parameters] << params
        end

        @parser.parse!(@environment.arguments); result = true

      rescue Exception => e
        @environment.log_error(e, 'Failed to parse arguments')
      end

      result
    end

    def on_argument(name, &block)
      argument_key = name.intern()

      definition = SPECS[argument_key]
      @parser.on(*definition, &block)
    end
  end

end
