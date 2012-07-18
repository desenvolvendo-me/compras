class RevenueSubcategoryImporter < Importer
  attr_accessor :repository, :revenue_category_repository

  def initialize(repository = RevenueSubcategory, revenue_category_repository = RevenueCategory)
    self.repository = repository
    self.revenue_category_repository = revenue_category_repository
  end

  protected

  def normalize_attributes(attributes)
    revenue_category_code = attributes['code'][0]
    revenue_category = revenue_category_repository.find_by_code(revenue_category_code)

    code = attributes['code'][1]

    attributes.merge('revenue_category_id' => revenue_category.try(:id), 'code' => code)
  end

  def file
    'lib/import/files/revenue_subcategories.csv'
  end
end
