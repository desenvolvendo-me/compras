class PrecatoryTypeImporter < Importer
  attr_accessor :repository

  def initialize(repository = PrecatoryType)
    self.repository = repository
  end

  def file
    'lib/import/files/precatory_types.csv'
  end

  protected

  def normalize_attributes(attributes)
    attributes.merge('status' => PrecatoryTypeStatus::ACTIVE)
  end
end
