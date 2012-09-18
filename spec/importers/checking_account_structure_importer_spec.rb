# encoding: utf-8
require 'importer_helper'
require 'app/importers/checking_account_structure_importer'
require 'active_support/core_ext/object/try'

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

  let :checking_account_structure_object do
    double(:save => true)
  end

  let :fiscal_account do
    double(:id => 1)
  end

  let :structure_information do
    double(:id => 1)
  end

  let :null_repository do
    repository = double.as_null_object

    repository.should_receive(:transaction) do |&block|
      block.call
    end

    repository
  end

  it 'should create two checking_account_structure and raise not found checking_account_structure_information' do
    fiscal_account_repository.stub(:find_by_name => fiscal_account)
    structure_information_repository.stub(:find_by_name => structure_information)

    null_repository.should_receive(:new).with({ "checking_account_structure_information_id" => 1,
                                                 "checking_account_of_fiscal_account_id" => 1,
                                                 "name" => "FonteRecursos", "description" => nil,
                                                 "tag" => "FonteRecursos", "fill" => nil, "reference" => nil }).
                                          and_return(checking_account_structure_object)

    null_repository.should_receive(:new).with({ "checking_account_structure_information_id" => 1,
                                                 "checking_account_of_fiscal_account_id" => 1,
                                                 "name" => "CodigoAplicacao", "description" => nil,
                                                 "tag" => "CodigoAplicacao", "fill" => nil, "reference" => nil }).
                                          and_return(checking_account_structure_object)

    null_repository.should_receive(:new).with({ "checking_account_structure_information_id" => 1,
                                                 "checking_account_of_fiscal_account_id" => 1,
                                                 "name" => "FonteRecursos", "description" => nil,
                                                 "tag" => "FonteRecursos", "fill" => nil, "reference" => nil }).
                                          and_return(checking_account_structure_object)

    null_repository.should_receive(:new).any_number_of_times.and_return(checking_account_structure_object)

    subject.import!
  end
end
