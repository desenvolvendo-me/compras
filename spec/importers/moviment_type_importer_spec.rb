# encoding: utf-8
require 'importer_helper'
require 'app/importers/moviment_type_importer'

describe MovimentTypeImporter do
  subject do
    MovimentTypeImporter.new(null_storage)
  end

  let :null_storage do
    storage = double.as_null_object

    storage.stub(:transaction) do |&block|
      block.call
    end

    storage.stub(:sum_operation).and_return('sum')
    storage.stub(:subtraction_operation).and_return('subtraction')
    storage.stub(:budget_allocation_character).and_return('budget_allocation')
    storage.stub(:capability_character).and_return('capability')
    storage.stub(:default_source).and_return('default')

    storage
  end

  it 'import' do
    null_storage.should_receive(:create!).with('name' => 'Adicionar dotação', 'operation' => 'sum', 'character' => 'budget_allocation', 'source' => 'default')
    null_storage.should_receive(:create!).with('name' => 'Subtrair de outros casos', 'operation' => 'subtraction', 'character' => 'capability', 'source' => 'default')
    null_storage.should_receive(:create!).with('name' => 'Subtrair convênio', 'operation' => 'subtraction', 'character' => 'capability', 'source' => 'default')

    subject.import!
  end
end
