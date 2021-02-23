# frozen_string_literal: true

require_relative '../modules/instance_counter'
require_relative '../modules/validation_module'
class Route
  attr_reader :first_station, :last_station, :transitional_stations

  include InstanceCounter
  include Validations::RouteValidations
  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @transitional_stations = []
    register_instance
  end

  def add_transitional_station(station)
    transitional_stations << station
  end

  def remove_transitional_station(station)
    validate_change_route(station)
    transitional_stations.delete(station)
  end

  def report_stations
    [first_station, *transitional_stations, last_station]
  end
end
