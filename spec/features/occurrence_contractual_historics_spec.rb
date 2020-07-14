require 'spec_helper'

feature "OccurrenceContractualHistorics", vcr: { cassette_name: :occurrence_contractual_historics } do
  let(:current_user) { User.make!(:sobrinho) }

  background do
    create_roles ['contracts']
    sign_in
  end

  scenario 'create a new occurrence_contractual_historic, update and destroy an existing' do
    Contract.make!(:primeiro_contrato)

    navigate 'Contratos > Contratos'

    

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
