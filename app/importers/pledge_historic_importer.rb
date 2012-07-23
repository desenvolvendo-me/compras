class PledgeHistoricImporter < Importer
  attr_accessor :repository, :source_repository

  def initialize(repository = PledgeHistoric, source_repository = Source)
    self.repository = repository
    self.source_repository = source_repository
  end

  protected

  def normalize_attributes(attributes)
    attributes.merge('source' => default_source)
  end

  def default_source
    source_repository.value_for('DEFAULT')
  end

  def file
    'lib/import/files/pledge_historics.csv'
  end
end
