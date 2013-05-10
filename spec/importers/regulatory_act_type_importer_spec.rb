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
    null_repository.should_receive(:create!).with('description' => 'PPA', 'imported' => true)
    null_repository.should_receive(:create!).with('description' => 'LDO', 'imported' => true)
    null_repository.should_receive(:create!).with('description' => 'LOA', 'imported' => true)
    null_repository.should_receive(:create!).with('description' => 'Alteração Orçamentária', 'imported' => true)
    null_repository.should_receive(:create!).with('description' => 'Regulamenta o Registro de Preço no Município', 'imported' => true)
    null_repository.should_receive(:create!).with('description' => 'Regulamenta o Pregão no Município', 'imported' => true)

    subject.import!
  end
end
