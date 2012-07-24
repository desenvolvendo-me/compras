# encoding: utf-8
require 'importer_helper'
require 'app/importers/moviment_type_importer'

describe MovimentTypeImporter do
  subject do
    MovimentTypeImporter.new(null_repository, operation, character, source)
  end

  before do
    operation.stub(:value_for).with('ADD').and_return('add')
    operation.stub(:value_for).with('SUBTRACT').and_return('subtract')

    character.stub(:value_for).with('BUDGET_ALLOCATION').and_return('budget_allocation')
    character.stub(:value_for).with('CAPABILITY').and_return('capability')

    source.stub(:value_for).with('DEFAULT').and_return('default')
  end

  let :operation do
    double('Operation')
  end

  let :character do
    double('Character')
  end

  let :source do
    double('Source')
  end

  let :null_repository do
    repository = double.as_null_object

    repository.stub(:transaction) do |&block|
      block.call
    end

    repository
  end

  it 'import' do
    null_repository.should_receive(:create!).with('name' => 'Adicionar dotação', 'operation' => 'add', 'character' => 'budget_allocation', 'source' => 'default')
    null_repository.should_receive(:create!).with('name' => 'Subtrair de outros casos', 'operation' => 'subtract', 'character' => 'capability', 'source' => 'default')
    null_repository.should_receive(:create!).with('name' => 'Subtrair convênio', 'operation' => 'subtract', 'character' => 'capability', 'source' => 'default')

    subject.import!
  end
end
