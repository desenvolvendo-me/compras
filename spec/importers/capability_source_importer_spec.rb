# encoding: utf-8
require 'importer_helper'
require 'app/importers/capability_source_importer'

describe CapabilitySourceImporter do
  subject do
    CapabilitySourceImporter.new(null_repository, 'import')
  end

  let :null_repository do
    repository = double.as_null_object

    repository.stub(:transaction) do |&block|
      block.call
    end

    repository
  end

  it 'imports' do
    null_repository.should_receive(:create!).with("code" => "1", "name" => "TESOURO", "specification" => "Recursos próprios gerados pelo Município, ou decorrentes de Cota-Parte Constitucional", "source" => "import")
    null_repository.should_receive(:create!).with("code" => "7", "name" => "OPERAÇÕES DE CRÉDITO", "specification" => "Recursos originários de operações de crédito internas ou externas", "source" => "import")
    null_repository.should_receive(:create!).with("code" => "97", "name" => "OPERAÇÕES DE CRÉDITO-exercícios anteriores", "specification" => "Recursos originários de operações de crédito internas ou externas; Utilizada apenas para controle das disponibilidades financeiras advindas do exercício anterior.", "source" => "import")

    subject.import!
  end
end
