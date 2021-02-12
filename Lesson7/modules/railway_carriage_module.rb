module RailwayCarriage
  include Validations::TrainCompanyValidations

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
