require_relative 'validation_module'
require 'pry'
module RailwayRoute
  include Validations::RouteValidations
  include ExceptionsModule::RailwayExceptions
  # binding.pry

  private

  def create_route
    validate_stations_amount(stations)
  rescue InsufficientStationsAmount => e
    puts e.message
    create_station
    retry
  else
    puts 'Please choose first station on the route:'
    first_stattion = menu_list(stations, :name)
    puts 'Please choose last station on the route:'
    last_station = menu_list(stations.reject { |station| station == first_stattion }, :name)
    route = Route.new(first_stattion, last_station)
    routes << route
    puts "Route #{route} was created."
  end

  def change_route
    stages = ['Please choose the route:', 'Please choose what you want to do with the route:']
    options = { 'Remove station from the route' => :remove_station, 'Add station to the route' => :add_station }
    if routes.empty?
      puts 'Please create route.'
      create_route
    else
      options_list(stages, options, routes)
    end
  end

  def remove_station(route)
    if valid_transitional_stations_amount?(route.transitional_stations)
      puts 'Please, choose station:'
      station = menu_list(route.transitional_stations, :name)
      route.remove_transitional_station(station)
      begin
      rescue FalliedChangeRoute => e
        puts e.message
        main_menu
      else
        puts "Station #{station.name} was removed from route."
      end
    else
      main_menu
    end
  end

  def add_station(route)
    validate_available_stations(route)
  rescue InsufficientStationsAmount => e
    puts e.message
    create_station
    retry
  else
    puts 'Please, choose station:'
    station = menu_list(available_stations(route), :name)
    route.add_transitional_station station
    puts "Station #{station.name} was added to route."
  end

  def available_stations(route)
    stations.reject { |station| station == route.first_station || station == route.last_station }
  end
end
