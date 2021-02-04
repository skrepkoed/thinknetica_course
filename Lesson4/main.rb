require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'station'
require_relative 'route'
require_relative 'test'
class Railway
  attr_accessor :trains, :stations, :routes, :carriages

  TRAIN_TYPES = [PassengerTrain, CargoTrain]
  def initialize
    @trains = []
    @stations = []
    @routes = []
    @carriages = []
  end

  def quit; end

  def main_menu
    actions = [create_station, create_train, create_route, change_route, plug_carriage, move_train, report_stations,
               report_current_trains]
    puts 'Welcome to Railway programm. Please, choose what you want to do and enter the number:'
    options = ['Create station', 'Create train', 'Create route', 'Change, route',
               'Attach/Detach carriage', 'Move train', 'Report stations', 'Report current trains on station']
    menu_item = menu_list

    actions[menu_item]
  end

  def create_station
    puts 'Please enter name of the station:'
    station_name = gets.chomp
    stations << Station.new(station_name)
    puts "Station #{stations.last} created!"
  end

  def create_train
    puts 'Please choose train`s type'
    train_type = menu_list(TRAIN_TYPES)
    puts 'Please enter train`s number'
    train_number = gets.to_i
    trains << TRAIN_TYPES[train_type].new(train_number)
    puts "Train #{trains.last} created!"
  end

  def create_route
    if stations.empty?
      puts 'There are no stations. Please create at least two stations.'
      create_station
    else
      puts 'Please choose first station on the route:'
      first_stattion = menu_list(stations)
      puts 'Please choose last station on the route:'
      last_station = menu_list(stations.reject { |station| stations.index(station) == first_stattion })
      routes << Route.new(stations[first_stattion], stations[last_station])
    end
  end

  def change_route
    puts 'Please choose the route:'
    route = menu_list(routes)
    options = ['Remove station from the route', 'Add station to the route']
    actions = %i[remove_transitional_station add_transitional_station]
    puts 'Please choose what you want to do with the route:'
    menu_item = menu_list(options)
    puts 'Please, choose station:'
    transitional_station = menu_list(routes[route].transitional_stations)
    routes[route].send(actions[menu_item], routes[route].transitional_stations[transitional_station])
  end

  def menu_list(options)
    option_number = (1..options.size)
    option_number.each do |number|
      puts "#{number}.  #{options[number - 1]}"
    end
    puts 'Enter 0 to quit.'
    gets.to_i - 1
  end
end
