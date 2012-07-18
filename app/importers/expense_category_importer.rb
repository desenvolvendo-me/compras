# encoding: utf-8
class ExpenseCategoryImporter < Importer
  attr_accessor :repository

  def initialize(repository = ExpenseCategory)
    self.repository = repository
  end

  protected

  def file
    'lib/import/files/expense_categories.csv'
  end
end
