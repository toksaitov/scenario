#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario

  class Light < Visual
    include Positionable

    def initialize
      Thread.exclusive do
        @@lights_number ||= 0
        @@lights_number += 1

        @light_id = @@lights_number - 1
      end

      if @light_id and @light_id < GL_MAX_LIGHTS - 1
        @light_id += GL_LIGHT0
      else
        @light_id = nil

        SERVICES[:environment].
          log_error(RuntimeError.new(), 'Maximum number of lights was reached')
      end

      @ambient  = [0, 0, 0, 1]
      @diffuse  = [1, 1, 1, 1]
      @specular = [1, 1, 1, 1]

      @spot_direction = [0, 0, 0]

      @spot_exponent = 0
      @spot_cutoff   = 180

      @constant_attenuation  = 1
      @linear_attenuation    = 0
      @quadratic_attenuation = 0

      super
    end

    def paint
      if @light_id
        glEnable(@light_id)

        specs = [[GL_POSITION, [x, y, z, w]],

                 [GL_AMBIENT,  @ambient.to_rgba()],
                 [GL_DIFFUSE,  @diffuse.to_rgba()],
                 [GL_SPECULAR, @specular.to_rgba()],

                 [GL_SPOT_DIRECTION, @spot_direction],
                 [GL_SPOT_EXPONENT,  @spot_exponent],
                 [GL_SPOT_CUTOFF,    @spot_cutoff],

                 [GL_CONSTANT_ATTENUATION,  @constant_attenuation],
                 [GL_LINEAR_ATTENUATION,    @linear_attenuation],
                 [GL_QUADRATIC_ATTENUATION, @quadratic_attenuation]]

        specs.each { |spec| glLight(@light_id, *spec) }
      end
    end
  end

end
