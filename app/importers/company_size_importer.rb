class CompanySizeImporter < Importer
  attr_accessor :storage

  def initialize(storage = CompanySize)
    self.storage = storage
  end

  protected

  def file
    'lib/import/files/company_sizes.csv'
  end
end
