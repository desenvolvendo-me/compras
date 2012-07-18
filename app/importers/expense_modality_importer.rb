# encoding: utf-8
class ExpenseModalityImporter < Importer
  attr_accessor :repository

  def initialize(repository = ExpenseModality)
    self.repository = repository
  end

  protected

  def file
    'lib/import/files/expense_modalities.csv'
  end
end
