# encoding: utf-8
require 'importer_helper'
require 'app/importers/occupation_classification_importer'

describe OccupationClassificationImporter do
  subject do
    OccupationClassificationImporter.new(null_storage)
  end

  let :null_storage do
    storage = double.as_null_object

    storage.stub(:transaction) do |&block|
      block.call
    end

    storage.stub(:order).with('id asc').and_return([])

    storage
  end

  it 'imports CBOs' do
    null_storage.should_receive(:create!).with('code' => '0', 'name' => 'MEMBROS DAS FORÇAS ARMADAS, POLICIAIS E BOMBEIROS MILITARES')
    null_storage.should_receive(:create!).with('code' => '01', 'name' => 'MEMBROS DAS FORÇAS ARMADAS')
    null_storage.should_receive(:create!).with('code' => '010',  'name' => 'MEMBROS DAS FORÇAS ARMADAS')
    null_storage.should_receive(:create!).with('code' => '0101', 'name' => 'Oficiais generais das forças armadas')

    subject.import!
  end
end
