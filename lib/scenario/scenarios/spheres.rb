module Scenario

  scenario 'Spheres' do

    container Window do
      title  'Spheres Scenario Test'

      width  848
      height 640
    end

    scene :default_scene => Scene do

      timer_frequency 20

      object :first_orbit => Circle do
        scale 0.8
      end

      object :second_orbit => Circle do
        scale 0.8

        angle :x => 90
      end

      object :third_orbit => Circle do
        scale 0.8

        angle :y => 90
      end

      object :center_sphere => Sphere do
        radius 0.5

        color 1, 0, 0
      end

      object :first_sphere => Sphere do
        radius 0.2

        color 0, 0, 1
        lighted false

        timer_strategies << strategies[:motion/:circular_motion, [:x, :z], 1, 0.8]
      end

      object :second_sphere => Sphere do
        radius 0.2

        color 0, 1, 0
        lighted false

        timer_strategies << strategies[:motion/:circular_motion, [:x, :y], 2, 0.8]
      end

      object :third_sphere => Sphere do
        radius 0.2

        color 0, 1, 1
        lighted false

        timer_strategies << strategies[:motion/:circular_motion, [:y, :z], 3, 0.8]
      end

      object :first_light => Light do
        ambient  0, 0, 1, 1
        specular 1, 1, 1, 1

        timer_strategies << strategies[:motion/:circular_motion, [:x, :z], 1, 0.8]
      end

      object :second_light => Light do
        ambient  0, 1, 0, 1
        specular 1, 1, 1, 1

        timer_strategies << strategies[:motion/:circular_motion, [:x, :y], 2, 0.8]
      end

      object :third_light => Light do
        ambient  0, 1, 1, 1
        specular 1, 1, 1, 1

        timer_strategies << strategies[:motion/:circular_motion, [:y, :z], 3, 0.8]
      end

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

      object :horizontal_plane => Plane do
        step 0.1, 0.1

        color 0.2, 0.2, 0.2
      end

      object :vertical_plane => Plane do
        step 0.2, 0.2

        angle 90, 90

        color 0.2, 0.2, 0.2
      end

      initialization_strategies << strategies[:scene/:initialization/:light]

      initialization_strategies << lambda do
        angle 143.0, -147.5, 89.0
      end

      timer_strategies << strategies[:scene/:timer/:rotation_and_scale]

      mouse_button_strategies << strategies[:scene/:mouse_button/:rotation_and_scale]
      mouse_motion_strategies << strategies[:scene/:mouse_motion/:rotation_and_scale]
    end

  end

end
