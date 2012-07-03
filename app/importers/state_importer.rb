class StateImporter < Importer
  attr_accessor :storage

  def initialize(storage = State)
    self.storage = storage
  end

  protected

  def file
    'lib/import/files/states.csv'
  end
end
