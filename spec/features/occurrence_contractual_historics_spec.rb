require 'spec_helper'

feature "OccurrenceContractualHistorics" do
  let(:current_user) { User.make!(:sobrinho) }

  let :pledge do
    UnicoAPI::Resources::Contabilidade::Pledge.new(id: 1, value: 9.99, description: 'Empenho 1',
      year: 2013, to_s: 1, emission_date: "2013-01-01")
  end

  let :pledge_two do
    UnicoAPI::Resources::Contabilidade::Pledge.new(id: 2, value: 15.99, description: 'Empenho 2',
      year: 2012, to_s: 2, emission_date: "2012-01-01")
  end

  let :budget_structure do
    BudgetStructure.new(
      id: 1,
      code: '1',
      full_code: '1',
      tce_code: '051',
      description: 'Secretaria de Desenvolvimento',
      acronym: 'SEMUEDU',
      performance_field: 'Desenvolvimento Educacional')
  end

  background do
    create_roles ['contracts']
    sign_in

    UnicoAPI::Resources::Contabilidade::Pledge.stub(:all).and_return([pledge, pledge_two])

    UnicoAPI::Resources::Contabilidade::Pledge.stub(:find).with(1).and_return(pledge)
    UnicoAPI::Resources::Contabilidade::Pledge.stub(:find).with(2).and_return(pledge_two)
    BudgetStructure.stub(:find).and_return(budget_structure)
  end

  scenario 'create a new occurrence_contractual_historic, update and destroy an existing' do
    Contract.make!(:primeiro_contrato)

    navigate 'Instrumentos Contratuais > Contratos'

    click_link "Limpar Filtro"

    within_records do
      page.find('a').click
    end

    click_link 'Ocorrências Contratuais'

    click_link 'Criar Ocorrências Contratuais'

    fill_in 'Data da ocorrência', :with => '01/07/2012'
    select 'Outros', :from => 'Tipo de histórico'
    select 'Bilateral', :from => 'Tipo de alteração'
    fill_in 'Observações', :with => 'divergência contratual'

    click_button 'Salvar'

    expect(page).to have_notice 'Ocorrências Contratuais criado com sucesso.'

    click_link '1'

    expect(page).to have_field 'Sequência', :with => '1', disabled: true
    expect(page).to have_field 'Data da ocorrência', :with => '01/07/2012'
    expect(page).to have_field 'Observações', :with => 'divergência contratual'
    expect(page).to have_select 'Tipo de alteração', :selected => 'Bilateral'
    expect(page).to have_select 'Tipo de histórico', :selected => 'Outros'

    fill_in 'Data da ocorrência', :with => '10/07/2012'
    fill_in 'Observações', :with => 'problemas judiciais'

    click_button 'Salvar'

    expect(page).to have_notice 'Ocorrências Contratuais editado com sucesso.'

    click_link '1'

    expect(page).to have_field 'Data da ocorrência', :with => '10/07/2012'
    expect(page).to have_field 'Observações', :with => 'problemas judiciais'

    click_link 'Apagar'

    expect(page).to have_notice 'Ocorrências Contratuais apagado com sucesso.'
  end
end
