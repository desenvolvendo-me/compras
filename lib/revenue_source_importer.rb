class RevenueSourceImporter < Importer
  attr_accessor :storage, :revenue_nature_storage, :revenue_category_storage

  def initialize(storage = RevenueSource, revenue_nature_storage = RevenueNature, revenue_category_storage = RevenueCategory)
    self.storage = storage
    self.revenue_nature_storage = revenue_nature_storage
    self.revenue_category_storage = revenue_category_storage
  end

  protected

  def normalize_attributes(attributes)
    category_code = attributes['code'][0]
    nature_code   = attributes['code'][1]
    code          = attributes['code'][2]

    category = revenue_category_storage.find_by_code(category_code)
    nature = revenue_nature_storage.find_by_code_and_revenue_category_id(nature_code, category.try(:id))

    attributes.merge('revenue_nature_id' => nature.try(:id), 'code' => code)
  end

  def file
    'lib/import/files/revenue_sources.csv'
  end
end
