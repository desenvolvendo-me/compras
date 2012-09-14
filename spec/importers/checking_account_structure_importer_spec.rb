# encoding: utf-8
require 'importer_helper'
require 'app/importers/checking_account_structure_importer'

describe CheckingAccountStructureImporter do
  subject do
    CheckingAccountStructureImporter.new(null_repository, structure_information_repository, fiscal_account_repository)
  end

  let :structure_information_repository do
    double("CheckingAccountStructureInformation")
  end

  let :fiscal_account_repository do
    double("CheckingAccountOfFiscalAccount")
  end

  let :fiscal_account do
    double(:id => 2)
  end

  let :structure_information do
    double(:id => 1)
  end

  let :null_repository do repository = double.as_null_object

    repository.stub(:transaction) do |&block|
      block.call
    end

    repository
  end

  it 'should create two checking_account_structure and raise not found checking_account_structure_information' do
    fiscal_account_repository.should_receive(:find_by_name).with("DISPONIBILIDADE FINANCEIRA").exactly(3).times.and_return(fiscal_account)

    structure_information_repository.should_receive(:find_by_name).with("FONTE DE RECURSOS").and_return(structure_information)

    null_repository.should_receive(:create!).with("checking_account_structure_information_id" => 1,
                                                  "checking_account_of_fiscal_account_id" => 2,
                                                  "name" => "FonteRecursos", "description" => nil,
                                                  "tag" => "FonteRecursos", "fill" => nil, "reference" => nil)

    structure_information_repository.should_receive(:find_by_name).with("CÓDIGO DE APLICAÇÃO").and_return(structure_information)

    null_repository.should_receive(:create!).with("checking_account_structure_information_id" => 1,
                                                  "checking_account_of_fiscal_account_id" => 2,
                                                  "name" => "CodigoAplicacao", "description" => nil,
                                                  "tag" => "CodigoAplicacao", "fill" => nil, "reference" => nil)

    structure_information_repository.should_receive(:find_by_name).with(nil)

    expect { subject.import! }.to raise_error "O checking_account_structure_information <vazio> não existe na base de dados"
  end
end
