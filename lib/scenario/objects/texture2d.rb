#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario

  class Texture2D
    include MetaProgrammable

    include Disableable

    meta_accessor :image, :update_call => true

    attr_reader :id

    def initialize(&block)
      @image = nil

      @__initializing = true
      instance_eval(&block) if block_given?
      @__initializing = false

      @id = 0

      update()
    end

    def width
      @image.try(:width)
    end

    def height
      @image.try(:height)
    end

    def paint
      glBindTexture(GL_TEXTURE_2D, @id)
    end

    def update
      if @image
        @id = create_opengl_texture()

        gluBuild2DMipmaps(GL_TEXTURE_2D, GL_RGB, @image.width, @image.height,
                          GL_RGB, GL_UNSIGNED_BYTE, @image.to_rgb_str())
      end

      @id
    end

    private
    def create_opengl_texture
      @id = glGenTextures(1)[0] if @id == 0

      glBindTexture(GL_TEXTURE_2D, @id)
      glPixelStore(GL_UNPACK_ALIGNMENT, 1)

      glTexParameter(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT)
      glTexParameter(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT)
      glTexParameter(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST)
      glTexParameter(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)

      @id
    end
  end

end
