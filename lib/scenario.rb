#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

current_dir = File.dirname(__FILE__)
current_abs_path = File.expand_path(current_dir)

$LOAD_PATH.unshift(current_dir) unless $LOAD_PATH.include?(current_dir) or
                                       $LOAD_PATH.include?(current_abs_path)

module Scenario
  FULL_NAME = 'Scenario'
  UNIX_NAME = 'scenario'
  VERSION   = '0.0.5'

  AUTHOR = 'Toksaitov Dmitrii Alexandrovich'

  EMAIL = "toksaitov.d@gmail.com"
  URL   = "http://github.com/toksaitov/#{UNIX_NAME}"

  COPYRIGHT = "Copyright (C) 2010 #{AUTHOR}"

  USER_BASE_DIRECTORY = ENV["#{UNIX_NAME.upcase()}_USER_BASE"] || File.join('~', ".#{UNIX_NAME}")

  GLOBALS = {}
end

require 'scenario/context'
