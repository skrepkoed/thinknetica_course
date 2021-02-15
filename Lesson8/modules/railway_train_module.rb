# frozen_string_literal: true

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
    train = train_type.new(train_company, train_number)
  rescue TrainException => e
    puts e.message
    retry
  else
    trains << train
    puts "Train #{report_train.call trains.last} created!"
  end

  def change_carriage_set
    stages = ['Please choose the train:', 'Please choose what you want to do with the carriage:']
    options = { 'Add carriage to train' => :attach_carriage, 'Remove carriage from train' => :detach_carriage }
    options_list(stages, options, trains, report_train)
  end

  def detach_carriage(train)
    puts 'Please choose train`s carriage to detach from train:'
    carriages = train.carriages
    singleton_exception(InsufficientCarriagesAmount, carriages)
    carriage = menu_list(carriages, report_carriage)
    train.detach_carriage carriage
  rescue FalliedCarriageDetachment => e
    puts e.message
  else
    puts "Carriage #{report_carriage.call carriage} dettached from train #{report_train.call train}"
  end

  def attach_carriage(train)
    puts 'Please choose carriage to attach to train:'
    current_available_carriages = available_carriages
    singleton_exception(InsufficientCarriagesAmount, current_available_carriages)
    carriage = menu_list(current_available_carriages, report_carriage)
    train.attach_carriage carriage
  rescue FalliedCarriageAttachment => e
    puts e.message report_carriage.call carriage
  else
    puts "Carriage #{report_carriage.call carriage} attached to train #{report_train.call train}"
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

  def report_all_trains
    puts 'Please choose the train to get it`s carriage set:'
    train = menu_list(trains, report_train)
    puts 'Carriages:'
    train.each_carriage { |carriage| puts report_carriage.call carriage }
  end

  def report_train
    proc { |train|
      "number: #{train.number}, type: #{train.type}, train_company:#{train.train_company}, carriages:#{train.total_carriages}"}
  end
end
