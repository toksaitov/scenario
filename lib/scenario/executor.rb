#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario

  class Executor
    def initialize
      @environment = SERVICES[:environment]
      @tasks = @environment.tasks
    end

    def run
      if @tasks[:show_version]
        output_version()
      elsif @tasks[:show_help]
        output_help()
      else
        begin
          SERVICES[:core].run()
        rescue Exception => e
          @environment.log_error(e, 'Core failure')
        end
      end
    end

    private
    def output_help
      output_version()
      output_options()
    end

    def output_version
      @environment.show_message("#{FULL_NAME} version #{VERSION}")
      @environment.show_message("#{COPYRIGHT}")
    end

    def output_options
      @environment.show_message("Available options: \n\n")
      @environment.show_message("Usage: #{UNIX_NAME} {[option] [parameter]}")

      SERVICES[:starter].usage.each do |name, options|
        @environment.show_message("\n\t#{options[2]}\n\t\t#{options[0]}, #{options[1]}")
      end
    end
  end

end
