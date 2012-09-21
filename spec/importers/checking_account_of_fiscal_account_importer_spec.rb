# encoding: utf-8
require 'importer_helper'
require 'app/importers/checking_account_of_fiscal_account_importer'

describe CheckingAccountOfFiscalAccountImporter do
  subject do
    CheckingAccountOfFiscalAccountImporter.new(null_repository)
  end

  let :null_repository do
    repository = double.as_null_object

    repository.should_receive(:transaction).and_yield

    repository
  end

  it 'imports' do
    null_repository.should_receive(:create!).with("tce_code" => "2", "name" => "DOMICÍLIO BANCÁRIO",
                                                  "main_tag" => "DomicilioBancario", "function" => ".")

    null_repository.should_receive(:create!).with("tce_code" => "18", "name" => "ARRECADAÇÃO DIÁRIA",
                                                  "main_tag" => "ArrecadacaoDiaria", "function" => ".")

    null_repository.should_receive(:create!).with("tce_code" => "28", "name" => "EMPENHO EMITIDO",
                                                  "main_tag" => "EmpenhoEmitido", "function" => ".")

    subject.import!
  end
end
