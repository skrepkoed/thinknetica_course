require_relative 'train_company'
require_relative 'instance_counter'
require_relative 'validation_module'
class Train
  attr_accessor :number
  attr_reader :type, :speed, :current_station, :route, :carriages

  prepend TrainCompany
  include InstanceCounter
  include Validations::TrainValidations
  @@all_trains = []

  class<<self
    def all
      @@all_trains
    end

    def find(number)
      all.select { |train| train.number == number }.first
    end
  end

  def initialize(number, _train_company)
    @number = number
    train_number_validation
    @carriages = []
    @speed = 0
    self.class.all << self
    register_instance
  end

  def speed_up(speed)
    self.speed += speed
  end

  def stop
    @speed = 0
  end

  def attach_carriage(carriage)
    validate_carriage_attachment(carriage)
    carriage.current_train = self
    carriages << carriage
  end

  def detach_carriage(carriage)
    validate_carriage_detachment
    carriages.delete(carriage)
  end

  def route=(route)
    @route = route
    self.current_station = route.first_station
    move(current_station)
  end

  def move_forward
    move(next_station)
  end

  def move_back
    move(previous_station)
  end

  def previous_station
    if station_number.nil? && next_station.nil? && route.transitional_stations.empty?
      route.first_station
    elsif station_number.nil? && next_station.nil?
      route.transitional_stations.last
    elsif station_number.nil? && current_station == route.first_station
      nil
    elsif station_number.zero?
      route.first_station
    else
      route.transitional_stations[station_number - 1]
    end
  end

  def next_station
    if station_number.nil? && current_station == route.first_station && route.transitional_stations.empty?
      route.last_station
    elsif station_number.nil? && current_station == route.first_station
      route.transitional_stations.first
    elsif current_station == route.transitional_stations.last
      route.last_station
    elsif station_number.nil? && current_station == route.last_station
      nil
    else
      route.transitional_stations[station_number + 1]
    end
  end

  protected

  # Следующие методы должны быть protected, так как предназначены для внутреннего использования внутри классов,
  # наследующих классу Train
  attr_writer :current_station, :speed

  # Нельзя произвольно устанавливать текущую станцию и скорость, для изменения текущей станции предусмотренны
  # методы движения, для изменения скорости - методы ускорения и остановки

  # В ТЗ нет метода для отображения вагонов пренадлежащих поезду, однако данный метод используется для изменения количества
  # вагонов в поезде

  def moving?
    speed.positive?
  end

  def move(destination_station)
    validate_destination_station(destination_station)
    current_station.departure_train(self)
    destination_station.recieve_train(self)
    self.current_station = destination_station
  end

  def station_number
    route.transitional_stations.index(current_station)
  end
end
