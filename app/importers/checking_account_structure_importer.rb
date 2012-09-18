# encoding: utf-8
class CheckingAccountStructureImporter < Importer
  attr_accessor :repository, :checking_account_structure_information_repository,
                :checking_account_of_fiscal_account_repository

  def initialize(repository = CheckingAccountStructure,
                 checking_account_structure_information_repository = CheckingAccountStructureInformation,
                 checking_account_of_fiscal_account_repository = CheckingAccountOfFiscalAccount)

    self.repository = repository
    self.checking_account_structure_information_repository = checking_account_structure_information_repository
    self.checking_account_of_fiscal_account_repository = checking_account_of_fiscal_account_repository
  end

  def import!
    transaction do
      parser.foreach(file, options) do |row|
        checking_account_structure = repository.new(normalize_attributes(row.to_hash))
        checking_account_structure.save(:validate => false)
      end
    end
  end

  protected

  def normalize_attributes(attributes)
    fiscal_account = fiscal_account_by_attributes(attributes)

    structure_information = structure_information_by_attributes(attributes)

    attributes.delete 'checking_account_of_fiscal_account'
    attributes.delete 'checking_account_structure_information'

    attributes.merge('checking_account_structure_information_id' => structure_information.try(:id),
                     'checking_account_of_fiscal_account_id' => fiscal_account.try(:id))
  end

  def file
    "lib/import/files/checking_account_structures.csv"
  end

  def fiscal_account_by_attributes(attributes)
    return unless attributes['checking_account_of_fiscal_account']

    fiscal_account_name = attributes['checking_account_of_fiscal_account']
    fiscal_account = checking_account_of_fiscal_account_repository.find_by_name(fiscal_account_name)

    unless fiscal_account
      raise "O checking_account_fiscal_account #{fiscal_account_name} não existe na base de dados"
    end

    fiscal_account
  end

  def structure_information_by_attributes(attributes)
    return unless attributes['checking_account_structure_information']

    structure_information_name = attributes['checking_account_structure_information']
    structure_information = checking_account_structure_information_repository.find_by_name(structure_information_name)

    unless structure_information
      raise "O checking_account_structure_information #{structure_information_name} não existe na base de dados"
    end

    structure_information
  end
end
