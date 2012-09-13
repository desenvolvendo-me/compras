# encoding: utf-8
require 'importer_helper'
require 'app/importers/checking_account_structure_information_importer'

describe CheckingAccountStructureInformationImporter do
  subject do
    CheckingAccountStructureInformationImporter.new(null_repository)
  end

  let :null_repository do repository = double.as_null_object

    repository.stub(:transaction) do |&block|
      block.call
    end

    repository
  end

  it 'imports' do
    null_repository.should_receive(:create!).with("tce_code" => "1.1", "name" => "FONTE DE RECURSOS")
    null_repository.should_receive(:create!).with("tce_code" => "7.4", "name" => "GRUPO DE DESPESA")
    null_repository.should_receive(:create!).with("tce_code" => "25.2", "name" => "TIPO DE CONTRATAÇÃO")

    subject.import!
  end
end
