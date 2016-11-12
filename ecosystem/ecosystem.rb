class Ecosystem
  extend Forwardable

  attr_accessor :player
  def initialize(player:)
    @player = player
  end

  def_delegators :@player, :animals, :resource_map

  def group_habitat_check(animal)
    predators = animals.keys.select { |pred_candid| pred_candid.eat?(animal) }
    foods = animals.keys.select { |food_candid| animal.eat?(food_candid) }

    max_diff = predators.first.required_resource_cnt - animal.required_resource_cnt
    group_target = ([predators] + [foods]).reduce(predators.first) do |target, candid|
      this_diff = candid.required_resource_cnt - animal.required_resource_cnt
      if this_diff > max_diff
        max_diff = this_diff
        target = candid
      end
      target
    end

    discount = animal.required_resource_cnt - group_target.required_resource_cnt

    return [nil, nil] if discount > 0 && resource_map.enough_resource_for?(animal, discount)

    [group_target, extra_required_resource_cnt]
  end
end
