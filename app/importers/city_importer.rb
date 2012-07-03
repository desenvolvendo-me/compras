class CityImporter < Importer
  attr_accessor :storage

  def initialize(storage = City)
    self.storage = storage
  end

  protected

  def file
    'lib/import/files/cities.csv'
  end
end
