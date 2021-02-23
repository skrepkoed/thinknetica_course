# frozen_string_literal: true

require_relative 'train'
class PassengerTrain < Train
  include Validations::PassengerTrainValidations
  def initialize(train_company, number)
    super(train_company, number)
    @type = :passenger
  end

  def total_seats
    carriages.map(&:seats).sum
  end
end
