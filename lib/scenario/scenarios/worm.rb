module Scenario

  scenario 'Worm' do

    container Window do
      title  'Worm Scenario Test'

      width  480
      height 480
    end

    scene :default_scene => Scene do

      object Worm do
        length 50
      end

      reshape_strategies [strategies[:scene/:reshape/:orthogonal]]

    end

  end

end
