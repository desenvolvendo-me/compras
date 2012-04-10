# encoding: utf-8
require 'unit_helper'
require 'lib/importer'
require 'lib/expense_category_importer'
require 'active_support/core_ext/object/try'

describe ExpenseCategoryImporter do
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

  it 'imports expense categories' do
    null_storage.should_receive(:create!).with('code' => '3', 'description' => 'DESPESA CORRENTE')
    null_storage.should_receive(:create!).with('code' => '7', 'description' => 'RESERVA ORÇAMENTÁRIA DO RPPS')
    null_storage.should_receive(:create!).with('code' => '9', 'description' => 'RESERVA DE CONTINGÊNCIA')

    subject.import!
  end
end
