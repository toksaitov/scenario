module Scenario

  scenario 'Rubik' do

    container Window do
      title 'Rubik Scenario Test'

      width  840
      height 600
    end

    directory = DIRS[:assets]

    scene :default_scene => Scene do

      timer_frequency 1000

      object :colored_rubik => Rubik do
        position :y => -7
      end

      object :sphered_rubik => Rubik do
        position :y => 0

        core Sphere do
          scale 1.2

          color 0, 0, 0
        end

        block Sphere do
          scale 0.47
        end
  
        textures "#{directory}/rubik/sides_combination.png"
      end

      object :textured_rubik => Rubik do
        position :y => 7

        textures :first  => "#{directory}/rubik/side_combination.tga",
                 :fourth => "#{directory}/rubik/side_combination_colored.tga"
      end

      rubiks  = [:colored_rubik, :sphered_rubik, :textured_rubik]
      shuffle = true; selected_rubik = :colored_rubik

      define_method(:select_current_rubik) do
        rubiks.each { |rubik| object(rubik).scale 1 }

        object(selected_rubik).scale 1.3
      end

      initialization_strategies << strategies[:scene/:initialization/:light] << lambda do
        scale 0.15; angle 153.5, 13.0, 90.0

        select_current_rubik()
      end

      timer_strategies << proc do
        rubiks.each { |rubik| object(rubik).randomize } if shuffle
      end

      idle_strategies << strategies[:scene/:timer/:rotation_and_scale] << lambda do
        (inertia_by_x 0.1; inertia_by_y 0.1) if shuffle
      end

      keyboard_strategies << lambda do |key, x, y|
        shuffle = false

        case key
          when ?1..?3
            object(selected_rubik).rotate :horizontally, :forward, :row => (key - ?1)
          when ?4..?9
            object(selected_rubik).rotate :vertically, :forward, :row => (key - ?4)
        end
      end

      special_keyboard_strategies << lambda do |key, x, y|
        case key
          when GLUT_KEY_F1
            selected_rubik = :colored_rubik
          when GLUT_KEY_F2
            selected_rubik = :sphered_rubik
          when GLUT_KEY_F3
            selected_rubik = :textured_rubik
        end

        select_current_rubik()
      end

      mouse_button_strategies << strategies[:scene/:mouse_button/:rotation_and_scale]

      mouse_motion_strategies << strategies[:scene/:mouse_motion/:rotation_and_scale]

    end

  end

end
