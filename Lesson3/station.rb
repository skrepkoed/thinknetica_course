class Station
  attr_accessor :name
  attr_reader :current_trains

  def initialize(name)
    @name = name
    @current_trains = Hash.new { |trains, trains_type| trains[trains_type] = [] }
  end

  def recieve_train(train)
    current_trains[train.type] << train
  end

  def departure_train(train)
    current_trains[train.type].delete(train)
  end

  def report_current_trains
    total_trains = current_trains.values.inject(0) do |number, trains|
      number + trains.size
    end
    puts "There are #{total_trains} train(s) on station #{name}"
    current_trains.each_keys { |type| report_trains_by_type(type) }
  end

  def report_trains_by_type(type)
    trains = current_trains[type]
    puts "There are #{trains.size} train(s) of #{type} type on station #{name}:"
    trains.each { |train| puts train }
  end

  def to_s
    name.to_s
  end
end
