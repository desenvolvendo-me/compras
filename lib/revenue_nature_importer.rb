class RevenueNatureImporter < Importer
  attr_accessor :storage, :revenue_category_storage

  def initialize(storage = RevenueNature, revenue_category_storage = RevenueCategory)
    self.storage = storage
    self.revenue_category_storage = revenue_category_storage
  end

  protected

  def normalize_attributes(attributes)
    parent_code = attributes['code'][0]
    parent = revenue_category_storage.find_by_code(parent_code)

    code = attributes['code'][1]

    attributes.merge('parent_id' => parent.try(:id), 'code' => code)
  end

  def file
    'lib/import/files/revenue_natures.csv'
  end
end
