require 'robot_service'

RSpec.describe RobotService do

  subject(:robot_service){ RobotService.new }

  describe '#perform' do
    it 'moves robot one time' do
      robot_service.perform('PLACE 0,0,NORTH')
      robot_service.perform('MOVE')
      expect(STDOUT).to receive(:puts).with('0,1,NORTH')
      robot_service.perform('REPORT')
    end

    it 'moves robot several times' do
      robot_service.perform('PLACE 1,2,EAST')
      robot_service.perform('MOVE')
      robot_service.perform('MOVE')
      robot_service.perform('LEFT')
      robot_service.perform('MOVE')
      expect(STDOUT).to receive(:puts).with('3,3,NORTH')
      robot_service.perform('REPORT')
    end

    it 'turns robot' do
      robot_service.perform('PLACE 0,0,NORTH')
      robot_service.perform('LEFT')
      expect(STDOUT).to receive(:puts).with('0,0,WEST')
      robot_service.perform('REPORT')
    end

    context "when we move robot outside the game area" do
      it 'ignore movement for y direction' do
        robot_service.perform('PLACE 0,0,NORTH')
        robot_service.perform('MOVE')
        robot_service.perform('MOVE')
        robot_service.perform('MOVE')
        robot_service.perform('MOVE')
        robot_service.perform('MOVE')
        expect(robot_service.y).to eq(RobotService::GAME_AREA[:height] - 1)
      end
      it 'ignore movement for x direction' do
        robot_service.perform('PLACE 4,4,EAST')
        robot_service.perform('MOVE')
        expect(robot_service.x).to eq(RobotService::GAME_AREA[:width] - 1)
      end
    end

    it 'raises correct exceptions' do
      expect{ robot_service.perform('FOO') }.to raise_error("Invalid command")
      expect{ robot_service.perform('MOVE') }.to raise_error("To start game send 'PLACE' command first")
      expect{ robot_service.perform('PLACE') }.to raise_error('x coordinate is not set')
      expect{ robot_service.perform('PLACE 10') }.to raise_error('y coordinate is not set')
      expect{ robot_service.perform('PLACE 10,10') }.to raise_error('facing is not set or invalid')
      expect{ robot_service.perform('PLACE 10,10,safdsa') }.to raise_error('facing is not set or invalid')
      expect{ robot_service.perform('PLACE 100,100,EAST') }.to raise_error('New coordinates are outside the game field')
    end
  end
end
