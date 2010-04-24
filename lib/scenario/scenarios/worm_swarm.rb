module Scenario

  scenario 'Worm Cloud' do

    container Window do
      title  'Worm Cloud Scenario Test'

      width  640
      height 640
    end

    scene :default_scene => Scene do

      object :worm_in_center => Worm do
        length 10
        center 0, 0
        scale  0.1

        line_width 3
      end

      1.upto 5 do |i|
        0.rotate :to => 330, :by => 30 do |x, y|

          object :another_worm => Worm do
            length 30

            center x * i / 5.0, y * i / 5.0
            scale  i / 20.0

            line_width i
            color i / 4.0, 0, 0
          end

        end
      end

      reshape_strategies [strategies[:scene/:reshape/:orthogonal]]

    end

  end

end
