require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'cargo_carriage'
require_relative 'passenger_carriage'
require_relative 'station'
require_relative 'route'
class Railway
  def self.session
    new
    puts 'Goodbye!'
  end

  def initialize
    @trains = []
    @stations = []
    @routes = []
    @carriages = []
    start_session
  end

  private

  attr_reader :trains, :stations, :routes, :carriages

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
    puts "Station #{stations.last.name} created!"
  end

  def create_train
    puts 'Please choose train`s type'
    train_type = menu_list([PassengerTrain, CargoTrain])
    puts 'Please enter train`s number'
    train_number = gets.to_i
    trains << train_type.new(train_number)
    puts "Train #{report_train.call trains.last} created!"
  end

  def create_route
    if stations.empty? || stations.size < 2
      puts 'There are no stations. Please create at least two stations.'
      create_station
      create_route
    else
      puts 'Please choose first station on the route:'
      first_stattion = menu_list(stations, :name)
      puts 'Please choose last station on the route:'
      last_station = menu_list(stations.reject { |station| station == first_stattion }, :name)
      route = Route.new(first_stattion, last_station)
      routes << route
      puts "Route #{route} was created."
    end
  end

  def create_carriage
    stages = ['Please choose carriage`s type']
    options = { 'Create Cargo carriage' => :create_cargo_carriage,
                'Create Passenger carriage' => :create_passenger_carriage }
    carriages << options_list(stages, options)
    puts "Carriage #{report_carriage.call carriages.last} created!"
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
      stages = ['Please choose the train:', 'Please choose what you want to do with the carriage:']
      options = { 'Add carriage to train' => :attach_carriage, 'Remove carriage from train' => :detach_carriage }
      options_list(stages, options, trains, report_train)
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
      train = menu_list(trains, report_train)
      if train.route
        puts 'Train already has route.'
      else
        puts 'Please, choose the route:'
        route = menu_list(routes)
        train.route = route
        puts "Route #{route} was added to train #{report_train.call train}"
      end
    end
  end

  def move_train
    stages = ['Please choose the train:', 'Please choose what you want to do with the route:']
    options = { 'Move on the next station on the route' => :move_train_forward,
                'Move on the previous station on the route' => :move_train_back }
    options_list(stages, options, trains, report_train)
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
      station.current_trains.each { |train| puts report_train.call train.to_s }
    end
  end

  # Следующие методы не планируется (и невозможно) использовать откуда то извне класса Railway, поэтому они помещены в private
  # Методы move_train_forward,move_train_back,detach_carriage,attach_carriage,remove_station,add_station,create_passenger_carriage
  # и create_cargo_carriage позволяют выбирать из различных опций при создании как либо модели(поезд, вагон и.т.д.)
  # используют методы menu_list и option_list для отображения списков опция и навигации по ним.
  # Методы back_from_action и clear_screаn реализуют выход и очистку экрана. К сожалению пока выход всегда на главное меню.
  def move_train_forward(train)
    if train.next_station
      train.move_forward
      report_location(train)
    else
      puts 'This is the last station on the route.'
    end
  end

  def move_train_back(train)
    if train.previous_station
      train.move_back
      report_location(train)
    else
      puts 'This is the first station on the route.'
    end
  end

  def detach_carriage(train)
    if train.carriages.empty?
      puts 'Nothing to detach.'
    else
      puts 'Please choose train`s carriage:'
      carriage = menu_list(train.carriages, report_carriage)
      train.detach_carriage carriage
      puts "Carriage #{report_carriage.call carriage} dettached from train #{report_train.call train}"
    end
  end

  def attach_carriage(train)
    current_available_carriages = available_carriages
    if current_available_carriages.size == 0
      puts 'There is`nt available carriage. Please create carriage.'
      create_carriage
      attach_carriage(train)
    else
      puts 'Please choose carriage:'
      carriage = menu_list(current_available_carriages, report_carriage)
      train.attach_carriage carriage
      if train.carriages.last == carriage
        puts "Carriage #{report_carriage.call carriage} attached to train #{report_train.call train}"
      else
        puts 'Something wrong.'
      end
    end
  end

  def remove_station(route)
    if route.transitional_stations.empty?
      puts 'Nothing to remove'
    else
      puts 'Please, choose station:'
      station = menu_list(route.transitional_stations, :name)
      if route.remove_transitional_station(station)
        puts "Station #{station.name} was removed from route."
      else
        puts 'You can`t remove station from the route if it`s current train`s station.'
      end
    end
  end

  def add_station(route)
    if available_stations(route).size < 1
      puts 'There is not enough stations,to change the route. Please create station.'
      create_station
      add_station route
    else
      puts 'Please, choose station:'
      station = menu_list(available_stations(route), :name)
      route.add_transitional_station station
      puts "Station #{station.name} was added to route."
    end
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

  def available_stations(route)
    stations.reject { |station| station == route.first_station || station == route.last_station }
  end

  def available_carriages
    carriages.reject { |carriage| carriage.current_train }
  end

  def report_train
    proc { |train| "number: #{train.number}, type: #{train.type}" }
  end

  def report_carriage
    proc { |carriage| "type: #{carriage.type}" }
  end

  def report_location(train)
    puts "Train: #{report_train.call train}"
    puts "Route from #{train.route.first_station.name} to #{train.route.last_station.name}"
    puts train.previous_station ? "Previous station: #{train.previous_station.name}." : 'Current station is the first station on the route.'
    puts "Current station: #{train.current_station.name}."
    puts train.next_station ? "Next station: #{train.next_station.name}." : 'Current station is the last station on the route.'
  end

  def menu_list(options, block = proc { |i| i })
    option_number = (1..options.size)
    options_list = options.map(&block)
    option_number.each do |number|
      puts "#{number}.  #{options_list[number - 1]}"
    end
    if option_number.include? choice = gets.to_i
      options[choice - 1]
    else
      puts 'Try again.'
      menu_list(options, block)
    end
  end

  def options_list(stages, options, entities = [], block = proc { |i| i })
    arguments = []
    perform = proc { |option, entity| entity ? send(option, entity) : send(option) }
    stages = stages.cycle
    unless entities.empty?
      puts stages.next
      arguments << menu_list(entities, block)
    end
    puts stages.next
    arguments << options[menu_list(options.keys)]

    perform.call(*arguments.reverse)
  end

  def start_session
    loop do
      clear_screen
      main_menu
      back_from_action(binding, 'from Railway programm session.')
    end
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
