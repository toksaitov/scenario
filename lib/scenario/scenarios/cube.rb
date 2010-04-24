module Scenario

  scenario 'Cube' do
    assets = DIRS[:assets]

    container Window do
      title  'Cube Scenario Test'

      width  640
      height 640
    end

    scene :default_scene => Scene do

      object :first_cube => Cube do
        scale 0.5

        texture Texture2D do
          image ImageProxy.read("#{assets}/cube/ruby.tga")
        end
      end

      initialization_strategies << strategies[:scene/:initialization/:light]

      idle_strategies << strategies[:scene/:timer/:rotation_and_scale]

      mouse_button_strategies << strategies[:scene/:mouse_button/:rotation_and_scale]
      mouse_motion_strategies << strategies[:scene/:mouse_motion/:rotation_and_scale]
    end

  end

end
