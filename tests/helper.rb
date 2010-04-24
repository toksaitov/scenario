require 'rubygems'
require 'test/unit'

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'scenario'))

require 'stringio'

module Kernel

  def fake_stdout(&block)
    result = StringIO.new()

    $stdout = result
    yield &block if block_given?

    return result
  ensure
    $stdout = STDOUT
  end

  def fake_stderr(&block)
    result = StringIO.new

    $stderr = result
    yield &block if block_given?

    return result
  ensure
    $stderr = STDERR
  end

end
