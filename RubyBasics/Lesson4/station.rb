class Station
  attr_accessor :name
  attr_reader :current_trains

  def initialize(name)
    @name = name
    @current_trains = []
  end

  def recieve_train(train)
    current_trains << train
  end

  def departure_train(train)
    current_trains.delete(train)
  end

  def report_trains_by_type(type)
    current_trains.select { |train| train.type == type }
  end
end
