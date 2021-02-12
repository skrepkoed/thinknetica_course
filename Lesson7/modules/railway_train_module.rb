require 'pry'
module RailwayTrain
  include Validations::TrainValidations
  include ExceptionsModule::RailwayExceptions
  include Validations::TrainCompanyValidations

  private

  def create_train
    puts 'Please choose train`s type'
    train_type = menu_list([PassengerTrain, CargoTrain])
    puts 'Please enter train`s number'
    train_number = gets.chomp.to_s
    puts 'Please enter train`s company'
    train_company = gets.chomp.to_s
    train = train_type.new(train_number, train_company)
  rescue InvalidTrainCompanyNameError => e
    puts e.message(train_company)
    retry
  rescue InvalidTrainNumberError => e
    puts e.message(train_number)
    retry
  else
    trains << train
    puts "Train #{report_train.call trains.last} created!"
  end

  def change_carriage_set
    validate_carriages_amount
  rescue InsufficientCarriagesAmount => e
    e.message
    create_carriage
    retry
  rescue InsufficientTrainsAmount => e
    e.message
    create_train
    retry
  else
    stages = ['Please choose the train:', 'Please choose what you want to do with the carriage:']
    options = { 'Add carriage to train' => :attach_carriage, 'Remove carriage from train' => :detach_carriage }
    options_list(stages, options, trains, report_train)
  end

  def detach_carriage(train)
    if train_carriages_present?(train)
      puts 'Please choose train`s carriage:'
      carriage = menu_list(train.carriages, report_carriage)
      train.detach_carriage carriage
      begin
      rescue FalliedCarriageDetachment => e
        puts e.message
        main_menu
      else
        puts "Carriage #{report_carriage.call carriage} dettached from train #{report_train.call train}"
      end
    else
      begin
        raise InsufficientCarriagesAmount
      rescue InsufficientCarriagesAmount => e
        e.message
        main_menu
      end
    end
  end

  def attach_carriage(train)
    current_available_carriages = available_carriages
    if available_carriages?
      puts 'Please choose carriage:'
      carriage = menu_list(current_available_carriages, report_carriage)
      train.attach_carriage carriage
      begin
      rescue FalliedCarriageAttachment => e
        puts e.message train
        create_carriage
        retry
      else
        puts "Carriage #{report_carriage.call carriage} attached to train #{report_train.call train}"
      end
    else
      raise InsufficientCarriagesAmount
      begin
      rescue InsufficientCarriagesAmount => e
        e.message
        create_carriage
        retry
      end
    end
  end

  def move_train
    stages = ['Please choose the train:', 'Please choose what you want to do with the route:']
    options = { 'Move on the next station on the route' => :move_train_forward,
                'Move on the previous station on the route' => :move_train_back }
    options_list(stages, options, trains, report_train)
  end

  def move_train_forward(train)
    train.move_forward
  rescue ImpossibleMovement => e
    puts e.message
    puts 'This is the last station on the route.'
  else
    report_location(train)
  end

  def move_train_back(train)
    train.move_back
  rescue ImpossibleMovement => e
    puts e.message
    puts 'This is the first station on the route.'
  else
    report_location(train)
  end

  def passenger_seats_control
    stages = ['Please choose the train:', 'Please choose what you want to do:']
    options = { 'Take a seat on train' => :take_train_seat, 'Get off the train' => :get_off_train }
    options_list(stages, options, trains.select { |train| train.type == :passenger }, report_train)
  end

  def train_seat(train)
    stages = ['Choose cariage comfort type:']
    options = train.carriages.map(&:comfort_class).uniq
    option = menu_list(options)
    puts 'Choose carriage number'
    menu_list(train.carriages.select { |train| train.comfort_class == option }, :number)
  end

  def take_train_seat(train)
    carriage = train_seat(train)
    if enough_seats?(carriage)
      carriage.take_seat
      puts "You have taken a seat on #{carriage.comfort_class} carriage, on train #{train.number}"
    else
      puts InsufficientSeatsAmount.message carriage
    end
  end

  def get_off_train(train)
    carriage = train_seat(train)
    if empty_passenger_carriage?(carriage)
      puts 'Empty carriage.'
    else
      carriage.get_off
      puts "You have gotten off  #{carriage.comfort_class} carriage, on train #{train.number}"
    end
  end

  def cargo_volume_controll
    stages = ['Please choose the train:', 'Please choose what you want to do:']
    options = { 'Load cargo' => :load_cargo, 'Unload cargo' => :unload_cargo }
    options_list(stages, options, trains.select { |train| train.type == :cargo }, report_train)
  end

  def change_cargo_volume(train)
    puts 'Choose carriage'
    carriage = menu_list(train.carriages, :number)
    puts 'How much you want to (un)load?'
    cargo = gets.to_f
    [cargo, carriage]
  end

  def load_cargo(train)
    options = change_cargo_volume(train)
    if enough_capacity?(*options)
      options.last.load_cargo(options.first)
      puts "You have loaded #{options.first} volume of cargo in carriage #{options.last}, #{options.last.free_capacity} volume left."
    else
      puts InsufficientCapacityAmount.message(options.last)
    end
  end

  def unload_cargo(train)
    options = change_cargo_volume(train)
    if empty_cargo_carriage?(options.last)
      puts 'Empty carriage.'
    else
      options.last.unload(options.first)
      puts "You have unloaded #{options.first} volume of cargo in carriage #{options.last}, #{options.last.free_capacity} volume left."
    end
  end

  def report_all_trains
    puts 'Please choose the train to get it`s carriage set:'
    train = menu_list(trains, report_train)
    puts 'Carriages:'
    train.carriages_iteration { |carriage| puts report_carriage.call carriage }
  end

  def report_train
    proc { |train|
      "number: #{train.number}, type: #{train.type}, train_company:#{train.train_company}, carriages:#{train.total_carriages}"
    }
  end
end
