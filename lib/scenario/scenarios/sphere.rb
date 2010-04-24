module Scenario

  scenario 'Sphere' do

    container Window do
      title  'Sphere Scenario Test'

      width  640
      height 640
    end

    scene :default_scene => Scene do
  
      object Sphere do
        radius 0.5

        color 1, 0, 0
      end

      initialization_strategies << strategies[:scene/:initialization/:light]
    end

  end

end
