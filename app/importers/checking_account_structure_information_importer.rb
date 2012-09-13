# encoding: utf-8
class CheckingAccountStructureInformationImporter < Importer
  attr_accessor :repository

  def initialize(repository = CheckingAccountStructureInformation)
    self.repository = repository
  end

  protected

  def file
    "lib/import/files/checking_account_structure_informations.csv"
  end
end
