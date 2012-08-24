# encoding: utf-8
require 'spec_helper'

feature "AgreementKinds" do
  background do
    sign_in
  end

  scenario 'create a new agreement_kind' do
    navigate 'Contabilidade > Comum > Convênio > Tipos de Convênios'

    click_link 'Criar Tipo de Convênio'

    fill_in 'Descrição', :with => 'Contribuição'
    fill_in 'Cógido TCE', :with => '1'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo de Convênio criado com sucesso.'

    click_link 'Contribuição'

    expect(page).to have_field 'Descrição', :with => 'Contribuição'
    expect(page).to have_field 'Cógido TCE', :with => '1'
  end

  scenario 'update an existent agreement_kind' do
    AgreementKind.make!(:contribuicao)

    navigate 'Contabilidade > Comum > Convênio > Tipos de Convênios'

    click_link 'Contribuição'

    fill_in 'Descrição', :with => 'Auxílio'
    fill_in 'Cógido TCE', :with => '2'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo de Convênio editado com sucesso.'

    click_link 'Auxílio'

    expect(page).to have_field 'Descrição', :with => 'Auxílio'
    expect(page).to have_field 'Cógido TCE', :with => '2'
  end

  scenario 'destroy an existent agreement_kind' do
    AgreementKind.make!(:contribuicao)

    navigate 'Contabilidade > Comum > Convênio > Tipos de Convênios'

    click_link 'Contribuição'

    click_link 'Apagar', :confirm => true

    expect(page).to have_notice 'Tipo de Convênio apagado com sucesso.'

    expect(page).to_not have_content 'Contribuição'
  end
end
