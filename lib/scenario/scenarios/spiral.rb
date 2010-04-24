module Scenario

  scenario 'Spiral' do

    container Window do
      title  "Spiral Scenario Test"

      width  640
      height 640
    end

    scene :default_scene => Scene do

      object Spiral do
        windings 5
        height   1
        quality  100

        angle 30, 20, 0
      end

      idle_strategies << strategies[:scene/:timer/:rotation_and_scale]

      mouse_button_strategies << strategies[:scene/:mouse_button/:rotation_and_scale]
      mouse_motion_strategies << strategies[:scene/:mouse_motion/:rotation_and_scale]

    end

  end

end
