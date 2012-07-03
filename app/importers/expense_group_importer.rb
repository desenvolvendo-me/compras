# encoding: utf-8
class ExpenseGroupImporter < Importer
  attr_accessor :storage

  def initialize(storage = ExpenseGroup)
    self.storage = storage
  end

  protected

  def file
    'lib/import/files/expense_groups.csv'
  end
end
