class RobotService
  VALID_COMMANDS = %i(place move left right report)
  GAME_AREA = {width: 5, height: 5}
  DIRECTIONS = %i(north east south west)

  attr_reader :x, :y, :facing

  def initialize
  end

  def perform(input)
    command, params = format_input(input)
    case command
    when :place  then place(params)
    when :move   then move
    when :left   then turn(:left)
    when :right  then turn(:right)
    when :report then report
    end
  end

  private

  def report
    puts "#{x},#{y},#{facing.to_s.upcase}"
  end

  def place(params)
    validate_params!(params)
    @x, @y, @facing = format_params(params)
  end

  def format_params(params)
    [params[0].to_i, params[1].to_i, params[2].downcase.to_sym]
  end

  def validate_params!(params)
    raise 'x coordinate is not set' unless params[0]
    raise 'y coordinate is not set' unless params[1]
    raise 'facing is not set or invalid' if params[2].nil? || !DIRECTIONS.include?(params[2].downcase.to_sym)
    raise 'New coordinates are outside the game field' unless valid_coordinates?(params[0].to_i, params[1].to_i)
  end

  def turn(direction)
    current_index = DIRECTIONS.index(facing)
    new_index = direction == :left ? current_index - 1 : current_index + 1
    @facing = DIRECTIONS[new_index % DIRECTIONS.length]
  end

  def move
    newx, newy = x, y
    case facing
    when :south
      newy -= 1
    when :north
      newy += 1
    when :west
      newx -= 1
    when :east
      newx += 1
    end
    @x, @y = newx, newy if valid_coordinates?(newx, newy)
  end

  def format_input(input)
    splitted_input = input.split
    command = splitted_input.shift.downcase.to_sym
    params = splitted_input.join.split(',')
    validate_command!(command)
    [command, params]
  end

  def valid_coordinates?(x, y)
    (0..(GAME_AREA[:width] - 1)).include?(x) && (0..(GAME_AREA[:height] - 1)).include?(y)
  end

  def validate_command!(command)
    raise "Invalid command" unless VALID_COMMANDS.include?(command)
    raise "To start game send 'PLACE' command first" if command != :place && x.nil?
  end
end
