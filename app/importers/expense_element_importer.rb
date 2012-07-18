# encoding: utf-8
class ExpenseElementImporter < Importer
  attr_accessor :repository

  def initialize(repository = ExpenseElement)
    self.repository = repository
  end

  protected

  def file
    'lib/import/files/expense_elements.csv'
  end
end
