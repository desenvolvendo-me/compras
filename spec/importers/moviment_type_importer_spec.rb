# encoding: utf-8
require 'importer_helper'
require 'app/importers/moviment_type_importer'

describe MovimentTypeImporter do
  subject do
    MovimentTypeImporter.new(null_repository)
  end

  let :null_repository do
    repository = double.as_null_object

    repository.stub(:transaction) do |&block|
      block.call
    end

    repository.stub(:sum_operation).and_return('sum')
    repository.stub(:subtraction_operation).and_return('subtraction')
    repository.stub(:budget_allocation_character).and_return('budget_allocation')
    repository.stub(:capability_character).and_return('capability')
    repository.stub(:default_source).and_return('default')

    repository
  end

  it 'import' do
    null_repository.should_receive(:create!).with('name' => 'Adicionar dotação', 'operation' => 'sum', 'character' => 'budget_allocation', 'source' => 'default')
    null_repository.should_receive(:create!).with('name' => 'Subtrair de outros casos', 'operation' => 'subtraction', 'character' => 'capability', 'source' => 'default')
    null_repository.should_receive(:create!).with('name' => 'Subtrair convênio', 'operation' => 'subtraction', 'character' => 'capability', 'source' => 'default')

    subject.import!
  end
end
