class CountryImporter < Importer
  attr_accessor :repository

  def initialize(repository = Country)
    self.repository = repository
  end

  protected

  def file
    'lib/import/files/countries.csv'
  end
end
