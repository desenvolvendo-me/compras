class RevenueRubricImporter < Importer
  attr_accessor :repository, :revenue_source_repository, :revenue_subcategory_repository
  attr_accessor :revenue_category_repository

  def initialize(repository = RevenueRubric, revenue_source_repository = RevenueSource)
    self.repository = repository
    self.revenue_source_repository = revenue_source_repository
    self.revenue_subcategory_repository = revenue_subcategory_repository
    self.revenue_category_repository = revenue_category_repository
  end

  protected

  def normalize_attributes(attributes)
    rubric_code = attributes['code'][3]

    attributes.merge('revenue_source_id' => source_id_by(attributes), 'code' => rubric_code)
  end

  def source_id_by(attributes)
    category_code    = attributes['code'][0]
    subcategory_code = attributes['code'][1]
    source_code      = attributes['code'][2]

    source = revenue_source_repository.joins { revenue_subcategory.revenue_category }.
      where { revenue_subcategory.revenue_category.code.eq(category_code) & revenue_subcategory.code.eq(subcategory_code) & code.eq(source_code) }.first

    source.try(:id)
  end

  def file
    'lib/import/files/revenue_rubrics.csv'
  end
end
