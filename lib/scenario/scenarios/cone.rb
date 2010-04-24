module Scenario

  scenario 'Cone' do

    container Window do
      title  'Cone Scenario Test'

      width  640
      height 640
    end

    scene :default_scene => Scene do

      object Cone do
        scale 0.5

        color 0.3, 0.5, 0

        quality 50
      end

      initialization_strategies << strategies[:scene/:initialization/:light]

      idle_strategies << strategies[:scene/:timer/:rotation_and_scale]

      mouse_button_strategies << strategies[:scene/:mouse_button/:rotation_and_scale]
      mouse_motion_strategies << strategies[:scene/:mouse_motion/:rotation_and_scale]
    end

  end

end
