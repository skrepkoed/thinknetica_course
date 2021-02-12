require_relative 'carriage'
class CargoCarriage < Carriage
  attr_reader :bearing_capacity, :free_capacity, :occupied_capacity

  prepend TrainCompany
  def initialize(bearing_capacity = standart_capacity, _train_company)
    super
    @cargo = []
    @type = :cargo
    @bearing_capacity = bearing_capacity
    @free_capacity = bearing_capacity
    @occupied_capacity = 0
  end

  def load_cargo(cargo_volume)
    self.free_capacity -= cargo_volume
    self.occupied_capacity += cargo_volume
  end

  protected

  attr_writer :free_capacity, :occupied_capacity

  def standrart_capacity
    500
  end
end
