require 'pry-byebug'

require_relative 'base_world'
require_relative 'players/player_ai'
require_relative 'animals/animal'
require_relative 'resources/resource'

class WorldRunner
  attr_accessor :base, :players
  def initialize
    @turn_cnt = 0
    @base = BaseWorld.new
    @players = []
    @players << PlayerAI.new(name: "AI", world: base)
    @players << PlayerAI.new(name: "Yuta", world: base)
  end

  def run
    while true
      WorldManager.take_turn(world: base, players: players)
      puts "=====Turn #{@turn_cnt}====="
      puts base.to_s
      puts players.map(&:to_s).join("\n")
      sleep 1
      @turn_cnt += 1
    end
  end
end

WorldRunner.new.run
