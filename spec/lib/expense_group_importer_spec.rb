# encoding: utf-8
require 'unit_helper'
require 'lib/importer'
require 'lib/expense_group_importer'
require 'active_support/core_ext/object/try'

describe ExpenseGroupImporter do
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

  it 'imports expense groups' do
    null_storage.should_receive(:create!).with('code' => '0', 'description' => 'RESTOS A PAGAR')
    null_storage.should_receive(:create!).with('code' => '4', 'description' => 'INVESTIMENTOS')
    null_storage.should_receive(:create!).with('code' => '9', 'description' => 'RESERVA DE CONTINGÊNCIA')

    subject.import!
  end
end
