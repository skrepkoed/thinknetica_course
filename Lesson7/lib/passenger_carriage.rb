require_relative 'carriage'

class PassengerCarriage < Carriage
  attr_reader :seats, :comfort_class, :free_seats, :occupied_seats

  prepend TrainCompany
  COMFORT_TYPES = %i[economy standart lux]
  STANDART_SEATS = 50

  def initialize(comfort_class = standrart_type, seats = standrart_seats, _train_company)
    super
    @comfort_class = comfort_class
    @type = :passenger
    @seats = seats
    @free_seats = seats
    @occupied_seats = 0
  end

  def take_seat
    self.free_seats -= 1
    self.occupied_seats += 1
  end

  def get_off
    self.free_seats += 1
    self.occupied_seats -= 1
  end

  protected

  attr_writer :free_seats, :occupied_seats

  def standrart_seats
    STANDART_SEATS
  end

  def standart_type
    COMFORT_TYPES[1]
  end
end
