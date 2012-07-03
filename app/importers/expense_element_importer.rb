# encoding: utf-8
class ExpenseElementImporter < Importer
  attr_accessor :storage

  def initialize(storage = ExpenseElement)
    self.storage = storage
  end

  protected

  def file
    'lib/import/files/expense_elements.csv'
  end
end
