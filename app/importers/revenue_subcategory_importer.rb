class RevenueSubcategoryImporter < Importer
  attr_accessor :storage, :revenue_category_storage

  def initialize(storage = RevenueSubcategory, revenue_category_storage = RevenueCategory)
    self.storage = storage
    self.revenue_category_storage = revenue_category_storage
  end

  protected

  def normalize_attributes(attributes)
    revenue_category_code = attributes['code'][0]
    revenue_category = revenue_category_storage.find_by_code(revenue_category_code)

    code = attributes['code'][1]

    attributes.merge('revenue_category_id' => revenue_category.try(:id), 'code' => code)
  end

  def file
    'lib/import/files/revenue_subcategories.csv'
  end
end
