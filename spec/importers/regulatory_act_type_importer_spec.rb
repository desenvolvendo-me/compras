# encoding: utf-8
require 'importer_helper'
require 'app/importers/regulatory_act_type_importer'

describe RegulatoryActTypeImporter do
  subject do
    RegulatoryActTypeImporter.new(null_repository)#, 'import')
  end

  let :null_repository do
    repository = double.as_null_object

    repository.stub(:transaction) do |&block|
      block.call
    end

    repository
  end

  it 'imports' do
    null_repository.should_receive(:create!).with('description' => 'PPA', 'kind' => nil,  'imported' => true)
    null_repository.should_receive(:create!).with('description' => 'LDO', 'kind' => nil, 'imported' => true)
    null_repository.should_receive(:create!).with('description' => 'LOA', 'kind' => nil, 'imported' => true)
    null_repository.should_receive(:create!).with('description' => 'Alteração Orçamentária', 'kind' => nil, 'imported' => true)
    null_repository.should_receive(:create!).with('description' => 'Regulamenta o Registro de Preço no Município', 'kind' => '1',  'imported' => true)
    null_repository.should_receive(:create!).with('description' => 'Regulamenta o Pregão no Município', 'kind' => '2', 'imported' => true)

    subject.import!
  end
end
