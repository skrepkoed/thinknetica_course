require_relative 'train'
class PassengerTrain < Train
  def initialize(number, train_company)
    super(number, train_company)
    @type = :passenger
  end

  def total_seats
    carriages.map(&:seats).sum
  end
end
