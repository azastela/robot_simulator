require_relative 'lib/robot_service'

robot_service = RobotService.new

def call_and_rescue
  yield if block_given?
rescue => e
  puts e.to_s
end

puts 'Input from file or from console(f|c)?:'
input_source = gets.chomp

if input_source == 'f' || input_source == 'file'
  puts 'Enter file name. It should be in source directory of the project:'
  filename = gets.chomp
  call_and_rescue do
    File.open(filename, 'r').each do |line|
      robot_service.perform(line.chomp) unless line.chomp.empty?
    end
  end
elsif input_source == 'c' || input_source == 'console'
  while true do
    puts 'Enter command(blank input will cause game exit):'
    command = gets.chomp
    if command.empty?
      break
    else
      call_and_rescue do
        robot_service.perform(command)
      end
    end
  end
else
  puts 'Invalid input source. You could only choose from file(f) or console(c)'
end
