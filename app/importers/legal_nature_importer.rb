class LegalNatureImporter < Importer
  attr_accessor :storage

  def initialize(storage = LegalNature)
    self.storage = storage
  end

  protected

  def normalize_attributes(attributes)
    # fetch list service '200' for code '2283'
    parent_code = attributes['code'].gsub(/(\d)\d{3}/, '\100')
    parent = storage.find_by_code(parent_code)

    attributes.merge('parent_id' => parent.try(:id))
  end

  def file
    'lib/import/files/legal_natures.csv'
  end
end
