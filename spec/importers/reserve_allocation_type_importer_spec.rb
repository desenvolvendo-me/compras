# encoding: utf-8
require 'importer_helper'
require 'app/importers/reserve_allocation_type_importer'

describe ReserveAllocationTypeImporter do
  subject do
    ReserveAllocationTypeImporter.new(null_storage)
  end

  let :null_storage do
    storage = double.as_null_object

    storage.stub(:transaction) do |&block|
      block.call
    end

    storage.stub(:default_status).and_return('active')

    storage
  end

  it 'imports reserve allocation types' do
    null_storage.should_receive(:create!).with('description' => 'Comum', 'status' => 'active')
    null_storage.should_receive(:create!).with('description' => 'Licitação', 'status' => 'active')
    null_storage.should_receive(:create!).with('description' => 'Cotas mensais', 'status' => 'active')
    null_storage.should_receive(:create!).with('description' => 'Limitações de empenho', 'status' => 'active')

    subject.import!
  end
end
