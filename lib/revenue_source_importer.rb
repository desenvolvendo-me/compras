class RevenueSourceImporter < Importer
  attr_accessor :storage, :revenue_subcategory_storage, :revenue_category_storage

  def initialize(storage = RevenueSource, revenue_subcategory_storage = RevenueSubcategory, revenue_category_storage = RevenueCategory)
    self.storage = storage
    self.revenue_subcategory_storage = revenue_subcategory_storage
    self.revenue_category_storage = revenue_category_storage
  end

  protected

  def normalize_attributes(attributes)
    category_code    = attributes['code'][0]
    subcategory_code = attributes['code'][1]
    code             = attributes['code'][2]

    category = revenue_category_storage.find_by_code(category_code)
    subcategory = revenue_subcategory_storage.find_by_code_and_revenue_category_id(subcategory_code, category.try(:id))

    attributes.merge('revenue_subcategory_id' => subcategory.try(:id), 'code' => code)
  end

  def file
    'lib/import/files/revenue_sources.csv'
  end
end
