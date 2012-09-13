# encoding: utf-8
class CheckingAccountOfFiscalAccountImporter < Importer
  attr_accessor :repository

  def initialize(repository = CheckingAccountOfFiscalAccount)
    self.repository = repository
  end

  protected

  def file
    "lib/import/files/checking_account_of_fiscal_accounts.csv"
  end
end
