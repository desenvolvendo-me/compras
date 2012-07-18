# encoding: utf-8
require 'importer_helper'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/hash/except'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'
require 'app/importers/expense_nature_importer'

describe ExpenseNatureImporter do
  subject do
    described_class.new(null_repository, category_repository, group_repository, modality_repository, element_repository, code_generator)
  end

  let :null_repository do
    repository = double('NullStorage').as_null_object

    repository.stub(:transaction) do |&block|
      block.call
    end

    repository
  end

  let :code_generator do
    double('CodeGenerator', :generate! => true)
  end

  let :expense_nature_object do
    double('ExpenseNatureObject', :save => true)
  end

  let :category_repository do
    double('CategoryStorage', :id => 1)
  end

  let :group_repository do
    double('GroupStorage', :id => 2)
  end

  let :modality_repository do
    double('ModalityStorage', :id => 3)
  end

  let :element_repository do
    double('ElementStorage', :id => 4)
  end

  it 'imports' do
    category_repository.stub(:where).and_return([category_repository])
    group_repository.stub(:where).and_return([group_repository])
    modality_repository.stub(:where).and_return([modality_repository])
    element_repository.stub(:where).and_return([element_repository])
    code_generator.stub(:new).and_return(code_generator)

    null_repository.should_receive(:new).with('description' => 'DESPESAS CORRENTES', 'kind' => 'synthetic', 'docket' => 'REPRESENTA O SOMATÓRIO DOS VALORES DAS DESPESAS REALIZADAS COM PESSOAL E ENCARGOS SOCIAIS,JUROS E ENCARGOS DA DIVIDA INTERNA E EXTERNA E OUTRAS DESPESAS CORRENTES, QUE NÃO CONTRIBUEM, DIRETAMENTE, PARA A FORMAÇÃO OU AQUISIÇÃO DE UM BEM DE CAPITAL.', 'expense_category_id' => 1, 'expense_group_id' => 2, 'expense_modality_id' => 3, 'expense_element_id' => 4, 'expense_split' => '00').and_return(expense_nature_object)
    null_repository.should_receive(:new).with('description' => 'PESSOAL E ENCARGOS SOCIAIS', 'kind' => 'synthetic', 'docket' => 'REPRESENTA O SOMATÓRIO DOS VALORES DAS DESPESAS DE NATUREZA  REMUNERATÓRIA DECORRENTES DO EFETIVO EXERCÍCIO DE CARGO, EMPREGO OU FUNÇÃO DE CONFIANÇA NO SETOR PÚBLICO, DO PAGAMENTO DOS PROVENTOS DE APOSENTADORIAS, REFORMAS, PENSÕES, DAS OBRIGAÇÕES TRABALHISTAS DE RESPONSABILIDADE DO EMPREGADOR, INCIDENTES SOBRE A FOLHA DE SALÁRIOS, CONTRIBUIÇÕES A ENTIDADES FECHADAS DE PREVIDÊNCIA, OUTROS BENEFÍCIOS ASSISTENCIAIS CLASSIFICÁVEIS NESTE GRUPO DE DESPESA, BEM COMO SOLDO, GRATIFICAÇÕES, ADICIONAIS E OUTROS DIREITOS REMUNERATÓRIOS, PERTINENTES A ESTE GRUPO DE DESPESA, E AINDA, DESPESAS COM O RESSARCIMENTO DE PESSOAL REQUISITADO, DESPESAS COM A CONTRATAÇÃO TEMPORÁRIA PARA ATENDER A NECESSIDADE DE EXCEPCIONAL INTERESSE PÚBLICO E DESPESAS COM CONTRATOS DE TERCEIRIZAÇÃO DE MÃO-DE-OBRA QUE SE REFIRAM À SUBSTITUIÇÃO DE SERVIDORES E EMPREGADOS PÚBLICOS, EM ATENDIMENTO AO DISPOSTO NO ART.18 § 1°, DA LEI COMPLEMENTAR N° 101, DE 2000.', 'expense_category_id' => 1, 'expense_group_id' => 2, 'expense_modality_id' => 3, 'expense_element_id' => 4, 'expense_split' => '00').and_return(expense_nature_object)
    null_repository.should_receive(:new).with('description' => 'OUTROS BENEFÍCIOS ASSISTENCIAIS', 'kind' => 'analytical', 'docket' => 'REGISTRA O  VALOR DAS TRANSFERÊNCIAS EFETUADAS À UNIÃO  PARA REALIZAÇÕES DE DESPESAS COM AUXÍLIO-FUNERAL DEVIDO À FAMÍLIA DO SERVIDOR FELECIDO NA ATIVIDADE, OU APOSENTADO,  OU A TERCEIRO QUE CUSTEAR, COMPROVADAMENTE, AS DESPESAS COM O FUNERAL DO EX-SERVIDOR', 'expense_category_id' => 1, 'expense_group_id' => 2, 'expense_modality_id' => 3, 'expense_element_id' => 4, 'expense_split' => '00').and_return(expense_nature_object)
    null_repository.should_receive(:new).with('description' => 'SALÁRIO-FAMÍLIA ', 'kind' => 'analytical', 'docket' => 'REGISTRA O  VALOR DAS TRANSFERÊNCIAS EFETUADAS À UNIÃO  PARA REALIZAÇÕES DE DESPESAS COM BENEFÍCIO PECUNIÁRIO DEVIDO AOS DEPENDENTES ECONÔMICOS DO SERVIDOR, EXCLUSIVE OS REGIDOS PELA CONSOLIDAÇÃO DAS LEIS DO TRABALHO - CLT, OS QUAIS SÃO PAGOS À CONTA DO PLANO DE BENEFÍCIOS DA PREVIDÊNCIA SOCIAL', 'expense_category_id' => 1, 'expense_group_id' => 2, 'expense_modality_id' => 3, 'expense_element_id' => 4, 'expense_split' => '00').and_return(expense_nature_object)
    null_repository.should_receive(:new).with('description' => 'MATERIAL DE DISTRIBUIÇÃO GRATUÍTA', 'kind' => 'analytical', 'docket' => 'REGISTRA O  VALOR DAS TRANSFERÊNCIAS EFETUADAS A MUNICÍPIOS  PARA REALIZAÇÕES DE DESPESAS COM A AQUIISIÇÃO DE MATERIAIS DE DISTRIBUIÇÃO GRATUÍTA, TAIS COMO,LIVROS DIDÁTICOS, MEDICAMENTOS, GÊNEROS ALIMENTÍCIOS EOUTROS MATERIAIS OU BENS QUE POSSAM SER DISTRIBUÍDOS GRATUITAMENTE, EXCETO SE DESTINADOS A PREMIAÇÕES CULTURAIS, ARTÍSTICAS, CIENTÍFICAS, DESPORTIVAS E OUTRAS', 'expense_category_id' => 1, 'expense_group_id' => 2, 'expense_modality_id' => 3, 'expense_element_id' => 4, 'expense_split' => '00').and_return(expense_nature_object)
    null_repository.should_receive(:new).any_number_of_times.and_return(expense_nature_object)

    subject.import!
  end
end
