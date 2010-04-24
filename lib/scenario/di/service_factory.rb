#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

require 'scenario/di/service'

module Scenario
  module DI

    class ServiceFactory
      def self.get_service
        Service.new()
      end
    end

    class DummyServiceFactory < ServiceFactory
      def self.get_service
        service = Service.new()
        service.definition[:interfaces] = {}

        service
      end
    end

  end
end
