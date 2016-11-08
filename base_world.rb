class WorldManager
  def self.transfer_animal(from:, to:, animal:)
    # TODO: Make it transactional (take lock)
    puts "NEWS: #{to.name.capitalize} acquired #{animal.name} !!"
    from.subtract(animal)
    to.add(animal)
    to.available_resources.subtract_for(animal)
  end

  def self.take_turn(world:, players:)
    world.take_turn
    players.shuffle.each { |p| p.take_turn }
  end
end

class BaseWorld
  attr_accessor :animals

  def initialize
    @animals = {}
  end

  def take_turn
    spawn_creature
  end

  def to_s
    "World Animals:\n#{AnimalManager.to_s(animals)}"
  end

  def subtract(animal)
    return unless @animals[animal]
    @animals[animal] -= 1
    @animals.delete(animal) if @animals[animal] < 1
  end

  private

  def spawn_creature
    animal = AnimalManager.choose_random
    add(animal)
  end

  def add(animal)
    @animals[animal] ||= 0
    @animals[animal] += 1
  end
end
