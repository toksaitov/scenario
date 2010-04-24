module Scenario # ToDo - resolve module scope

  scenario 'Axes' do

    container Window do
      title  'Axes Scenario Test'

      width  640
      height 640
    end

    scene :default_scene => Scene do

      object :x_axe => Axe do
        angle :z => 90

        color 1, 0, 0
      end

      object :y_axe => Axe do
        color 0, 1, 0
      end

      object :z_axe => Axe do
        angle :x => 90, :z => 90

        color 0, 0, 1
      end

      object :horizontal_plane => Plane do
        step 0.1, 0.1

        color 0.2, 0.2, 0.2
      end

      object :vertical_plane => Plane do
        angle 90, 90

        step 0.2, 0.2

        color 0.2, 0.2, 0.2
      end

      object Spiral do
        windings 5
        height   1
        quality  100

        angle 30, 20, 0

        color 1, 0, 0
      end

      initialization_strategies << lambda do
        angle 38.0, 33.0, 0
      end

      idle_strategies << strategies[:scene/:timer/:rotation_and_scale]

      mouse_button_strategies << strategies[:scene/:mouse_button/:rotation_and_scale]
      mouse_motion_strategies << strategies[:scene/:mouse_motion/:rotation_and_scale]

    end

  end

end
