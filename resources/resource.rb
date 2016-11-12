class ResourceMap
  def initialize
    @map = { land: 0, sea: 0, river: 0 }
  end

  def add_to_random(vol:)
    key = @map.keys[rand(@map.keys.length)]
    @map[key] += vol
  end

  def enough_resource_for?(animal, discount: 0)
    (animal.required_resource_cnt - discount) <= cnt_map_for(animal)
  end

  def subtract_for(animal, discount: 0)
    @map[animal.resource_color] -= (animal.required_resource_cnt - discount)
    @map[animal.resource_color] = 0 if @map[animal.resource_color] < 0
  end

  def to_s
    @map.map { |k, v| "#{k} : #{v}"}.join("\n")
  end

  private

  def cnt_map_for(animal)
    return 0 unless @map[animal.resource_color]
    @map[animal.resource_color]
  end
end
