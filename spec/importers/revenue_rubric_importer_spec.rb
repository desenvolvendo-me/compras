# encoding: utf-8
require 'importer_helper'
require 'app/importers/revenue_rubric_importer'
require 'active_support/core_ext/object/try'

describe RevenueRubricImporter do
  subject do
    described_class.new(null_repository, source_repository)
  end

  let :null_repository do
    repository = double.as_null_object

    repository.stub(:transaction) do |&block|
      block.call
    end

    repository
  end

  let :source_repository do
    double(:id => 1)
  end

  it 'imports revenue rubric' do
    source_repository.stub(:where).and_return([source_repository])
    source_repository.stub(:joins).and_return(source_repository)

    null_repository.should_receive(:create!).with('code' => '2', 'description' => 'IMPOSTOS SOBRE O PATRIMÔNIO E A RENDA', 'revenue_source_id' => 1)
    null_repository.should_receive(:create!).with('code' => '3', 'description' => 'IMPOSTOS SOBRE A PRODUÇÃO E A CIRCULAÇÃO', 'revenue_source_id' => 1)
    null_repository.should_receive(:create!).with('code' => '3', 'description' => 'TRANSFERÊNCIAS DE CONVÊNIOS DOS MUNICÍPIOS E SUAS ENTIDADES', 'revenue_source_id' => 1)
    null_repository.should_receive(:create!).with('code' => '0', 'description' => 'RECEITAS DA INDÚSTRIA DE TRANSFORMAÇÃO', 'revenue_source_id' => 1)

    subject.import!
  end
end
