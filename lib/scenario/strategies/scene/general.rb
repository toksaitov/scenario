#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Strategies

  group :scene do
    group :display do

      strategy :default do
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

        glPushMatrix()
          apply_position()
          apply_rotation()
          apply_scale()

          notify(:@objects, :on_display_event)
        glPopMatrix()

        glutSwapBuffers()
      end

    end

    group :reshape do

      strategy :perspective do |width, height|
        glViewport(0, 0, width, height)
        glMatrixMode(GL_PROJECTION)
        glLoadIdentity()

        aspect_ratio = width.to_f() / height.to_f()
        glFrustum(-1.0, 1.0, -1.0 / aspect_ratio, 1.0 / aspect_ratio, 3, 10)

        glMatrixMode(GL_MODELVIEW)
        glLoadIdentity()
        glTranslate(0.0, 0.0, -5.0)
      end

      strategy :orthogonal do |width, height|
        glViewport(0, 0, width, height)
        glMatrixMode(GL_PROJECTION)
        glLoadIdentity()

        if width <= height
          aspect_ratio = height.to_f() / width.to_f()
          glOrtho(-1.0, 1.0, -1.0 * aspect_ratio, 1.0 * aspect_ratio, -2, 2)
        else
          aspect_ratio = width.to_f() / height.to_f()
          glOrtho(-1.0 * aspect_ratio, 1.0 * aspect_ratio, -1.0, 1.0, -2, 2)
        end

        glMatrixMode(GL_MODELVIEW)
        glLoadIdentity()
      end

    end

    group :initialization do

      strategy :default do
        glEnable(GL_LINE_SMOOTH)
        glEnable(GL_POINT_SMOOTH)

        glEnable(GL_BLEND)
        glEnable(GL_DEPTH_TEST)
        glEnable(GL_NORMALIZE)
        glEnable(GL_TEXTURE_2D)

        glDepthFunc(GL_LESS)
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

        glTexEnv(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE)

        glClearColor(0.0, 0.0, 0.0, 0.0)
      end

    end
  end

end
