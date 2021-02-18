# frozen_string_literal: true

require_relative 'validation_module'
require 'pry'
module RailwayRoute
  include Validations::RouteValidations
  include ExceptionsModule::RailwayExceptions

  private

  def create_route
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
    options = { 'Remove station from the route' => :remove_station,
                'Add station to the route' => :add_station }
    options_list(stages, options, routes)
  end

  def remove_station(route)
    puts 'Please, choose station:'
    transitional_stations = route.transitional_stations
    singleton_exception(InsufficientStationsAmount, transitional_stations)
    station = menu_list(transitional_stations, :name)
    route.remove_transitional_station(station)
  rescue FalliedChangeRoute => e
    puts e.message
  else
    puts "Station #{station.name} was removed from route."
  end

  def add_station(route)
    puts 'Please, choose station:'
    available_stations = available_stations(route)
    singleton_exception(InsufficientStationsAmount, available_stations)
    station = menu_list(available_stations, :name)
    route.add_transitional_station station
    puts "Station #{station.name} was added to route."
  end

  def available_stations(route)
    stations.reject do |station|
      station == route.first_station || station == route.last_station || route.transitional_stations.include?(station)
    end
  end
end
