class CountryImporter < Importer
  attr_accessor :storage

  def initialize(storage = Country)
    self.storage = storage
  end

  protected

  def file
    'lib/import/files/countries.csv'
  end
end
