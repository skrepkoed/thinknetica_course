class Train
  attr_accessor :number

  attr_reader :type, :speed, :current_station, :route

  def initialize(number)
    @number = number
    @carriages = []
    @speed = 0
  end

  def speed_up(speed)
    self.speed += speed
  end

  def stop
    @speed = 0
  end

  def attach_carriage(carriage)
    if allow_attach_carriage(carriage)
      carriage.current_train = self
      carriages << carriage
    end
  end

  def detach_carriage(carriage)
    carriages.delete(carriage) unless moving?
  end

  def route=(route)
    @route = route
    self.current_station = route.first_station
    move(current_station)
  end

  def to_s
    "number: #{number}, type: #{type}"
  end

  def report_location
    puts "Train: #{self}"
    puts "Route from #{route.first_station} to #{route.last_station}"
    puts "Previous station: #{previous_station}."
    puts "Current station: #{current_station}."
    puts "Next station: #{next_station}."
  end

  def move_forward
    next_station ? move(next_station) : (puts 'This is the last station on the route.')
    report_location
  end

  def move_back
    previous_station ? move(previous_station) : (puts 'This is the first station on the route.')
    report_location
  end

  def previous_station
    if station_number.nil? && next_station.nil? && route.transitional_stations.empty?
      route.first_station
    elsif station_number.nil? && next_station.nil?
      route.transitional_stations.last
    elsif station_number.nil? && current_station == route.first_station
      nil
    elsif station_number.zero?
      route.first_station
    else
      route.transitional_stations[station_number - 1]
    end
  end

  def next_station
    if station_number.nil? && current_station == route.first_station && route.transitional_stations.empty?
      route.last_station
    elsif station_number.nil? && current_station == route.first_station
      route.transitional_stations.first
    elsif current_station == route.transitional_stations.last
      route.last_station
    elsif station_number.nil? && current_station == route.last_station
      nil
    else
      route.transitional_stations[station_number + 1]
    end
  end

  private

  attr_writer :current_station, :speed

  attr_reader :carriages

  def moving?
    speed.positive?
  end

  def move(destination_station)
    current_station.departure_train(self)
    destination_station.recieve_train(self)
    self.current_station = destination_station
  end

  def station_number
    route.transitional_stations.index(current_station)
  end

  def allow_attach_carriage?(carriage)
    same_carriage_type?(carriage) && !carriage.current_train && !moving?
  end

  def same_carriage_type?(carriage)
    type == carriage.type
  end
end
