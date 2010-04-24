module Scenario

  scenario 'Pipe' do

    container Window do
      title  'Pipe Scenario Test'

      width  640
      height 640
    end

    scene :default_scene => Scene do

      object Pipe do
        color 0, 0.5, 1
      end

      initialization_strategies << strategies[:scene/:initialization/:light]

      idle_strategies << strategies[:scene/:timer/:rotation_and_scale]

      mouse_button_strategies << strategies[:scene/:mouse_button/:rotation_and_scale]
      mouse_motion_strategies << strategies[:scene/:mouse_motion/:rotation_and_scale]
    end

  end

end
