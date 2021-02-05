require_relative 'train'
class PassengerTrain < Train
  attr_reader :type

  def initialize(number)
    super(number)
    @type = :passenger
  end

  def total_seats
    carriages.map(&:seats).sum
  end
end
