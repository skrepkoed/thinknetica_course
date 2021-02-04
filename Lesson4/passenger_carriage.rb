class PassengerCarriage < Carriage
  attr_reader :seats

  COMFORT_CLASSES = %i[economy standart lux]
  def initialize(comfort_class = standrart_class, seats = standrart_seats)
    @comfort_class = comfort_class
    @type = :passenger
    @seats = seats
  end

  def standrart_seats
    50
  end

  def standart_class
    COMFORT_CLASSES[1]
  end
end
