# encoding: utf-8
require 'importer_helper'
require 'app/importers/occupation_classification_importer'

describe OccupationClassificationImporter do
  subject do
    OccupationClassificationImporter.new(null_repository)
  end

  let :null_repository do
    repository = double.as_null_object

    repository.stub(:transaction) do |&block|
      block.call
    end

    repository.stub(:order).with('id asc').and_return([])

    repository
  end

  it 'imports CBOs' do
    null_repository.should_receive(:create!).with('code' => '0', 'name' => 'MEMBROS DAS FORÇAS ARMADAS, POLICIAIS E BOMBEIROS MILITARES')
    null_repository.should_receive(:create!).with('code' => '01', 'name' => 'MEMBROS DAS FORÇAS ARMADAS')
    null_repository.should_receive(:create!).with('code' => '010',  'name' => 'MEMBROS DAS FORÇAS ARMADAS')
    null_repository.should_receive(:create!).with('code' => '0101', 'name' => 'Oficiais generais das forças armadas')

    subject.import!
  end
end
