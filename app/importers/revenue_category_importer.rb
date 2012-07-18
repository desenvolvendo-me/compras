# encoding: utf-8
class RevenueCategoryImporter < Importer
  attr_accessor :repository

  def initialize(repository = RevenueCategory)
    self.repository = repository
  end

  protected

  def file
    'lib/import/files/revenue_categories.csv'
  end
end
