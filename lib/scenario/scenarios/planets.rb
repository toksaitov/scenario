module Scenario

  scenario 'Planets' do

    container Window do
      title 'Planets Scenario Test'

      width 848
      height 640
    end

    scene :default_scene => Scene do

      timer_frequency 20

      # Orbits

      object :first_orbit => Circle do
        scale 1

        jagged true

        angle :y => 90
      end

      object :second_orbit => Circle do
        scale 2

        jagged true

        angle :y => 90
      end

      object :third_orbit => Circle do
        scale 4

        jagged true

        angle :y => 90
      end

      # ----------

      # Star and planets

      object :star => Sphere do
        radius 0.5

        color 1, 0, 0

        lighted false
      end

      object :star_light => Light

      object :first_planet => Sphere do
        radius 0.3

        color 0, 0, 1

        timer_strategies << strategies[:motion/:circular_motion, [:x, :z], 1, 1]
      end

      object :second_planet => Sphere do
        radius 0.3

        color 0, 1, 0

        timer_strategies << strategies[:motion/:circular_motion, [:x, :z], 1.5, 2]
      end

      object :third_planet => Sphere do
        radius 0.5

        color 0, 1, 1

        timer_strategies << strategies[:motion/:circular_motion, [:x, :z], 2, 4]
      end

      object :satellite => Sphere do
        radius 0.3

        color 1, 1, 1

        timer_strategies << strategies[:motion/:circular_motion, [:x, :z], 2, 4]

        timer_strategies << strategies[:motion/:circular_motion, [:x, :z], 4, 1.5, true]
      end

      # ----------

      # Axes (test)

      object :x_axe => Axe do
        angle :z => 90

        color 1, 0, 0
      end

      object :y_axe => Axe do
        color 0, 1, 0
      end

      object :z_axe => Axe do
        angle 90, 90

        color 0, 0, 1
      end

      # ----------

      initialization_strategies << strategies[:scene/:initialization/:light] << lambda do
        scale 0.35; angle 0, 20, 0
      end

      timer_strategies << strategies[:scene/:timer/:rotation_and_scale]

      mouse_button_strategies << strategies[:scene/:mouse_button/:rotation_and_scale]
      mouse_motion_strategies << strategies[:scene/:mouse_motion/:rotation_and_scale]
    end

  end

end
