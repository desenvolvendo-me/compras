# encoding: utf-8
require 'unit_helper'
require 'lib/importer'
require 'lib/revenue_rubric_importer'
require 'active_support/core_ext/object/try'

describe RevenueRubricImporter do
  subject do
    described_class.new(null_storage, source_storage)
  end

  let :null_storage do
    storage = double.as_null_object

    storage.stub(:transaction) do |&block|
      block.call
    end

    storage
  end

  let :source_storage do
    double(:id => 1)
  end

  it 'imports revenue rubric' do
    source_storage.stub(:where).and_return([source_storage])
    source_storage.stub(:joins).and_return(source_storage)

    null_storage.should_receive(:create!).with('code' => '2', 'description' => 'IMPOSTOS SOBRE O PATRIMÔNIO E A RENDA', 'revenue_source_id' => 1)
    null_storage.should_receive(:create!).with('code' => '3', 'description' => 'IMPOSTOS SOBRE A PRODUÇÃO E A CIRCULAÇÃO', 'revenue_source_id' => 1)
    null_storage.should_receive(:create!).with('code' => '3', 'description' => 'TRANSFERÊNCIAS DE CONVÊNIOS DOS MUNICÍPIOS E SUAS ENTIDADES', 'revenue_source_id' => 1)
    null_storage.should_receive(:create!).with('code' => '0', 'description' => 'RECEITAS DA INDÚSTRIA DE TRANSFORMAÇÃO', 'revenue_source_id' => 1)

    subject.import!
  end
end
