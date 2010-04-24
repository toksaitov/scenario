#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario
  module Texturable
    meta_accessor :texture_coords, :default => []

    def texture(*args, &block)
      unless args.empty?
        @texture = args.first.is_a?(Class) ? args.first.new(&block) : args.first
      end

      @texture
    end

    private
    meta_accessor :texture_coords_index, :default => 0

    def apply_texture
      if texture
        texture.paint()
      else
        glBindTexture(GL_TEXTURE_2D, 0)
      end
    end

    def current_texture_coords
      texture_coords[texture_coords_index]
    end

    def next_texture_coords
      unless texture_coords.empty?
        texture_coords_index((texture_coords_index + 1) % texture_coords.size)

        current_texture_coords()
      end
    end

    def previous_texture_coords
      unless texture_coords.empty?
        texture_coords_index((texture_coords_index - 1) % texture_coords.size)

        current_texture_coords()
      end
    end

    def apply_texture_coords(*args)
      coords = args.empty? ? current_texture_coords : args.first

      glTexCoord(*coords) if coords

      coords
    end

    def apply_next_texture_coords
      apply_texture_coords(next_texture_coords)
    end

    def apply_previous_texture_coords
      apply_texture_coords(previous_texture_coords)
    end
  end
end
