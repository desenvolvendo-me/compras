class ModalityLimitImporter < Importer
  attr_accessor :repository

  def initialize(repository = ModalityLimit)
    self.repository = repository
  end

  protected

  def file
    'lib/import/files/modality_limits.csv'
  end
end
