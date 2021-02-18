# frozen_string_literal: true

module RailwayStation
  include Validations::StationValidations
  include ExceptionsModule::RailwayExceptions

  private

  def create_station
    puts 'Please enter name of the station:'
    station_name = gets.chomp
    station = Station.new(station_name)
  rescue StationException => e
    puts e.message(station_name)
    retry
  else
    stations << station
    puts "Station #{stations.last.name} created!"
  end

  def report_stations
    puts 'Stations list:'
    stations.each { |station| puts "#{station.name}. There are #{station.current_trains.size} train(s)" }
  end

  def report_current_trains
    puts 'Please, choose station:'
    station = menu_list(stations, :name)
    if station.current_trains.empty?
      puts "There are no trains on #{station.name}"
    else
      station.each_train { |train| puts report_train.call train }
    end
  end
end
