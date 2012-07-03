# encoding: utf-8
require 'importer_helper'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/hash/except'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'
require 'app/importers/revenue_nature_importer'

describe RevenueNatureImporter do
  subject do
    described_class.new(null_storage, category_storage, subcategory_storage, source_storage, rubric_storage, code_generator)
  end

  let :null_storage do
    storage = double.as_null_object

    storage.stub(:transaction) do |&block|
      block.call
    end

    storage
  end

  let :code_generator do
    double(:generate! => true)
  end

  let :revenue_nature_object do
    double(:save => true)
  end

  let :category_storage do
    double(:id => 1)
  end

  let :subcategory_storage do
    double(:id => 2)
  end

  let :source_storage do
    double(:id => 3)
  end

  let :rubric_storage do
    double(:id => 4)
  end

  it 'imports' do
    category_storage.stub(:where).and_return([category_storage])
    subcategory_storage.stub(:where).and_return([subcategory_storage])
    source_storage.stub(:where).and_return([source_storage])
    rubric_storage.stub(:where).and_return([rubric_storage])
    code_generator.stub(:new).and_return(code_generator)

    null_storage.should_receive(:new).with('specification' => 'RECEITAS CORRENTES', 'kind' => 'synthetic', 'docket' => 'REPRESENTA O SOMATÓRIO DOS VALORES DA ARRECADAÇÃO DAS RECEITAS TRIBUTÁRIA, DE CONTRIBUIÇÕES, PATRIMONIAL, AGROPECUÁRIA, INDUSTRIAL, DE SERVIÇOS, AS  TRANSFERÊNCIAS CORRENTES E OUTRAS RECEITAS CORRENTES.', 'revenue_category_id' => 1, 'revenue_subcategory_id' => 2, 'revenue_source_id' => 3, 'revenue_rubric_id' => 4, 'classification' => '0000').and_return(revenue_nature_object)
    null_storage.should_receive(:new).with('specification' => 'RECEITA TRIBUTÁRIA', 'kind' => 'synthetic', 'docket' => 'REPRESENTA O SOMATÓRIO DOS VALORES DA ARRECADAÇÃO DA RECEITA TRIBUTÁRIA (IMPOSTOS, TAXAS E CONTRIBUIÇÕES DE MELHORIA', 'revenue_category_id' => 1, 'revenue_subcategory_id' => 2, 'revenue_source_id' => 3, 'revenue_rubric_id' => 4, 'classification' => '0000').and_return(revenue_nature_object)
    null_storage.should_receive(:new).with('specification' => 'IMPOSTO SOBRE A TRANSMISSÃO INTER VIVOS - BENS IMÓVEIS E DIREITOS REAIS SOBRE IMÓVEIS', 'kind' => 'analytical', 'docket' => 'REGISTRA O VALOR  DA ARRECADAÇÃO DA RECEITA DE IMPOSTO SOBRE TRANSMISSÃO "INTER-VIVOS" DE BENS IMÓVEIS E DE DIREITOS REAIS SOBRE IMÓVEIS, DE COMPETÊNCIA MUNICIPAL.', 'revenue_category_id' => 1, 'revenue_subcategory_id' => 2, 'revenue_source_id' => 3, 'revenue_rubric_id' => 4, 'classification' => '0800').and_return(revenue_nature_object)
    null_storage.should_receive(:new).with('specification' => 'IMPOSTOS SOBRE A PRODUÇÃO E A CIRCULAÇÃO', 'kind' => 'synthetic', 'docket' => 'REPRESENTA O SOMATÓRIO  DOS VALORES DA ARRECADAÇÃO DE IMPOSTOS SOBRE PRODUÇÃO E A CIRCULAÇÃO QUE COMPREENDE O IMPOSTO SOBRE SERVIÇOS - ISS.', 'revenue_category_id' => 1, 'revenue_subcategory_id' => 2, 'revenue_source_id' => 3, 'revenue_rubric_id' => 4, 'classification' => '0000').and_return(revenue_nature_object)
    null_storage.should_receive(:new).with('specification' => 'RETIDO NAS FONTES - OUTROS RENDIMENTOS', 'kind' => 'analytical', 'docket' => 'REGISTRA O VALOR  DA ARRECADAÇÃO DA RECEITA DO IMPOSTO SOBRE GANHOS DECORRENTES DE GANHOS E SORTEIOS EM GERAL', 'revenue_category_id' => 1, 'revenue_subcategory_id' => 2, 'revenue_source_id' => 3, 'revenue_rubric_id' => 4, 'classification'=> '0434').and_return(revenue_nature_object)
    null_storage.should_receive(:new).any_number_of_times.and_return(revenue_nature_object)

    subject.import!
  end
end
