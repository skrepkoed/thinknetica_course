class CargoCarriage < Carriage
  attr_accessor :bearing_capacity

  def initialize(bearing_capacity = standart_capacity)
    @cargo = Hash.new { |cargo, cargo_type| cargo[cargo_type] = [] }
    @type = :cargo
    @bearing_capacity = bearing_capacity
  end

  def standrart_capacity
    500
  end
end
