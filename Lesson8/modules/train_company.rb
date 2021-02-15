# frozen_string_literal: true

require_relative 'validation_module'
module TrainCompany
  attr_reader :train_company

  include Validations::TrainCompanyValidations
  def initialize(train_company, *attributes)
    @train_company = train_company
    train_company_validation
    super(train_company, *attributes)
  end
end
