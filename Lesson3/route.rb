class Route
  attr_reader :first_station, :last_station, :transitional_stations

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @transitional_stations = []
  end

  def add_transitional_station(station)
    transitional_stations << station
  end

  def remove_transitional_station(station)
    if station.current_trains.select { |train| train.route == self }.empty?
      transitional_stations.delete(station)
    else
      puts 'You can`t remove station from the route if it`s current train`s station.'
    end
  end

  def report_stations
    [first_station, *transitional_stations, last_station].each { |station| puts station.to_s }
  end
end
