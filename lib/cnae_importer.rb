class CnaeImporter < Importer
  attr_accessor :storage

  def initialize(storage = Cnae)
    self.storage = storage
  end

  protected

  def normalize_attributes(attributes)
    parent_code = attributes.delete('parent_code')
    parent = storage.find_by_code(parent_code) if parent_code

    attributes.merge('parent_id' => parent.try(:id))
  end

  def file
    'lib/import/files/cnaes.csv'
  end
end
