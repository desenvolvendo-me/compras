# encoding: utf-8
require 'importer_helper'
require 'app/importers/pledge_historic_importer'

describe PledgeHistoricImporter do
  subject do
    PledgeHistoricImporter.new(null_storage)
  end

  let :null_storage do
    storage = double.as_null_object

    storage.stub(:transaction) do |&block|
      block.call
    end

    storage.stub(:default_source).and_return('default')

    storage
  end

  it 'imports cities' do
    null_storage.should_receive(:create!).with('description' => 'Comum', 'source' => 'default')
    null_storage.should_receive(:create!).with('description' => 'Auxilio', 'source' => 'default')
    null_storage.should_receive(:create!).with('description' => 'Outras Antecipações', 'source' => 'default')

    subject.import!
  end
end
