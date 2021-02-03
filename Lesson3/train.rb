class Train
  attr_accessor :number

  attr_reader :type, :speed, :current_station, :route, :carriage

  def initialize(number, type, carriage)
    @number = number
    @type = type
    @carriage = carriage
    @speed = 0
  end

  def speed_up(speed)
    self.speed += speed
  end

  def stop
    @speed = 0
  end

  def attach_carriage
    self.carriage += 1 unless moving?
  end

  def detach_carriage
    self.carriage -= 1 unless moving?
  end

  def route=(route)
    @route = route
    self.current_station = route.first_station
    move(current_station)
    next_station
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
    next_station
    if @current_station == @route.last_station
      puts 'This is the last station on the route.'
    else
      move(next_station)
    end
    report_location
  end

  def move_back
    previous_station
    if @current_station == @route.first_station
      puts 'This is the first station on the route.'
    else
      move(previous_station)
    end
    report_location
  end

  def previous_station
    @previous_station = if station_number.nil? && next_station.nil? && route.transitional_stations.empty?
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
    @next_station = if station_number.nil? && current_station == route.first_station && route.transitional_stations.empty?
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

  attr_writer :current_station, :speed, :carriage

  def moving?
    speed.positive?
  end

  def move(destination_station)
    current_station.departure_train(self)
    destination_station.recieve_train(self)
    self.current_station = destination_station
    next_station
    previous_station
  end

  def station_number
    @station_number = route.transitional_stations.index(current_station)
  end
end
