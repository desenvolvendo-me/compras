class PledgeHistoricImporter < Importer
  attr_accessor :repository, :default_source

  def initialize(repository = PledgeHistoric, default_source = Source::DEFAULT)
    self.repository = repository
    self.default_source = default_source
  end

  protected

  def normalize_attributes(attributes)
    attributes.merge('source' => default_source)
  end

  def file
    'lib/import/files/pledge_historics.csv'
  end
end
