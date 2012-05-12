class PrecatoryTypeImporter < Importer
  attr_accessor :storage

  def initialize(storage = PrecatoryType)
    self.storage = storage
  end

  def file
    'lib/import/files/precatory_types.csv'
  end

  protected

  def normalize_attributes(attributes)
    attributes.merge(:status => PrecatoryTypeStatus::ACTIVE)
  end
end
