require_relative 'lib/cargo_train'
require_relative 'lib/passenger_train'
require_relative 'lib/cargo_carriage'
require_relative 'lib/passenger_carriage'
require_relative 'lib/station'
require_relative 'lib/route'
require_relative 'modules/validation_module'
require_relative 'modules/railway_carriage_module'
require_relative 'modules/railway_train_module'
require_relative 'modules/railway_route_module'
require_relative 'modules/railway_station_module'
class Railway
  def self.session
    new
    puts 'Goodbye!'
  end
  include Validations::RailwayValidations
  include ExceptionsModule::RailwayExceptions
  include RailwayTrain
  include RailwayRoute
  include RailwayStation
  include RailwayCarriage

  CargoLoader = Struct.new(:cargo, :carriage)
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
             'Add route to train' => :add_route_to_train, 'Move train' => :move_train, 'Passenger seats control' => :passenger_seats_control,
             'Cargo volume control' => :cargo_volume_controll, 'Report trains' => :report_all_trains, 'Exit' => :back_from_action }

    stage = ['Welcome to Railway programm. Please, choose what you want to do and enter the number:']
    options_list(stage, info)
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
