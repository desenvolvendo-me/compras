# encoding: utf-8
class ExpenseModalityImporter < Importer
  attr_accessor :storage

  def initialize(storage = ExpenseModality)
    self.storage = storage
  end

  protected

  def file
    'lib/import/files/expense_modalities.csv'
  end
end
