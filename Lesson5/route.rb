require_relative 'instance_counter'
class Route
  attr_reader :first_station, :last_station, :transitional_stations

  include InstanceCounter
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
    transitional_stations.delete(station) if station.current_trains.select { |train| train.route == self }.empty?
  end

  def report_stations
    [first_station, *transitional_stations, last_station]
  end
end
