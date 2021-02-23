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
    PassengerCarriage.new(train_company, comfort_class, number_seats)
  rescue InvalidTrainCompanyNameError => e
    puts e.message(train_company)
    retry
  end

  def create_cargo_carriage
    puts 'Please enter bearing capacity:'
    bearing_capacity = gets.to_i
    puts 'Please enter train company:'
    train_company = gets.to_s.chomp
    CargoCarriage.new(train_company, bearing_capacity)
  rescue InvalidTrainCompanyNameError => e
    puts e.message(train_company)
    retry
  end

  def passenger_seats_control
    stages = ['Please choose the train:', 'Please choose what you want to do:']
    options = { 'Take a seat on train' => :take_train_seat, 'Get off the train' => :leave_train }
    passenger_trains = trains.select { |train| train.type == :passenger }
    singleton_exception(InsufficientTrainsAmount, passenger_trains)
    options_list(stages, options, passenger_trains, report_train)
  end

  def train_seat(train)
    puts 'Choose cariage comfort class:'
    options = train.carriages.map(&:comfort_class).uniq
    singleton_exception(InsufficientCarriagesAmount, options)
    option = menu_list(options)
    puts 'Choose carriage number'
    menu_list(train.carriages.select { |passenger_train| passenger_train.comfort_class == option }, :number)
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

  def leave_train(train)
    carriage = train_seat(train)
    if empty_passenger_carriage?(carriage)
      puts 'Empty carriage.'
    else
      carriage.leave_seat
      puts "You have gotten off  #{carriage.comfort_class} carriage, on train #{train.number}"
    end
  end

  def cargo_volume_controll
    stages = ['Please choose the train:', 'Please choose what you want to do:']
    options = { 'Load cargo' => :load_cargo, 'Unload cargo' => :unload_cargo }
    cargo_trains = trains.select { |train| train.type == :cargo }
    singleton_exception(InsufficientTrainsAmount, cargo_trains)
    options_list(stages, options, cargo_trains, report_train)
  end

  def change_cargo_volume(train)
    carriages = train.carriages
    singleton_exception(InsufficientCarriagesAmount, carriages)
    puts 'Choose carriage'
    carriage = menu_list(carriages, :number)
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
    puts <<~HERE
      You have loaded #{cargo_loader.cargo} volume of cargo in carriage
      #{report_carriage.call cargo_loader.carriage},
      #{cargo_loader.carriage.free_capacity} volume left.
    HERE
  end

  def unload_cargo(train)
    cargo_loader = move_cargo(change_cargo_volume(train))
    cargo_loader.carriage.unload_cargo(cargo_loader.cargo)
  rescue InsufficientCapacityAmount => e
    puts e.message report_carriage.call cargo_loader.carriage
  else
    puts <<~HERE
      You have unloaded #{cargo_loader.cargo} volume of cargo in carriage
      #{report_carriage.call cargo_loader.carriage},
      #{cargo_loader.carriage.free_capacity} volume left."
    HERE
  end

  def available_carriages
    carriages.reject(&:current_train)
  end

  def report_carriage
    proc do |carriage|
      info = "type: #{carriage.type} " + "number:#{carriage.number}"
      case carriage.type
      when :passenger then <<~HERE
        #{info} comfort_class: #{carriage.comfort_class}, free seats: #{carriage.free_seats},
         occupied seats: #{carriage.occupied_seats}
      HERE
      when :cargo then <<~HERE
        #{info} bearing capacity: #{carriage.bearing_capacity},
        free volume: #{carriage.free_capacity},
        occupied volume: #{carriage.occupied_capacity}
      HERE
      end
    end
  end
end
