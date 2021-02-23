require_relative 'train'
class CargoTrain < Train
  def initialize(number)
    super(number)
    @type = :cargo
  end

  def total_bearing_capacity
    carriages.map(&:bearing_capacity).sum
  end
end
