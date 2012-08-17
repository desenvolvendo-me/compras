# encoding: utf-8
require 'importer_helper'
require 'app/importers/application_code_importer'

describe ApplicationCodeImporter do
  subject do
    ApplicationCodeImporter.new(null_repository, 'import')
  end

  let :null_repository do
    repository = double.as_null_object

    repository.stub(:transaction) do |&block|
      block.call
    end

    repository
  end

  it 'imports' do
    null_repository.should_receive(:create!).with("code" => "100", "variable" => true, "name" => "GERAL TOTAL- Convênios/entidades/fundos", "specification" => "Recursos específicos para aplicação em convênios, entidades ou fundos não vinculados a outras categorias pré-determinadas.Recursos  da entidade de livre aplicação", "source" => "import")
    null_repository.should_receive(:create!).with("code" => "262", "variable" => false, "name" => "EDUCAÇÃO-FUNDEB-OUTROS ", "specification" => "Recursos vinculados ao FUNDEB para aplicação em outras despesas", "source" => "import")
    null_repository.should_receive(:create!).with("code" => "620", "variable" => false, "name" => "RPPS-COMPENSAÇÃO PREVIDENCIÁRIA", "specification" => "Recursos advindos das receitas de compensação previdenciária ao RPPS cuja aplicação deverá ser vinculada ao RPPS", "source" => "import")

    subject.import!
  end
end
