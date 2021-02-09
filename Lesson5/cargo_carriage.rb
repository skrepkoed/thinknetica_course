require_relative 'carriage'
class CargoCarriage < Carriage
  attr_reader :bearing_capacity

  prepend TrainCompany
  def initialize(bearing_capacity = standart_capacity, _train_company)
    @cargo = []
    @type = :cargo
    @bearing_capacity = bearing_capacity
  end

  protected

  def standrart_capacity
    500
  end
end
