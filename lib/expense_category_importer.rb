# encoding: utf-8
class ExpenseCategoryImporter < Importer
  attr_accessor :storage

  def initialize(storage = ExpenseCategory)
    self.storage = storage
  end

  protected

  def file
    'lib/import/files/expense_categories.csv'
  end
end
