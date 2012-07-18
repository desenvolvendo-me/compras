# encoding: utf-8
class ExpenseGroupImporter < Importer
  attr_accessor :repository

  def initialize(repository = ExpenseGroup)
    self.repository = repository
  end

  protected

  def file
    'lib/import/files/expense_groups.csv'
  end
end
