#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

class Symbol
  unless method_defined?(:intern)
    define_method(:intern) do
      self.to_s().intern()
    end
  end
end

class File
  def self.prepare_directory(path)
    path = File.expand_path(path)

    Dir.mkdir(path) unless File.directory?(path) rescue nil

    path
  end
end

module Kernel
  def require_all(file, *files)
    (files << file).each { |item| require(item) }
  end
end
