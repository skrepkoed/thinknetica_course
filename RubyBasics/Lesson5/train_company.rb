module TrainCompany
  attr_reader :train_company

  def initialize(*attributes, train_company)
    super(*attributes, train_company)
    @train_company = train_company
  end
end
