class RevenueSourceImporter < Importer
  attr_accessor :repository, :revenue_subcategory_repository

  def initialize(repository = RevenueSource, revenue_subcategory_repository = RevenueSubcategory)
    self.repository = repository
    self.revenue_subcategory_repository = revenue_subcategory_repository
  end

  protected

  def normalize_attributes(attributes)
    category_code    = attributes['code'][0]
    subcategory_code = attributes['code'][1]
    source_code      = attributes['code'][2]

    subcategory = revenue_subcategory_repository.joins { revenue_category }.
      where { revenue_category.code.eq(category_code) & code.eq(subcategory_code) }.first

    attributes.merge('revenue_subcategory_id' => subcategory.try(:id), 'code' => source_code)
  end

  def file
    'lib/import/files/revenue_sources.csv'
  end
end
