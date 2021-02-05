require_relative 'carriage'
class CargoCarriage < Carriage
  attr_reader :bearing_capacity

  def initialize(bearing_capacity = standart_capacity)
    @cargo = []
    @type = :cargo
    @bearing_capacity = bearing_capacity
  end

  def standrart_capacity
    500
  end
end
