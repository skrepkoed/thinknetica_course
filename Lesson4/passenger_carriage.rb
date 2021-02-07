require_relative 'carriage'
class PassengerCarriage < Carriage
  attr_reader :seats, :comfort_class

  COMFORT_TYPES = %i[economy standart lux]
  def initialize(comfort_class = standrart_type, seats = standrart_seats)
    @comfort_class = comfort_class
    @type = :passenger
    @seats = seats
  end

  def to_s
    "type: #{type}, comfortclass: #{comfort_class}, with: #{seats} seats."
  end
protected
  def standrart_seats
    50
  end

  def standart_type
    COMFORT_TYPES[1]
  end
end
