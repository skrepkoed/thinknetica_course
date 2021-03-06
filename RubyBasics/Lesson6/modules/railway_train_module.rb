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

  def report_train
    proc { |train| "number: #{train.number}, type: #{train.type}, train_company:#{train.train_company}" }
  end
end
