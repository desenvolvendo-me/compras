# encoding: utf-8
require 'importer_helper'
require 'app/importers/pledge_historic_importer'

describe PledgeHistoricImporter do
  subject do
    PledgeHistoricImporter.new(null_repository, 'default')
  end

  let :null_repository do
    repository = double.as_null_object

    repository.stub(:transaction) do |&block|
      block.call
    end

    repository.stub(:default_source).and_return('default')

    repository
  end

  it 'imports pledge_historics' do
    null_repository.should_receive(:create!).with('description' => 'Comum', 'source' => 'default')
    null_repository.should_receive(:create!).with('description' => 'Auxilio', 'source' => 'default')
    null_repository.should_receive(:create!).with('description' => 'Outras Antecipações', 'source' => 'default')

    subject.import!
  end
end
