# encoding: utf-8
require 'importer_helper'
require 'app/importers/expense_group_importer'
require 'active_support/core_ext/object/try'

describe ExpenseGroupImporter do
  subject do
    described_class.new(null_repository)
  end

  let :null_repository do
    repository = double.as_null_object

    repository.stub(:transaction) do |&block|
      block.call
    end

    repository
  end

  it 'imports expense groups' do
    null_repository.should_receive(:create!).with('code' => '0', 'description' => 'RESTOS A PAGAR')
    null_repository.should_receive(:create!).with('code' => '4', 'description' => 'INVESTIMENTOS')
    null_repository.should_receive(:create!).with('code' => '9', 'description' => 'RESERVA DE CONTINGÊNCIA')

    subject.import!
  end
end
