# frozen_string_literal: true

module ExceptionsModule
  module StationExceptions
    class StationException < RuntimeError
    end

    class InvalidStationNameError < StationException
      def message(name)
        "The #{name} is empty or contains forbidden symbols."
      end
    end

    class NotUniqStation < StationException
      def message(name)
        "That station #{name} already exists"
      end
    end
  end

  module RouteExceptions
    class FalliedChangeRoute < RuntimeError
      def message
        'You can`t remove station from the route if it`s current train`s station.'
      end
    end
  end

  module TrainExceptions
    class TrainException < RuntimeError
    end

    class InvalidTrainNumberError < TrainException
      def message
        'The number has invalid number format.'
      end
    end

    class ImpossibleMovement < TrainException
      def message
        'It is impossible to move in this direction'
      end
    end

    class FalliedCarriageAttachment < RuntimeError
      def message(carriage)
        "Fallied to attach #{carriage}. Check if carriage has right type or train is moving."
      end
    end

    class FalliedCarriageDetachment < RuntimeError
      def message
        'Fallied to detach carriage. Train is moving.'
      end
    end
  end

  module TrainCompanyExceptions
    class InvalidTrainCompanyNameError < RuntimeError
      def message
        'The train company name is empty or contains forbidden symbols.'
      end
    end
  end

  module CargoTrainExceptions
    class BearingCapacityExcess < RuntimeError
      def message
        'Train cannot hold so much carriages'
      end
    end
  end

  module CargoCarriageExceptions
    class InsufficientCapacityAmount < RuntimeError
      def message(carriage)
        "There are not enough capacity in carriage #{carriage}"
      end
    end
  end

  module PassengerTrainExceptions
    class SeatsExcess < RuntimeError
      def message(_total_seats)
        'Train cannot hold so much seats'
      end
    end
  end

  module RailwayExceptions
    class InsufficientEntity < RuntimeError
    end

    class InsufficientStationsAmount < InsufficientEntity
      def message
        'There are no stations.'
      end
    end

    class InsufficientTrainsAmount < InsufficientEntity
      def message
        'There are no trains. Please create at least one train.'
      end
    end

    class InsufficientRoutesAmount < InsufficientEntity
      def message
        'There are not enough routes. Please create at least one route.'
      end
    end

    class InsufficientCarriagesAmount < InsufficientEntity
      def message
        'There are not enough carriaiges. Please create at least one carriage.'
      end
    end

    class InsufficientSeatsAmount < RuntimeError
      def message(carriage)
        "There are not enough seats in carriage #{carriage}."
      end
    end
  end
end
