# frozen_string_literal: true

require_relative '../modules/train_company'
require_relative '../modules/instance_counter'
require_relative '../modules/validation_module'
require_relative '../modules/accessors'
require_relative '../modules/validation'
class Train
  include Validation
  extend Accessors

  attr_accessor_with_history :number, :smth
  attr_reader :type, :speed, :current_station, :route, :carriages

  validate :number, :presence
  validate :number, :attribute_type, String
  validate :number, :format, /^[[0-9]|[a-z]]{3}-?[[0-9]|[a-z]]{2}$/
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

  def initialize(_train_company, number = nil)
    @number = number
    validate!
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

  def total_carriages
    carriages.size
  end

  def route=(route)
    @route = route
    self.current_station = route.first_station
    move(current_station)
  end

  def each_carriage(&block)
    carriages.each(&block) if block_given?
  end

  def move_forward
    move(next_station)
  end

  def move_back
    move(previous_station)
  end

  def stations_on_route
    [nil, route.first_station, *route.transitional_stations, route.last_station, nil]
  end

  def previous_station
    stations_on_route.each_cons(3).select { |stations| stations[1] == current_station }.flatten.first
  end

  def next_station
    stations_on_route.each_cons(3).select { |stations| stations[1] == current_station }.flatten.last
  end

  protected

  attr_writer :current_station, :speed

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
