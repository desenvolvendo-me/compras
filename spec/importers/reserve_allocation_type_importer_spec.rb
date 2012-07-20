# encoding: utf-8
require 'importer_helper'
require 'app/importers/reserve_allocation_type_importer'

describe ReserveAllocationTypeImporter do
  subject do
    ReserveAllocationTypeImporter.new(null_repository, status)
  end

  let :status do
    double(:status)
  end

  let :null_repository do
    repository = double.as_null_object

    repository.stub(:transaction) do |&block|
      block.call
    end

    repository
  end

  it 'imports reserve allocation types' do
    status.stub(:value_for).with(:ACTIVE).and_return('active')

    null_repository.should_receive(:create!).with('description' => 'Comum', 'status' => 'active')
    null_repository.should_receive(:create!).with('description' => 'Licitação', 'status' => 'active')
    null_repository.should_receive(:create!).with('description' => 'Cotas mensais', 'status' => 'active')
    null_repository.should_receive(:create!).with('description' => 'Limitações de empenho', 'status' => 'active')

    subject.import!
  end
end
