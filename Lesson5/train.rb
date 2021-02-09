require_relative 'train_company'
require_relative 'instance_counter'
class Train
  attr_accessor :number
  attr_reader :type, :speed, :current_station, :route, :carriages

  prepend TrainCompany
  include InstanceCounter
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
    if allow_attach_carriage?(carriage)
      carriage.current_train = self
      carriages << carriage
    end
  end

  def detach_carriage(carriage)
    carriages.delete(carriage) unless moving?
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

  # Данный метод мог бы и не быть защищенным, но так как используется для проверки возможности отцепления/прицепления
  # вагона, то метод помещен в протектед
  def move(destination_station)
    current_station.departure_train(self)
    destination_station.recieve_train(self)
    self.current_station = destination_station
  end

  def station_number
    route.transitional_stations.index(current_station)
  end

  # move и station_number используютяся движения поезда, инкапсулируя реализацию движения
  def allow_attach_carriage?(carriage)
    same_carriage_type?(carriage) && !carriage.current_train && !moving?
  end

  def same_carriage_type?(carriage)
    type == carriage.type
  end
  # Последние два метода используются в проверке правильности типа при присоединении вагона к поезду, и не имеют
  # смысла вне этого метода
end
