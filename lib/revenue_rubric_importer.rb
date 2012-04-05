class RevenueRubricImporter < Importer
  attr_accessor :storage, :revenue_source_storage, :revenue_nature_storage
  attr_accessor :revenue_category_storage

  def initialize(storage = RevenueRubric, revenue_source_storage = RevenueSource, revenue_nature_storage = RevenueNature, revenue_category_storage = RevenueCategory)
    self.storage = storage
    self.revenue_source_storage = revenue_source_storage
    self.revenue_nature_storage = revenue_nature_storage
    self.revenue_category_storage = revenue_category_storage
  end

  protected

  def normalize_attributes(attributes)
    category_code = attributes['code'][0]
    nature_code   = attributes['code'][1]
    source_code   = attributes['code'][2]
    code          = attributes['code'][3]

    category = revenue_category_storage.find_by_code(category_code)
    nature = revenue_nature_storage.find_by_code_and_revenue_category_id(nature_code, category.try(:id))
    source = revenue_source_storage.find_by_code_and_revenue_nature_id(source_code, nature.try(:id))

    attributes.merge('revenue_source_id' => source.try(:id), 'code' => code)
  end

  def file
    'lib/import/files/revenue_rubrics.csv'
  end
end
