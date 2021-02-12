require_relative '../modules/instance_counter'
require_relative '../modules/validation_module'
require 'pry'
class Station
  attr_accessor :name
  attr_reader :current_trains

  include InstanceCounter
  include Validations::StationValidations
  @@all_stations = []

  def self.all
    @@all_stations
  end

  def initialize(name)
    @name = name
    station_name_validation
    validate_station_uniqness(self)
    @current_trains = []
    @@all_stations << self
    register_instance
  end

  def recieve_train(train)
    current_trains << train
  end

  def departure_train(train)
    current_trains.delete(train)
  end

  def report_trains_by_type(type)
    current_trains.select { |train| train.type == type }
  end

  def trains_iteration(&block)
    enumerator=current_trains.to_enum
    loop do 
      yield enumerator.next 
    rescue StopIteration
      break
    end
    current_trains
  end

  def ==(other)
    name == other&.name
  end
end
