require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'cargo_carriage'
require_relative 'passenger_carriage'
require_relative 'station'
require_relative 'route'

class Railway
  attr_accessor :trains, :stations, :routes, :carriages

  TRAIN_TYPES = [PassengerTrain, CargoTrain]
  def initialize
    @trains = []
    @stations = []
    @routes = []
    @carriages = []

    refresh = lambda do |action|
      clear_screen
      action
      back_from_action(binding)
    end
    session
  end

  def session
    loop do
      clear_screen
      main_menu
      back_from_action(binding, 'from Railway programm session.')
    end
  end

  def main_menu
    info = { 'Create station' => :create_station, 'Create train' => :create_train,
             'Create route' => :create_route, 'Create carriage' => :create_carriage,
             'Change route' => :change_route, 'Change carriages set' => :change_carriage_set,
             'Report stations' => :report_stations, 'Report current trains on station' => :report_current_trains,
             'Add route to train' => :add_route_to_train, 'Move train' => :move_train, 'Exit' => :back_from_action }

    stage = ['Welcome to Railway programm. Please, choose what you want to do and enter the number:']
    options_list(stage, info)
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
    trains << train_type.new(train_number)
    puts "Train #{trains.last} created!"
  end

  def create_route
    if stations.empty? || stations.size < 2
      puts 'There are no stations. Please create at least two stations.'
      create_station
      create_route
    else
      puts 'Please choose first station on the route:'
      first_stattion = menu_list(stations)
      puts 'Please choose last station on the route:'
      last_station = menu_list(stations.reject { |station| station == first_stattion })
      route = Route.new(first_stattion, last_station)
      routes << route
      puts route
    end
  end

  def create_carriage
    stages = ['Please choose carriage`s type']
    options = { 'Create Cargo carriage' => :create_cargo_carriage,
                'Create Passenger carriage' => :create_passenger_carriage }
    carriages << options_list(stages, options)
    puts "Carriage #{carriages.last} created!"
  end

  def change_route
    stages = ['Please choose the route:', 'Please choose what you want to do with the route:']
    options = { 'Remove station from the route' => :remove_station, 'Add station to the route' => :add_station }
    options_list(stages, options, routes)
  end

  def change_carriage_set
    if carriages.empty?
      puts 'There are no carriages. Please create at least one carriage.'
      create_carriage
      change_carriage_set
    elsif trains.empty?
      puts 'There are no trains. Please create at least one train.'
      create_train
      change_carriage_set
    else
      stages = ['Please choose the train:', 'Please choose what you want to do with the route:']
      options = { 'Add carriage to train' => :attach_carriage, 'Remove carriage from train' => :detach_carriage }
      options_list(stages, options, trains)
    end
  end

  def add_route_to_train
    if trains.empty?
      puts 'There are no trains. Please create at least one train.'
      create_train
      add_route_to_train
    elsif routes.empty?
      puts 'There are no routes. Please create at least one train.'
      create_route
      add_route_to_train
    else
      puts 'Please, choose the train:'
      train = menu_list(trains)
      puts 'Please, choose the route:'
      route = menu_list(routes)
      train.route = route
    end
  end

  def move_train
    stages = ['Please choose the train:', 'Please choose what you want to do with the route:']
    options = { 'Move on the next station on the route' => :move_train_forward,
                'Move on the previous station on the route' => :move_train_back }
    options_list(stages, options, trains)
  end

  def report_stations
    puts 'Stations list:'
    stations.each { |station| puts station }
  end

  def report_current_trains
    puts 'Please, choose station:'
    station = menu_list(stations)
    station.report_current_trains
  end

  private

  # Следующие методы не планируется (и невозможно) использовать откуда то извне класса Railway, поэтому они помещены в private
  # Методы move_train_forward,move_train_back,detach_carriage,attach_carriage,remove_station,add_station,create_passenger_carriage
  # и create_cargo_carriage позволяют выбирать из различных опций при создании как либо модели(поезд, вагон и.т.д.)
  # используют методы menu_list и option_list для отображения списков опция и навигации по ним.
  # Методы back_from_action и clear_screаn реализуют выход и очистку экрана. К сожалению пока выход всегда на главное меню.
  def move_train_forward(train)
    train.move_forward
  end

  def move_train_back(train)
    train.move_back
  end

  def detach_carriage(train)
    puts 'Please choose train`s carriage:'
    carriage = menu_list(train.carriages)
    train.detach_carriage carriage
  end

  def attach_carriage(train)
    puts 'Please choose carriage:'
    carriage = menu_list(carriages)
    train.attach_carriage carriage
  end

  def remove_station(route)
    puts 'Please, choose station:'
    station = menu_list(route.transitional_stations)
    route.remove_transitional_station(station)
  end

  def add_station(route)
    puts 'Please, choose station:'
    station = menu_list(stations)
    route.add_transitional_station station
  end

  def create_passenger_carriage
    puts 'Please, choose comfort type'
    comfort_class = menu_list(PassengerCarriage::COMFORT_TYPES)
    puts 'Please enter number of seats:'
    number = gets.to_i
    PassengerCarriage.new(comfort_class, number)
  end

  def create_cargo_carriage
    puts 'Please enter bearing capacity:'
    bearing_capacity = gets.to_i
    CargoCarriage.new(bearing_capacity)
  end

  def menu_list(options)
    option_number = (1..options.size)
    option_number.each do |number|
      puts "#{number}.  #{options[number - 1]}"
    end
    options[gets.to_i - 1]
  end

  def options_list(stages, options, entities = [])
    arguments = []
    perform = proc { |option, entity| entity ? send(option, entity) : send(option) }
    stages = stages.cycle
    unless entities.empty?
      puts stages.next
      arguments << menu_list(entities)
    end
    puts stages.next
    arguments << options[menu_list(options.keys)]

    perform.call(*arguments.reverse)
  end

  def back_from_action(current_closure = binding, notice = 'main menu.')
    puts "Enter 0 to quit from #{notice}. Enter something else to continue."
    option = gets.to_i
    eval('return', current_closure) if option == 0
  end

  def clear_screen
    puts "\e[H\e[2J"
  end
end
