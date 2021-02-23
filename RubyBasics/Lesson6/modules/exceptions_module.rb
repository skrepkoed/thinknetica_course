module ExceptionsModule
  module StationExceptions
    class InvalidStationNameError < RuntimeError
      def message(name)
        "The #{name} is empty or contains forbidden symbols."
      end
    end

    class NotUniqStation < RuntimeError
      def message
        'That station already exists'
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
    class InvalidTrainNumberError < RuntimeError
      def message(number)
        "The #{number} has invalid number format."
      end
    end

    class ImpossibleMovement < RuntimeError
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
      def message(train_company)
        "The #{train_company} is empty or contains forbidden symbols."
      end
    end
  end

  module CargoTrainExceptions
    class BearingCapacityExcess < RuntimeError
      def message(_total_bearing_capacity)
        'Train cannot hold so much carriages'
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
    class InsufficientStationsAmount < RuntimeError
      def message
        'There are no stations.'
      end
    end

    class InsufficientTrainsAmount < RuntimeError
      def message
        'There are no trains. Please create at least one train.'
      end
    end

    class InsufficientCarriagesAmount < RuntimeError
      def message
        'There are not enough carriaiges. Please create at least one carriage.'
      end
    end
  end
end
