class PledgeHistoricImporter < Importer
  attr_accessor :repository

  def initialize(repository = PledgeHistoric)
    self.repository = repository
  end

  protected

  def normalize_attributes(attributes)
    attributes.merge('source' => default_source)
  end

  def default_source
    repository.default_source
  end

  def file
    'lib/import/files/pledge_historics.csv'
  end
end
