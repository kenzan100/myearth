class PlayerAI
  attr_accessor :world, :animals, :name, :available_resources
  def initialize(world:, name:)
    @world = world
    @name = name
    @available_resources = ResourceMap.new
    @animals = {}
  end

  def take_turn
    world_animal = spot_world_animal(world)
    try_group_habitat_animal(world_animal) if world_animal
    try_capture_animal(world_animal) if world_animal
    nurture_resource
  end

  def add(animal)
    @animals[animal] ||= 0
    @animals[animal] += 1
  end

  def to_s
    "
#{name.capitalize} Animals:\n#{AnimalManager.to_s(animals)}
#{name.capitalize} Resources Left:\n#{available_resources.to_s}
#{name.capitalize} Total Power: #{total_power}
    "
  end

  def total_power
    animals.reduce(0) do |acc, (animal, cnt)|
      acc += (animal.power * cnt)
    end
  end

  private

  def nurture_resource
    @available_resources.add_to_random(vol: rand(3))
  end

  def spot_world_animal(world)
    return if world.animals.empty?
    world.animals.to_a[rand(world.animals.length)].first
  end

  def try_capture_animal(animal)
    if available_resources.enough_resource_for?(animal)
      WorldManager.transfer_animal(from: world, to: self, animal: animal)
    end
  end

  def try_group_habitat_animal(animal)
    ecosystem = Ecosystem.new(player: self)
    group_target, discount = ecosystem.group_habitat_check(animal)

    if group_target
      WorldManager.transfer_animal(from: world, to: self, animal: animal, discount: discount)
    end
  end
end
