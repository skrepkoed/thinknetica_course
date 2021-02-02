class Train
  attr_accessor :number, :station_number, :carriage

  attr_reader :type, :previous_station, :next_station, :speed, :current_station, :route

  def initialize(number, type, carriage)
    @number = number
    @type = type
    @carriage = carriage
    @speed = 0
  end

  def speed_up(speed)
    @speed += speed
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
    self.next_station = nil
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
    self.station_number = route.transitional_stations.index(current_station)
    if @current_station == @route.last_station
      self.next_station = nil
      puts 'This is the last station on the route.'
    else
      self.next_station = station_number
      move(next_station)
      self.current_station = next_station
      self.station_number = route.transitional_stations.index(current_station)
      self.next_station = station_number
      self.previous_station = station_number
    end
    report_location
  end

  def move_back
    self.station_number = route.transitional_stations.index(current_station)
    if @current_station == @route.first_station
      self.previous_station = nil
      puts 'This is the first station on the route.'
    else
      self.previous_station = station_number
      move(previous_station)
      self.current_station = previous_station
      self.station_number = route.transitional_stations.index(current_station)
      self.previous_station = station_number
      self.next_station = station_number
    end
    report_location
  end

  private

  attr_writer :current_station, :speed

  def moving?
    speed.positive?
  end

  def move(destination_station)
    current_station.departure_train(self)
    destination_station.recieve_train(self)
  end

  def previous_station=(station)
    @previous_station = if station.nil? && next_station.nil?
                          route.transitional_stations.last
                        elsif station.nil? && current_station == route.first_station
                          nil
                        elsif station.zero?
                          route.first_station
                        else
                          route.transitional_stations[station - 1]
                        end
  end

  def next_station=(station)
    @next_station = if station.nil? && previous_station.nil?
                      route.transitional_stations.first
                    elsif current_station == route.transitional_stations.last
                      route.last_station
                    elsif station.nil? && current_station == route.last_station
                      nil
                    else
                      route.transitional_stations[station + 1]
                    end
  end
end
