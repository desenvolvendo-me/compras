class CompanySizeImporter < Importer
  attr_accessor :repository

  def initialize(repository = CompanySize)
    self.repository = repository
  end

  protected

  def file
    'lib/import/files/company_sizes.csv'
  end
end
