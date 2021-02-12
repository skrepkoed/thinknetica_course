require_relative 'validation_module'
module TrainCompany
  attr_reader :train_company

  include Validations::TrainCompanyValidations
  def initialize(*attributes, train_company)
    @train_company = train_company
    train_company_validation
    super(*attributes, train_company)
  end
end
