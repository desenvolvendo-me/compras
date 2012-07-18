class StateImporter < Importer
  attr_accessor :repository

  def initialize(repository = State)
    self.repository = repository
  end

  protected

  def file
    'lib/import/files/states.csv'
  end
end
