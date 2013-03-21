# encoding: utf-8
require 'spec_helper'

feature "Signatures" do
  background do
    sign_in
  end

  scenario 'create a new signature, update and destroy an existing' do
    Person.make!(:sobrinho)
    Position.make!(:gerente)
    Position.make!(:supervisor)

    navigate 'Geral > Parâmetros > Assinaturas > Assinaturas'

    click_link 'Criar Assinatura'

    fill_modal 'Pessoa', :with => 'Gabriel Sobrinho'
    fill_modal 'Cargo', :with => 'Gerente'
    select 'Gestor', :from => 'Tipo'
    fill_in 'Data inicial', :with => '01/01/2012'
    fill_in 'Data final', :with => '31/12/2012'

    click_button 'Salvar'

    expect(page).to have_notice 'Assinatura criada com sucesso.'

    click_link 'Gabriel Sobrinho'

    expect(page).to have_field 'Pessoa', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Cargo', :with => 'Gerente'
    expect(page).to have_select 'Tipo', :selected => 'Gestor'
    expect(page).to have_field 'Data inicial', :with => '01/01/2012'
    expect(page).to have_field 'Data final', :with => '31/12/2012'

    fill_modal 'Cargo', :with => 'Supervisor'
    fill_in 'Data inicial', :with => '02/01/2012'
    fill_in 'Data final', :with => '02/12/2012'

    click_button 'Salvar'

    expect(page).to have_notice 'Assinatura editada com sucesso.'

    click_link 'Gabriel Sobrinho'

    expect(page).to have_field 'Pessoa', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Cargo', :with => 'Supervisor'
    expect(page).to have_select 'Tipo', :selected => 'Gestor'
    expect(page).to have_field 'Data inicial', :with => '02/01/2012'
    expect(page).to have_field 'Data final', :with => '02/12/2012'

    click_link 'Apagar'

    expect(page).to have_notice 'Assinatura apagada com sucesso.'

    expect(page).to_not have_content 'Gabriel Sobrinho'
    expect(page).to_not have_content 'Supervisor'
  end

  scenario 'show error when already from other date range' do
    Signature.make!(:gerente_sobrinho)

    navigate 'Geral > Parâmetros > Assinaturas > Assinaturas'

    click_link 'Criar Assinatura'

    select 'Gestor', :from => 'Tipo'
    fill_in 'Data inicial', :with => '01/11/2011'
    fill_in 'Data final', :with => '01/01/2013'

    click_button 'Salvar'

    expect(page).to have_content 'Foram encontrados os seguintes erros no formulário: '
    expect(page).to have_content 'intervalo de data já está contida em outra assinatura'
  end

  scenario 'index with columns at the index' do
    Signature.make!(:gerente_sobrinho)

    navigate 'Geral > Parâmetros > Assinaturas > Assinaturas'

    within_records do
      expect(page).to have_content 'Pessoa'
      expect(page).to have_content 'Cargo'

      within 'tbody tr' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'Gerente'
      end
    end
  end
end
