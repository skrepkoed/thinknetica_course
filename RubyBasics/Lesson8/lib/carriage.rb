# frozen_string_literal: true

require_relative '../modules/train_company'
class Carriage
  attr_accessor :current_train
  attr_reader :type, :number

  def initialize(*_attributes)
    @number = rand 10_000..99_999
  end

  prepend TrainCompany
end
