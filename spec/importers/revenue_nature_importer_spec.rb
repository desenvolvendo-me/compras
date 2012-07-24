# encoding: utf-8
require 'importer_helper'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/hash/except'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'
require 'app/importers/revenue_nature_importer'

describe RevenueNatureImporter do
  subject do
    described_class.new(null_repository, category_repository, subcategory_repository, source_repository, rubric_repository, code_generator)
  end

  let :null_repository do
    repository = double.as_null_object

    repository.stub(:transaction) do |&block|
      block.call
    end

    repository
  end

  let :code_generator do
    double(:generate! => true)
  end

  let :revenue_nature_object do
    double(:save => true)
  end

  let :category_repository do
    double(:id => 1)
  end

  let :subcategory_repository do
    double(:id => 2)
  end

  let :source_repository do
    double(:id => 3)
  end

  let :rubric_repository do
    double(:id => 4)
  end

  it 'imports' do
    category_repository.stub(:where).and_return([category_repository])
    subcategory_repository.stub(:where).and_return([subcategory_repository])
    source_repository.stub(:where).and_return([source_repository])
    rubric_repository.stub(:where).and_return([rubric_repository])
    code_generator.stub(:new).and_return(code_generator)

    null_repository.should_receive(:new).with('specification' => 'RECEITAS CORRENTES', 'kind' => 'synthetic', 'docket' => 'REPRESENTA O SOMATÓRIO DOS VALORES DA ARRECADAÇÃO DAS RECEITAS TRIBUTÁRIA, DE CONTRIBUIÇÕES, PATRIMONIAL, AGROPECUÁRIA, INDUSTRIAL, DE SERVIÇOS, AS  TRANSFERÊNCIAS CORRENTES E OUTRAS RECEITAS CORRENTES.', 'revenue_category_id' => 1, 'revenue_subcategory_id' => 2, 'revenue_source_id' => 3, 'revenue_rubric_id' => 4, 'classification' => '00.00').and_return(revenue_nature_object)
    null_repository.should_receive(:new).with('specification' => 'RECEITA TRIBUTÁRIA', 'kind' => 'synthetic', 'docket' => 'REPRESENTA O SOMATÓRIO DOS VALORES DA ARRECADAÇÃO DA RECEITA TRIBUTÁRIA (IMPOSTOS, TAXAS E CONTRIBUIÇÕES DE MELHORIA', 'revenue_category_id' => 1, 'revenue_subcategory_id' => 2, 'revenue_source_id' => 3, 'revenue_rubric_id' => 4, 'classification' => '00.00').and_return(revenue_nature_object)
    null_repository.should_receive(:new).with('specification' => 'IMPOSTO SOBRE A TRANSMISSÃO INTER VIVOS - BENS IMÓVEIS E DIREITOS REAIS SOBRE IMÓVEIS', 'kind' => 'analytical', 'docket' => 'REGISTRA O VALOR  DA ARRECADAÇÃO DA RECEITA DE IMPOSTO SOBRE TRANSMISSÃO "INTER-VIVOS" DE BENS IMÓVEIS E DE DIREITOS REAIS SOBRE IMÓVEIS, DE COMPETÊNCIA MUNICIPAL.', 'revenue_category_id' => 1, 'revenue_subcategory_id' => 2, 'revenue_source_id' => 3, 'revenue_rubric_id' => 4, 'classification' => '08.00').and_return(revenue_nature_object)
    null_repository.should_receive(:new).with('specification' => 'IMPOSTOS SOBRE A PRODUÇÃO E A CIRCULAÇÃO', 'kind' => 'synthetic', 'docket' => 'REPRESENTA O SOMATÓRIO  DOS VALORES DA ARRECADAÇÃO DE IMPOSTOS SOBRE PRODUÇÃO E A CIRCULAÇÃO QUE COMPREENDE O IMPOSTO SOBRE SERVIÇOS - ISS.', 'revenue_category_id' => 1, 'revenue_subcategory_id' => 2, 'revenue_source_id' => 3, 'revenue_rubric_id' => 4, 'classification' => '00.00').and_return(revenue_nature_object)
    null_repository.should_receive(:new).with('specification' => 'RETIDO NAS FONTES - OUTROS RENDIMENTOS', 'kind' => 'analytical', 'docket' => 'REGISTRA O VALOR  DA ARRECADAÇÃO DA RECEITA DO IMPOSTO SOBRE GANHOS DECORRENTES DE GANHOS E SORTEIOS EM GERAL', 'revenue_category_id' => 1, 'revenue_subcategory_id' => 2, 'revenue_source_id' => 3, 'revenue_rubric_id' => 4, 'classification'=> '04.34').and_return(revenue_nature_object)
    null_repository.should_receive(:new).any_number_of_times.and_return(revenue_nature_object)

    subject.import!
  end
end
