class RevenueCategoryImporter < Importer
  attr_accessor :storage

  def initialize(storage = RevenueCategory)
    self.storage = storage
  end

  protected

  def file
    'lib/import/files/revenue_categories.csv'
  end
end
