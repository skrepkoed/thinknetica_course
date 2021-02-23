require_relative 'train_company'
class Carriage
  attr_accessor :current_train
  attr_reader :type

  prepend TrainCompany
end
