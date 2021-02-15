# frozen_string_literal: true

require_relative 'source_loader'
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
  include InsufficientException
  CargoLoader = Struct.new(:cargo, :carriage)
  INFO = { 'Create station' => :create_station, 'Create train' => :create_train,
           'Create route' => :create_route, 'Create carriage' => :create_carriage,
           'Change route' => :change_route, 'Change carriages set' => :change_carriage_set,
           'Report stations' => :report_stations,
           'Report current trains on station' => :report_current_trains,
           'Add route to train' => :add_route_to_train,
           'Move train' => :move_train, 'Passenger seats control' => :passenger_seats_control,
           'Cargo volume control' => :cargo_volume_controll, 'Report trains' => :report_all_trains,
           'Exit' => :back_from_action }.freeze
  def initialize
    @trains = []
    singleton_exception(InsufficientTrainsAmount, @trains)
    @stations = []
    singleton_exception(InsufficientStationsAmount, stations)
    @routes = []
    singleton_exception(InsufficientRoutesAmount, @routes)
    @carriages = []
    singleton_exception(InsufficientCarriagesAmount, carriages)
    start_session
  end

  private

  attr_reader :trains, :stations, :routes, :carriages

  def main_menu
    stage = ['Welcome to Railway programm. Please, choose what you want to do and enter the number:']
    options_list(stage, INFO)
  rescue InsufficientEntity => e
    clear_screen
    puts e.message
    main_menu
  end

  def add_route_to_train
    puts 'Please, choose the train:'
    available_trains = trains.reject(&:route)
    singleton_exception(InsufficientTrainsAmount, available_trains)
    train = menu_list(available_trains, report_train)
    puts 'Please, choose the route:'
    route = menu_list(routes)
    train.route = route
    puts "Route #{route} was added to train #{report_train.call train}"
  end

  def report_location(train)
    puts "Train: #{report_train.call train}"
    puts "Route from #{train.route.first_station.name} to #{train.route.last_station.name}"
    puts train.previous_station ? "Previous station: #{train.previous_station.name}." : 'Current station is the first station on the route.'
    puts "Current station: #{train.current_station.name}."
    puts train.next_station ? "Next station: #{train.next_station.name}." : 'Current station is the last station on the route.'
  end

  def menu_list(options, block = proc { |i| i })
    options.empty_entity? if options.respond_to? :empty_entity?
    options_list = options.map(&block)
    option_number = (1..options_list.size)
    option_number.each { |number| puts "#{number}.  #{options_list[number - 1]}" }
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
    if entities.respond_to? :empty_entity?
      entities.empty_entity?
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
    eval('return', current_closure) if option.zero?
  end

  def clear_screen
    puts "\e[H\e[2J"
  end
end
