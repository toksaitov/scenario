module Scenario

  scenario 'Clocks' do

    container Window do
      title  'Clocks Scenario Test'

      width  640
      height 480
    end

    scene :default_scene => Scene do

      timer_frequency 1000

      # Clock frames

      0.rotate :to => 330, :by => 30 do |x, y, i|

        object Cube do
          position x * 3, y * 3

          scale 0.2

          if [0, 90, 180, 270].include? i
            color 1, 1, 1
          else
            color 1, 0, 0
          end
        end

        object Line do
          x1 x * 0.4; y1 y * 0.4
          x2 x * 2.5; y2 y * 2.5

          line_width 4
          pattern 0xF0F0

          color 0.1, 0.1, 0.1
        end

        unless [0, 90, 180, 270].include? i
          object Cube do
            position x * 12, y * 12, 0.3

            scale 0.25, 0.25, 0.04

            angle :z => 45

            color 1, 1, 1
          end
        end

      end

      0.rotate :to => 354, :by => 6 do |x, y|

        object Cube do
          position x * 2.5, y * 2.5

          scale 0.05

          color 1, 0, 0
        end

      end

      # ----------

      # Center pin

      object :center_basement => Cone do
        z 0.3

        scale 0.4, 0.4, 0.08

        angle :y => 180

        color 1, 1, 1
      end

      object :center_pin => Pipe do
        z -0.17

        scale 0.18, 0.18, 2.8

        color 1, 0, 0
      end

      object :center_cone => Cone do
        z -0.60

        scale 0.18, 0.18, 0.1

        angle :y => 180

        quality 20

        color 1, 0, 0
      end

      object :center_circle => Circle do
        scale 0.4, 0.4

        quality 60

        line_width 4

        color 0.1, 0.1, 0.1

        jagged true
      end

      # ----------

      # Clocks hands

      object :second_hand => Pipe do
        z -0.60

        scale 0.05, 0.05, 7

        angle :y => 90

        color 1, 0, 0

        timer_strategies << strategies[:pile/:time_following, [:x, :y], :second]
      end

      object :second_cone => Cone do
        position 2, 2, -0.60

        scale 0.1

        angle :y => 90

        color 1, 0, 0

        timer_strategies << strategies[:pile/:time_following, [:x, :y], :second, 2]
      end

      object :minute_hand => Pipe do
        scale 0.09, 0.09, 5.7

        z -0.40
        angle :y => 90

        color 1, 1, 1

        timer_strategies << strategies[:pile/:time_following, [:x, :y], :minute, 0.9]
      end

      object :minute_cone => Cone do
        position 2, 2, -0.40

        scale 0.125

        angle :y => 90

        color 1, 0, 0

        timer_strategies << strategies[:pile/:time_following, [:x, :y], :minute, 1.75]
      end

      object :hour_hand => Pipe do
        position 0.8, 0.8, -0.19

        scale 0.1, 0.1, 4.5

        angle :y => 90

        color 1, 1, 1

        timer_strategies << strategies[:pile/:time_following, [:x, :y], :hour, 0.7]
      end

      object :hour_cone => Cone do
        position 1.55, 1.55, -0.19

        scale 0.145

        angle :y => 90

        color 1, 0, 0

        timer_strategies << strategies[:pile/:time_following, [:x, :y], :hour, 1.4]
      end

      # ----------

      # Clock outer frames

      0.rotate :to => 270, :by => 90 do |x, y, i|

        object Line do
          x1 x * 4;   y1 y * 4
          x2 x * 9.5; y2 y * 9.5

          pattern 0xF0F0

          color 1, 1, 1
        end

        object Cone do
          position x * 4, y * 4

          scale 0.3

          angle i + 90, 90, 0

          color 1, 0, 0

          quality 20
        end

        object Cube do
          position x * 12, y * 12,  0.3

          scale 0.6, 0.6, 0.04

          angle :z => 45

          color 1, 0, 0
        end

      end

      # ----------

      # Orbits

      object :first_orbit => Circle do
        scale 5.5

        angle :z => -15

        quality 12

        color 0.15, 0.15, 0.15

        jagged true
      end

      object :second_orbit => Circle do
        scale 7.5

        angle :z => -15

        quality 60

        color 0.3, 0.3, 0.3

        jagged true
      end

      object :third_orbit => Circle do
        scale 9.5

        angle :z => -15

        quality 60

        line_width 3

        color 1, 0, 0

        jagged true
      end

      object :third_solid_orbit => Circle do
        scale 9.5

        z 0.005

        angle :z => -15

        line_width 3

        color 0.5, 0, 0
      end

      # ----------

      # Planets

      object :hour_planet => Sphere do
        position 5.5, 5.5

        radius 0.6

        color 1, 1, 1

        timer_strategies << strategies[:pile/:time_following, [:x, :y], :hour, 5.5]
      end

      object :minute_planet => Sphere do
        position 7.5, 7.5

        radius 0.4

        color 1, 1, 1

        timer_strategies << strategies[:pile/:time_following, [:x, :y], :minute, 7.5]
      end

      object :second_planet => Sphere do
        position 9.5, 9.5

        radius 0.35

        color 1, 0, 0

        timer_strategies << strategies[:pile/:time_following, [:x, :y], :second, 9.5]
      end

      # ----------

      # Radar-like lines

      80.times do |i|
        offset = 1 - i / 80.0

        object Line do
          x2 5.5;  y2 5.5
          z1 0.08; z2 0.08

          angle :z => -i * 2.4

          line_width offset * 3

          color 0.3, 0.3, 0.3, offset

          timer_strategies << strategies[:pile/:time_following, [:x1, :y1], :hour, 3, :linear]\
                           << strategies[:pile/:time_following, [:x2, :y2], :hour, 5.5, :linear]
        end

        object Line do
          x2 7.5;  y2 7.5
          z1 0.04; z2 0.04

          angle :z => -i * 2.4

          line_width offset * 3

          color 0.3, 0.3, 0.3, offset

          timer_strategies << strategies[:pile/:time_following, [:x1, :y1], :minute, 3, :linear]\
                           << strategies[:pile/:time_following, [:x2, :y2], :minute, 7.5, :linear]
        end

        object Line do
          x2 9.5;  y2 9.5
          z1 0.01; z2 0.01

          angle :z => -i * 2.3

          line_width offset * 3

          color 0.3, 0.0, 0.0, offset

          timer_strategies << strategies[:pile/:time_following, [:x1, :y1], :second, 3, :linear]\
                           << strategies[:pile/:time_following, [:x2, :y2], :second, 9.5, :linear]
        end
      end

      # ----------

      # Pendulums

      object :first_pendulum_holder => Line do
        x2 -20; z1 0.28; z2 0.28

        line_width 2

        color 0.3, 0.3, 0.3

        idle_strategies << strategies[:motion/:periodic_motion, [:y2], :sin, 5, 7]
      end

      object :first_pendulum_circle => Circle do
        position :x => -20, :z => 0.25

        angle :y => 180

        scale 2.2, 2.2, 0.1

        color 1, 0, 0

        idle_strategies << strategies[:motion/:periodic_motion, [:y], :sin, 5, 7]
      end

      object :first_pendulum_center => Cube do
        position :x => -20, :z => 0.15

        angle :z => 45

        scale 1.2, 1.2, 0.3

        color 1, 0, 0

        idle_strategies << strategies[:motion/:periodic_motion, [:y], :sin, 5, 7]
      end

      object :second_pendulum_holder => Line do
        x2 -15; z1 0.28; z2 0.28

        line_width 2

        color 0.3, 0.3, 0.3

        idle_strategies << strategies[:motion/:periodic_motion, [:y2], :sin, -5, 5]
      end

      object :second_pendulum_circle => Circle do
        position :x => -15, :z => 0.25

        angle :y => 180

        scale 1.4, 1.4, 0.1

        color 1, 1, 1

        idle_strategies << strategies[:motion/:periodic_motion, [:y], :sin, -5, 5]
      end

      object :second_pendulum_center => Cube do
        position :x => -15, :z => 0.15

        angle :z => 45

        scale 0.8, 0.8, 0.3

        color 1, 1, 1

        idle_strategies << strategies[:motion/:periodic_motion, [:y], :sin, -5, 5]
      end

      # ----------

      initialization_strategies << strategies[:scene/:initialization/:light] << lambda do
        scale 0.05; angle 153.5, 13.0, 90.0

        on_timer_tick_event(0)
      end

      idle_strategies << strategies[:scene/:timer/:rotation_and_scale]

      mouse_button_strategies << strategies[:scene/:mouse_button/:rotation_and_scale]
      mouse_motion_strategies << strategies[:scene/:mouse_motion/:rotation_and_scale]
    end

  end

end
