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

  def report_current_trains
    puts "There are #{current_trains.size} train(s) on station #{name}"
    current_trains.each { |train| puts train.to_s }
    nil
  end

  def report_trains_by_type(type)
    trains = current_trains.select { |train| train.type == type }
    puts "There are #{trains.size} train(s) of #{type} type on station #{name}:"
    trains.each { |train| puts train.to_s } unless trains.empty?
  end

  def to_s
    "#{name}, #{report_current_trains}"
  end
end
