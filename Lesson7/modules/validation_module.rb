require_relative 'exceptions_module'
module Validations
  FORBIDDEN_SYMBOLS = /^\W+$/
  TRAIN_NUMBER = /^[[0-9]|[a-z]]{3}-?[[0-9]|[a-z]]{2}$/
  MAX_BEARING_CAPACITY = 1000
  MAX_SEATS = 700
  module StationValidations
    include ExceptionsModule::StationExceptions

    private

    def station_name_validation
      raise InvalidStationNameError if name =~ FORBIDDEN_SYMBOLS || name.empty?
    end

    def validate_station_uniqness(station)
      raise NotUniqStation if Station.all.include?(station)
    end

    def valid_station_name?
      station_name_validation
      true
    rescue StandardError
      false
    end
  end

  module TrainValidations
    include ExceptionsModule::TrainExceptions

    private

    def train_number_validation
      raise InvalidTrainNumberError if number !~ TRAIN_NUMBER
    end

    def valid_train_number?
      train_number_validation
      true
    rescue StandardError
      false
    end

    def validate_carriage_attachment(carriage)
      raise FalliedCarriageAttachment unless valid_carriage_type?(carriage) && !carriage.current_train && !moving?
    end

    def validate_carriage_detachment
      raise FalliedCarriageDetachment if moving?
    end

    def valid_carriage_type?(carriage)
      type == carriage.type
    end

    def validate_destination_station(destination_station)
      raise ImpossibleMovement unless destination_station
    end
  end

  module RouteValidations
    include ExceptionsModule::RouteExceptions

    private

    def validate_change_route(station)
      raise FalliedChangeRoute unless station.current_trains.select { |train| train.route == self }.empty?
    end
  end

  module TrainCompanyValidations
    include ExceptionsModule::TrainCompanyExceptions

    private

    def train_company_validation
      raise InvalidTrainCompanyNameError if train_company =~ FORBIDDEN_SYMBOLS || train_company.empty?
    end
  end

  module CargoTrainValidations
    include ExceptionsModule::CargoTrainExceptions

    private

    def validate_total_bearing_capacity(capacity)
      raise BearingCapacityExcess if capacity > MAX_BEARING_CAPACITY
    end
  end

  module PassengerTrainValidations
    include ExceptionsModule::PassengerTrainExceptions

    private

    def validate_total_seats(seats)
      raise SeatsExcess if seats > MAX_SEATS
    end
  end

  module RailwayValidations
    include ExceptionsModule::RailwayExceptions

    private

    def validate_stations_amount(stations = nil)
      raise InsufficientStationsAmount if stations.size < 2
    end

    def validate_transitional_stations_amount(stations)
      raise InsufficientStationsAmount if stations.empty?
    end

    def valid_transitional_stations_amount?(stations)
      validate_transitional_stations_amount(stations)
    rescue InsufficientStationsAmount
      false
    else
      true
    end

    def enough_seats?(carriage)
      if carriage.free_seats.positive?
        true
      else
        false
      end
    end

    def empty_passenger_carriage?(carriage)
      if carriage.occupied_seats.zero?
        true
      else
        false
      end
    end

    def enough_capacity?(carriage, cargo)
      carriage.free_capcity >= cargo
    end

    def empty_cargo_carriage?(carriage)
      if carriage.occupied_capacity.zero?
        true
      else
        false
      end
    end

    def validate_trains_amount
      raise InsufficientTrainsAmount if trains.empty?
    end

    def validate_carriages_amount(_train = nil)
      raise InsufficientCarriagesAmount if carriages.empty?
    end

    def available_carriages?
      if available_carriages.size == 0
        puts InsufficientCarriagesAmount.new.message
        false
      else
        true
      end
    end

    def validate_available_stations(route)
      raise InsufficientStationsAmount if available_stations(route).size < 1
    end

    def train_carriages_present?(train)
      if train.carriages.empty?
        false
      else
        true
      end
    end
  end
end
