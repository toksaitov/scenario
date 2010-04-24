#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

require 'singleton'

module Scenario

  class Environment
    include Singleton

    attr_reader :arguments

    attr_reader :logger
    attr_reader :options, :modes, :tasks

    def initialize
      @arguments = ARGV

      @logger  = SERVICES[:logger]

      @options = PARAMETERS[:options]
      @modes   = PARAMETERS[:modes]
      @tasks   = PARAMETERS[:tasks]
    end

    def log_error(exception, message)
      @logger.error(message)
      @logger.error(exception.message)

      unless @modes.nil?
        @logger.error(exception.backtrace) if @modes[:verbose] or
                                              @modes[:debug]
      end

      GLOBALS[:errors_number] ||= 0
      GLOBALS[:errors_number] += 1
    end

    def log_warning(text)
      @logger.warn(text)
    end

    def log_message(text)
      @logger.info(text)
    end

    def show_message(message, log = false)
      puts(message) unless @modes[:quiet]
      log_message(message) if log
    end

    def state(message)
      puts(message) if @modes[:verbose]
      log_message(message)
    end
  end

end
