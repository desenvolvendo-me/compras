class PledgeHistoricImporter < Importer
  attr_accessor :storage

  def initialize(storage = PledgeHistoric)
    self.storage = storage
  end

  protected

  def normalize_attributes(attributes)
    attributes.merge('source' => default_source)
  end

  def default_source
    storage.default_source
  end

  def file
    'lib/import/files/pledge_historics.csv'
  end
end
