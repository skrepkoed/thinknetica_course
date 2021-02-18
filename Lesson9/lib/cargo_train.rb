# frozen_string_literal: true

require_relative 'train'
class CargoTrain < Train
  include Validations::CargoTrainValidations
  def initialize(train_company, number)
    super(train_company, number)
    @type = :cargo
  end

  def total_bearing_capacity
    carriages.map(&:bearing_capacity).sum
  end
end
