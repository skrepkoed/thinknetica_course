module RailwayCarriage
  include Validations::TrainCompanyValidations
  include Validations::CargoCarriageValidations
  include ExceptionsModule::CargoCarriageExceptions
  include ExceptionsModule::RailwayExceptions
  def create_carriage
    stages = ['Please choose carriage`s type']
    options = { 'Create Cargo carriage' => :create_cargo_carriage,
                'Create Passenger carriage' => :create_passenger_carriage }
    carriages << options_list(stages, options)
    puts "Carriage #{report_carriage.call carriages.last} created!"
  end

  def create_passenger_carriage
    puts 'Please, choose comfort type'
    comfort_class = menu_list(PassengerCarriage::COMFORT_TYPES)
    puts 'Please enter number of seats:'
    number_seats = gets.to_i
    puts 'Please enter train company:'
    train_company = gets.to_s.chomp
    PassengerCarriage.new(comfort_class, number_seats, train_company)
  rescue InvalidTrainCompanyNameError => e
    puts e.message(train_company)
    retry
  end

  def create_cargo_carriage
    puts 'Please enter bearing capacity:'
    bearing_capacity = gets.to_i
    puts 'Please enter train company:'
    train_company = gets.to_s.chomp
    CargoCarriage.new(bearing_capacity, train_company)
  rescue InvalidTrainCompanyNameError => e
    puts e.message(train_company)
    retry
  end

  def passenger_seats_control
    stages = ['Please choose the train:', 'Please choose what you want to do:']
    options = { 'Take a seat on train' => :take_train_seat, 'Get off the train' => :get_off_train }
    options_list(stages, options, trains.select { |train| train.type == :passenger }, report_train)
  end

  def train_seat(train)
    train.validate_carriage_presence
  rescue InsufficientCarriagesAmount => e
    puts e.message
    carriages << create_passenger_carriage
    attach_carriage train
    train_seat train
  else
    puts 'Choose cariage comfort class:'
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
    train.validate_carriage_presence
  rescue InsufficientCarriagesAmount => e
    puts e.message
    carriages << create_cargo_carriage
    attach_carriage train
    change_cargo_volume train
  else
    puts 'Choose carriage'
    carriage = menu_list(train.carriages, :number)
    puts 'How much you want to (un)load?'
    cargo = gets.to_f
    [cargo, carriage]
  end

  def move_cargo(data)
    Railway::CargoLoader.new(data[0], data[1])
  end

  def load_cargo(train)
    cargo_loader = move_cargo(change_cargo_volume(train))
    cargo_loader.carriage.load_cargo(cargo_loader.cargo)
  rescue InsufficientCapacityAmount => e
    puts e.message report_carriage.call cargo_loader.carriage
  else
    puts "You have loaded #{cargo_loader.cargo} volume of cargo in carriage #{report_carriage.call cargo_loader.carriage}, #{cargo_loader.carriage.free_capacity} volume left."
  end

  def unload_cargo(train)
    cargo_loader = move_cargo(change_cargo_volume(train))
    if cargo_loader.carriage.empty_cargo_carriage?
      puts 'Empty carriage.'
    else
      begin
        cargo_loader.carriage.unload_cargo(cargo_loader.cargo)
      rescue InsufficientCapacityAmount => e
        puts e.message report_carriage.call cargo_loader.carriage
      else
        puts "You have unloaded #{cargo_loader.cargo} volume of cargo in carriage #{report_carriage.call cargo_loader.carriage}, #{cargo_loader.carriage.free_capacity} volume left."
      end
    end
  end

  def available_carriages
    carriages.reject { |carriage| carriage.current_train }
  end

  def report_carriage
    proc do |carriage|
      info = "type: #{carriage.type} " + "number:#{carriage.number}"
      case carriage.type
      when :passenger then "#{info} comfort_class: #{carriage.comfort_class}, free seats: #{carriage.free_seats}, occupied seats: #{carriage.occupied_seats}"
      when :cargo then "#{info} bearing capacity: #{carriage.bearing_capacity}, free volume: #{carriage.free_capacity}, occupied volume: #{carriage.occupied_capacity}"
      end
    end
  end
end
