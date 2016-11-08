class AnimalManager
  def self.choose_random
    Animal.all[rand(Animal.all.length)]
  end

  def self.to_s(animals)
    animals.map do |animal, cnt|
      "#{animal.name} * #{cnt}"
    end.join("\n")
  end
end

class Animal
  attr_accessor :name, :power, :required_resource_cnt, :resource_color
  def initialize(name: 'Sample Animal', power: 1, required_resource_cnt: 1, resource_color:)
    @name, @power, @required_resource_cnt = name, power, required_resource_cnt
    @resource_color = resource_color
  end

  def ==(other)
    self.class === other and
      other.name == name
  end
  alias eql? ==

  def hash
    name.hash
  end

  def self.all
    [new(name: 'American Bython', power: 3, required_resource_cnt: 3, resource_color: :land),
     new(name: 'Chipmunk', power: 1, required_resource_cnt: 1, resource_color: :land),
     new(name: 'Waterweed', power: 1, required_resource_cnt: 1, resource_color: :river)]
  end
end
