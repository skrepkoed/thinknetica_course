# frozen_string_literal: true

require_relative 'validation_module'
require_relative 'accessors'
module TrainCompany
  extend Accessors
  strong_attr_accessor train_company: String

  include Validations::TrainCompanyValidations
  def initialize(train_company, *attributes)
    self.train_company = train_company
    train_company_validation
    super(train_company, *attributes)
  end
end
