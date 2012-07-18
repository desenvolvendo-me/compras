class CityImporter < Importer
  attr_accessor :repository

  def initialize(repository = City)
    self.repository = repository
  end

  protected

  def file
    'lib/import/files/cities.csv'
  end
end
