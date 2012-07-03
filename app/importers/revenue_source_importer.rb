class RevenueSourceImporter < Importer
  attr_accessor :storage, :revenue_subcategory_storage

  def initialize(storage = RevenueSource, revenue_subcategory_storage = RevenueSubcategory)
    self.storage = storage
    self.revenue_subcategory_storage = revenue_subcategory_storage
  end

  protected

  def normalize_attributes(attributes)
    category_code    = attributes['code'][0]
    subcategory_code = attributes['code'][1]
    source_code      = attributes['code'][2]

    subcategory = revenue_subcategory_storage.joins { revenue_category }.
      where { revenue_category.code.eq(category_code) & code.eq(subcategory_code) }.first

    attributes.merge('revenue_subcategory_id' => subcategory.try(:id), 'code' => source_code)
  end

  def file
    'lib/import/files/revenue_sources.csv'
  end
end
