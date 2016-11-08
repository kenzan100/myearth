require 'pry-byebug'

class Animal
  attr_accessor :name, :power, :required_resource_cnt
  def initialize(name: 'Sample Animal', power: 1, required_resource_cnt: 1)
    @name, @power, @required_resource_cnt = name, power, required_resource_cnt
  end

  def self.all
    [new(name: 'American Bython', power: 3, required_resource_cnt: 3),
     new(name: 'Chipmunk', power: 1, required_resource_cnt: 1)]
  end
end

class AnimalManager
  def self.choose_random
    Animal.all[rand(Animal.all.length)]
  end

  def self.get_names(animals)
    animals.map(&:name)
  end
end

class PlayerAI
  attr_accessor :world, :animals, :name, :available_resources
  def initialize(world:, name:)
    @world = world
    @name = name
    @available_resources = 0
    @animals = []
  end

  def take_turn
    world_animal = spot_world_animal(world)
    try_capture_animal(world_animal) if world_animal
    nurture_resource
  end

  def add(animal)
    @animals << animal
  end

  def to_s
    "
#{name.capitalize} Animals: #{AnimalManager.get_names(animals).join(', ')}
#{name.capitalize} Resources Left: #{available_resources}
#{name.capitalize} Total Power: #{total_power}
    "
  end

  def total_power
    animals.map(&:power).reduce(:+)
  end

  private

  def nurture_resource
    @available_resources += 1
  end

  def spot_world_animal(world)
    world.animals[rand(world.animals.length)]
  end

  def try_capture_animal(world_animal)
    if enough_resource_for?(world_animal)
      WorldManager.transfer_animal(from: world, to: self, animal: world_animal)
    end
  end

  def enough_resource_for?(animal)
    animal.required_resource_cnt <= available_resources
  end
end

class WorldManager
  def self.transfer_animal(from:, to:, animal:)
    # TODO: Make it transactional (take lock)
    from.subtract(animal)
    to.add(animal)
    to.available_resources -= animal.required_resource_cnt
  end

  def self.take_turn(world:, players:)
    world.take_turn
    players.shuffle.each { |p| p.take_turn }
  end
end

class BaseWorld
  attr_accessor :animals

  def initialize
    @animals = []
  end

  def take_turn
    spawn_creature
  end

  def to_s
    "World Animals: #{AnimalManager.get_names(animals).join(', ')}"
  end

  def subtract(animal)
    index = @animals.index animal
    @animals.delete_at index
  end

  private

  def spawn_creature
    animal = AnimalManager.choose_random
    add(animal)
  end

  def add(animal)
    @animals << animal
  end

end

base = BaseWorld.new
player1 = PlayerAI.new(name: "AI", world: base)
player2 = PlayerAI.new(name: "Yuta", world: base)
while true
  WorldManager.take_turn(world: base, players: [player1, player2])
  puts base.to_s
  puts player1.to_s
  puts player2.to_s
  sleep 1
end
