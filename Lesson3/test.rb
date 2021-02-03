require './train'
require './route'
require './station'
require 'pry'
train = Train.new(132_324, :cargo, 5)
station1 = Station.new('First')
station2 = Station.new('Second')
station3 = Station.new('Third')
station4 = Station.new('Fourth')
route = Route.new(station1, station4)
route.add_transitional_station(station2)
route.add_transitional_station(station3)
train.route = route
train3 = Train.new(132_326, :cargo, 7)
train2 = Train.new(132_327, :passenger, 3)
