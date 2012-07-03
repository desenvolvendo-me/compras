# encoding: utf-8
require 'importer_helper'
require 'app/importers/expense_modality_importer'
require 'active_support/core_ext/object/try'

describe ExpenseModalityImporter do
  subject do
    described_class.new(null_storage)
  end

  let :null_storage do
    storage = double.as_null_object

    storage.stub(:transaction) do |&block|
      block.call
    end

    storage
  end

  it 'imports expense modalities' do
    null_storage.should_receive(:create!).with('code' => '10', 'description' => 'TRANSFERÊNCIAS INTRAGOVERNAMENTAIS')
    null_storage.should_receive(:create!).with('code' => '90', 'description' => 'APLICAÇÕES DIRETAS')
    null_storage.should_receive(:create!).with('code' => '41', 'description' => 'TRANSFERÊNCIAS A MUNICÍPIOS FUNDO A FUNDO')

    subject.import!
  end
end
