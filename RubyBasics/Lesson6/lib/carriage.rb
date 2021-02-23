require_relative '../modules/train_company'
class Carriage
  attr_accessor :current_train
  attr_reader :type

  prepend TrainCompany
end
