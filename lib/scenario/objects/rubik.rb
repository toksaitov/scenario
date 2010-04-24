#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Scenario

  class Rubik < Generic
    Block = Struct.new(:color, :texture)

    SIDES = {0 => [[:x, :y], [ 0,  0, -1]],
             1 => [[:x, :z], [ 0, -1,  0]],
             2 => [[:x, :y], [ 0,  0,  3]],
             3 => [[:x, :z], [ 0,  3,  0]],
             4 => [[:z, :y], [ 3,  0,  0]],
             5 => [[:z, :y], [-1,  0,  0]]}

    meta_accessor :speed

    meta_accessor :colors, :textures

    attr_reader :structure, :working

    def initialize
      @block = [Cube, lambda { scale 0.4 }]
      @core  = [Cube, lambda { scale 1; color 0, 0, 0 }]

      @colors = [[1, 0, 0],
                 [0, 0, 1],
                 [0, 1, 0],
                 [1, 1, 1],
                 [0, 1, 1],
                 [1, 1, 0]]

      @textures = []

      @speed = 6

      super

      initialize_structure()
      initialize_objects()

      @working = false
      @container = nil

      @rotation_specs = []

      idle_strategies << method(:update)
    end

    def block(*args, &block)
      unless args.empty?
        @block = [args.first, block]
      end

      @block
    end

    def core(*args, &block)
      unless args.empty?
        @core = [args.first, block]
      end

      @core
    end

    def textures(*args)
      @textures ||= []

      if args.size == 1
        arg = args.first

        case arg
          when Array
            @textures = arg
          when Hash
            rules = {:first => 0, :second => 1,
                     :third => 2, :fourth => 3,
                     :fifth => 4, :sixth  => 5}

            arg.each do |key, texture|
              (@textures[rules[key]] = texture) rescue nil
            end
          when String
            @textures = extract_textures(arg)
        end
      elsif args.size > 1
        @textures = args
      end

      @textures
    end

    def rotate(how, direction, row)
      result = false

      unless @working
        @working = result = true

        process_move(@structure.rotate(how, direction, row))
      end

      result
    end

    def randomize
      result = false

      unless @working
        @working = result = true

        process_move(@structure.randomize())
      end

      result
    end

    def solved?
      @structure.solved?
    end

    def paint
      apply_color()
      apply_line_width()
      apply_pattern()

      apply_lighting_status()

      glPushMatrix()
        apply_position()
        apply_rotation()
        apply_scale()

        notify(:@objects, :on_display_event)
      glPopMatrix()

      restore_lighting_status()
    end

    private
    def process_move(blocks)
      initialize_container(blocks)
      initialize_objects()
    end

    def update
      if @working and @container and @rotation_specs
        case @rotation_specs.second
          when :forward
            operation = :-
          when :backward
            operation = :+
          else
            return
        end

        case @rotation_specs.first
          when :horizontally
            angle = :y
          when :vertically
            case @rotation_specs.third
              when 0..2
                angle = :x
              when 3..5
                angle = :z
                operation = (operation == :- ? :+ : :-)
              else
                return
            end
          else
            return
        end

        @container.angle(angle => (@container.angle(angle).send(operation, @speed)))

        if @container.angle(angle).abs >= 90
          @container.angle(angle => 90 * (@container.angle(angle) < 0 ? -1 : 1))

          @working = false
          @container = nil
          @rotation_specs = nil

          initialize_objects()

          @structure.update()
        end
      end
    end

    def initialize_structure
      @structure = RubikStructure.new

      sides = initialize_side_faces()
      6.times do |id|
        3.times do |i|
          3.times do |j|
            @structure.blocks[id].ids[i][j] = sides[id][i][j]
          end
        end
      end

      @structure.on_update do |group|
        3.times do |i|
          3.times do |j|
            block = group.ids[i][j]

            group.objects[i][j].color(*block.color)
            group.objects[i][j].texture(block.texture)
          end
        end
      end

      6.times do |id|
        side = SIDES[id]

        3.times do |i|
          3.times do |j|
            block = @block.first.new(&@block.second)

            if [1, 2].include?(id)
              block.position(side[0].first => i,
                             side[0].second => 2 - j)
            else
              block.position(side[0].first => i,
                             side[0].second => j)
            end

            block.position(block.x + side[1].first - 1,
                           block.y + side[1].second - 1,
                           block.z + side[1].third - 1)

            block.color(*side.third)

            @structure[id].objects[i][j] = block
          end
        end
      end

      @structure.update()
      @structure
    end

    #noinspection RubyScope,RubyDynamicConstAssignment
    def initialize_side_faces
      result = Array.new(6)

      6.times do |id|
        color = colors[id]

        texture = textures[id]
        if texture.is_a?(String)
          texture = Image.read(texture).first
        end

        if texture
          part_width  = texture.columns / 3
          part_height = texture.rows / 3
        end

        result[id] = Array.new(3) { Array.new(3) }

        3.times do |i|
          3.times do |j|
            texture_part = nil

            if texture
              texture_part = Texture2D.new do
                image(ImageProxy[texture.crop(j * part_width, i * part_height, part_width, part_height)])
              end
            end

            result[id][i][j] = Block.new(color, texture_part)
          end
        end
      end

      result
    end

    def extract_textures(texture)
      result = []

      if texture.is_a?(String)
        texture = Image.read(texture).first
      end

      if texture
        part_width  = texture.columns / 6
        part_height = texture.rows

        6.times do |side|
          texture_part = texture.crop(side * part_width, 0, part_width, part_height, true)

          result[side] = texture_part if texture_part
        end
      end

      result
    end

    def initialize_container(blocks)
      @container = Container.new
      @rotation_specs = blocks.first

      blocks.last.each do |block|
        side, i, j = block; @container.object(@structure[side].objects[i][j])
      end

      @container
    end

    def initialize_objects
      @objects = [@core.first.new(&@core.second)] if @core

      6.times do |side|

        3.times do |i|
          3.times do |j|
            object = @structure[side].objects[i][j]

            unless @container and @container.objects.include?(object)
              @objects << object
            end
          end
        end
      end

      @objects << @container if @container
      @objects
    end
  end

  class RubikStructure
    HORIZONTAL_FORWARD_SHIFTS  = [[3, 0], [2, 3], [1, 2], [0, 1]]
    HORIZONTAL_BACKWARD_SHIFTS = [[1, 0], [2, 1], [3, 2], [0, 3]]

    VERTICAL_FORWARD_SHIFTS  = [[5, 0], [2, 5], [4, 2], [0, 4]]
    VERTICAL_BACKWARD_SHIFTS = [[4, 0], [2, 4], [5, 2], [0, 5]]

    VERTICAL_FORWARD_SIDE_SHIFTS  = [[5, 1], [3, 5], [4, 3], [1, 4]]
    VERTICAL_BACKWARD_SIDE_SHIFTS = [[4, 1], [3, 4], [5, 3], [1, 5]]

    RULES = {:horizontally => {:forward  => {0 => {:shift => HORIZONTAL_FORWARD_SHIFTS,  :rotate => [[5, 3]]},
                                             1 => {:shift => HORIZONTAL_FORWARD_SHIFTS},
                                             2 => {:shift => HORIZONTAL_FORWARD_SHIFTS,  :rotate => [[4, 3]]}},

                               :backward => {0 => {:shift => HORIZONTAL_BACKWARD_SHIFTS, :rotate => [[5, 1]]},
                                             1 => {:shift => HORIZONTAL_BACKWARD_SHIFTS},
                                             2 => {:shift => HORIZONTAL_BACKWARD_SHIFTS, :rotate => [[4, 1]]}}},

             :vertically   => {:forward  => {0 => {:shift => VERTICAL_FORWARD_SHIFTS,  :rotate => [[1, 1]]},
                                             1 => {:shift => VERTICAL_FORWARD_SHIFTS},
                                             2 => {:shift => VERTICAL_FORWARD_SHIFTS,  :rotate => [[3, 3]]},

                                             3 => {:shift => VERTICAL_FORWARD_SIDE_SHIFTS, :rotate => [[2, 1]]},
                                             4 => {:shift => VERTICAL_FORWARD_SIDE_SHIFTS},
                                             5 => {:shift => VERTICAL_FORWARD_SIDE_SHIFTS, :rotate => [[0, 3]]}},

                               :backward => {0 => {:shift => VERTICAL_BACKWARD_SHIFTS, :rotate => [[1, 3]]},
                                             1 => {:shift => VERTICAL_BACKWARD_SHIFTS},
                                             2 => {:shift => VERTICAL_BACKWARD_SHIFTS, :rotate => [[3, 1]]},

                                             3 => {:shift => VERTICAL_BACKWARD_SIDE_SHIFTS, :rotate => [[2, 3]]},
                                             4 => {:shift => VERTICAL_BACKWARD_SIDE_SHIFTS},
                                             5 => {:shift => VERTICAL_BACKWARD_SIDE_SHIFTS, :rotate => [[0, 1]]}}}}

    Block = Struct.new(:ids, :objects)

    attr_accessor :blocks, :update_proc

    def initialize
      srand(Time.now.to_i())

      @blocks = {}
      6.times do |i|
        @blocks[i] = Block.new(Array.new(3) { Array.new(3, i) },
                               Array.new(3) { Array.new(3) })
      end

      @update_proc = nil
    end

    def [](side)
      @blocks[side]
    end

    def on_update(&block)
      @update_proc = block if block_given?
    end

    def rotate(how, direction, arg)
      row   = arg.is_a?(Hash) ? (arg[:row] || arg[:column]) : arg
      tasks = RULES[how][direction][row]

      result = [[how, direction, row], []]

      result[1] += perform_shift_tasks(tasks[:shift], how, row)
      result[1] += perform_rotation_tasks(tasks[:rotate])

      result
    end

    def randomize
      how = [:horizontally, :vertically].sample
      direction = [:forward, :backward].sample

      row = (how == :horizontally ? (0..2).random.round().to_i() :
                                    (0..5).random.round().to_i())

      rotate(how, direction, row)
    end

    def solved?
      result = true

      6.times do |side|
        ids = @blocks[side].ids

        first_block = ids[0].first

        3.times do |i|
          3.times do |j|
            (result = false; break) if ids[i][j] != first_block
          end
        end

        break unless result
      end

      result
    end

    def update
      @blocks.each do |key, group|
        @update_proc.call(group) if @update_proc
      end
    end

    private
    def perform_shift_tasks(task, how, row)
      result = []

      task.try(:each) do |shift|
        3.times do |i|
          consumer = @blocks[shift.second].ids
          producer = @blocks[shift.first].ids

          case how
            when :horizontally
              consumer_column = producer_column = row
              consumer_row = producer_row = i
            when :vertically
              consumer_column = producer_column = i
              consumer_row = producer_row = row

              if row > 2
                actual_row = row % 3

                case shift.second
                  when 3
                    consumer_column = 2 - i
                    consumer_row = 2 - actual_row
                  when 4
                    consumer_row = i
                    consumer_column = 2 - actual_row
                  when 5
                    consumer_row = 2 - i
                    consumer_column = 2 - actual_row
                  else
                    consumer_row = actual_row
                end

                case shift.first
                  when 3
                    producer_column = 2 - i
                    producer_row = 2 - actual_row
                  when 4
                    producer_row = i
                    producer_column = 2 - actual_row
                  when 5
                    producer_row = 2 - i
                    producer_column = 2 - actual_row
                  else
                    producer_row = actual_row
                end
              else
                consumer_column = [2, 5].include?(shift.second) ? 2 - i : i
                producer_column = [2, 5].include?(shift.first) ? 2 - i : i

                consumer_row = shift.second == 2 ? 2 - row : row
                producer_row = shift.first == 2 ? 2 - row : row
              end
            else
              return
          end

          consumer = consumer[consumer_column]
          producer = producer[producer_column]

          if producer[producer_row].is_a?(Array)
            consumer[consumer_row] = [consumer[consumer_row],
                                      producer[producer_row].first]

            result << [shift.second, consumer_column, consumer_row]
          else
            consumer[consumer_row] = [consumer[consumer_row],
                                      producer[producer_row]]

            result << [shift.second, consumer_column, consumer_row]
          end
        end
      end

      normalize_blocks(result)

      result
    end

    def normalize_blocks(blocks)
      blocks.each do |block|
        row = @blocks[block.first].ids[block.second]

        if row[block.third].is_a?(Array)
          row[block.third] = row[block.third].last
        end
      end
    end

    def perform_rotation_tasks(tasks)
      result = []

      tasks.try(:each) do |rotation|
        rotate_side!(@blocks[rotation.first].ids, rotation.last)

        3.times do |i|
          3.times do |j|
            result << [rotation.first, i, j]
          end
        end
      end

      result
    end

    def rotate_side!(container, rotations = 1)
      result = container

      rotations.times do
        helper = []

        3.times do |i|
          helper[i] = []

          3.times do |j|
            helper[i][j] = result[result.size - j - 1][i]
          end
        end

        result = helper
      end

      3.times do |i|
        3.times do |j|
          container[i][j] = result[i][j]
        end
      end

      container
    end
  end

end
