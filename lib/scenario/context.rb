#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

require 'scenario/di/container'

module Scenario
  DIRECTORIES = DI::Container.new do
    asset :base do
      File.prepare_directory(File.join('~', ".#{UNIX_NAME}"))
    end

    asset :helpers do
      File.expand_path(File.join(File.dirname(__FILE__), 'helpers'))
    end

    asset :interfaces do
      File.expand_path(File.join(File.dirname(__FILE__), 'interfaces'))
    end

    asset :core do
      File.expand_path(File.join(File.dirname(__FILE__), 'core'))
    end

    asset :scenarios do
      File.expand_path(File.join(File.dirname(__FILE__), 'scenarios'))
    end

    asset :user_scenarios do
      File.prepare_directory(File.join(DIRECTORIES[:base], 'scenarios'))
    end

    asset :all_scenarios do
      [DIRECTORIES[:scenarios], DIRECTORIES[:user_scenarios]]
    end

    asset :objects do
      File.expand_path(File.join(File.dirname(__FILE__), 'objects'))
    end

    asset :user_objects do
      File.prepare_directory(File.join(DIRECTORIES[:base], 'objects'))
    end

    asset :all_objects do
      [DIRECTORIES[:objects], DIRECTORIES[:user_objects]]
    end

    asset :strategies do
      File.expand_path(File.join(File.dirname(__FILE__), 'strategies'))
    end

    asset :user_strategies do
      File.prepare_directory(File.join(DIRECTORIES[:base], 'strategies'))
    end

    asset :all_strategies do
      [DIRECTORIES[:strategies], DIRECTORIES[:user_strategies]]
    end

    asset :assets do
      File.expand_path(File.join(File.dirname(__FILE__), '..' , '..', 'assets'))
    end

    asset :user_assets do
      File.prepare_directory(File.join(DIRECTORIES[:base], 'assets'))
    end

    asset :all_assets do
      [DIRECTORIES[:assets], DIRECTORIES[:user_assets]]
    end

    asset :log do
      File.prepare_directory(File.join(DIRECTORIES[:base], 'logs'))
    end
  end

  DIRS = DIRECTORIES

  FILES = DI::Container.new do
    asset :log do
      File.join(DIRECTORIES[:log], 'application.log')
    end

    asset :options do
      File.join(DIRECTORIES[:base], 'options.yml')
    end

    asset :modes do
      File.join(DIRECTORIES[:base], 'modes.yml')
    end

    asset :tasks do
      File.join(DIRECTORIES[:base], 'tasks.yml')
    end

    asset :helpers do
      Dir[File.join(DIRECTORIES[:helpers], '**', '*.rb')]
    end

    asset :interfaces do
      Dir[File.join(DIRECTORIES[:interfaces], '**', '*.rb')]
    end

    asset :core do
      Dir[File.join(DIRECTORIES[:core], '**', '*.rb')]
    end

    asset :environment do
      FILES[:helpers] + FILES[:interfaces] + FILES[:core]
    end
  end

  SERVICES = DI::Container.new do
    service :environment do
      on_creation do
        require_all *FILES[:environment]
        require 'scenario/environment'

        Environment.instance()
      end

      interface :log_error do |instance, exception, message|
        instance.log_error(exception, message)
      end

      interface :log_warning do |instance, text|
        instance.log_warning(text)
      end

      interface :log_message do |instance, text|
        instance.log_message(text)
      end

      interface :show_message do |instance, text, log|
        instance.show_message(text, log)
      end
    end

    service :starter do
      on_creation do
        require 'scenario/starter'; Starter.new()
      end

      interface :run do |instance|
        instance.run()
      end

      interface :usage do |instance|
        instance.options
      end
    end

    service :core do
      on_creation do
        require 'scenario/core'; Core.new()
      end

      interface :run do |instance|
        instance.run()
      end
    end

    service :executor do
      on_creation do
        require 'scenario/executor'; Executor.new()
      end

      interface :run do |instance|
        instance.run()
      end
    end

    service :logger do
      on_creation do
        require 'logger'

        logger = Logger.new(FILES[:log], 10, 1048576)
        logger.level = Logger::INFO

        logger
      end

      interface :error do |instance, message|
        instance.error(message)
      end

      interface :warn do |instance, message|
        instance.warn(message)
      end

      interface :info do |instance, message|
        instance.info(message)
      end
    end

    service :gl do
      on_creation do
        require 'gl'; require 'glu'; require 'glut'; [Gl, Glu, Glut]
      end
    end

    service :image_library do
      on_creation do
        begin
          require 'RMagick'

          module ::Kernel
            class ImageProxy
              def self.[](image)
                self.new(image)
              end

              def self.read(path)
                image = Magick::Image.read(path).first

                self.new(image)
              end

              attr_accessor :image

              def initialize(image)
                @image = image.is_a?(Array) ? image.first : image
              end

              def width
                @image.columns
              end

              def height
                @image.rows
              end

              def to_rgb_str
                @image.export_pixels_to_str()
              end
            end
          end

          Magick

        rescue Exception => e
          SERVICES[:environment].
            log_error(e, 'A problem with the RMagick library has occurred')
        end
      end
    end
  end

  PARAMETERS = DI::Container.new do
    asset :options, :file => FILES[:options] do
      {:scenario => nil,
       :scenario_parameters => []}
    end

    asset :modes, :file => FILES[:modes] do
      {:verbose => false,
       :quiet   => false,
       :debug   => false}
    end

    asset :tasks, :file => FILES[:tasks] do
      {:show_version => false,
       :show_help    => false}
    end
  end
end
