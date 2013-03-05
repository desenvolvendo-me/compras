# encoding: utf-8
require 'spec_helper'

feature "ContractType" do
  background do
    sign_in
  end

  scenario 'create a new service' do
    navigate 'Comum > Tipos de Contrato'

    click_link 'Criar Tipo de Contrato'

    fill_in 'Código do TCE', :with => '123'
    fill_in 'Descrição', :with => 'Contratação de estagiários'
    select 'Estagiário', :from => 'Finalidade'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo de Contrato criado com sucesso.'

    click_link 'Contratação de estagiários'

    expect(page).to have_field 'Código do TCE', :with => '123'
    expect(page).to have_field 'Descrição', :with => 'Contratação de estagiários'
    expect(page).to have_select 'Finalidade', :selected => 'Estagiário'
  end

  scenario 'update an existent service' do
    ContractType.make!(:trainees)

    navigate 'Comum > Tipos de Contrato'

    click_link 'Contratação de estagiários'

    fill_in 'Descrição', :with => 'Contratação de 10 estagiários'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo de Contrato editado com sucesso.'

    click_link 'Contratação de 10 estagiários'

    expect(page).to have_field 'Código do TCE', :with => '123'
    expect(page).to have_field 'Descrição', :with => 'Contratação de 10 estagiários'
    expect(page).to have_select 'Finalidade', :selected => 'Estagiário'
  end

  scenario 'destroy an existent service' do
    ContractType.make!(:trainees)

    navigate 'Comum > Tipos de Contrato'

    click_link 'Contratação de estagiários'

    click_link 'Apagar'

    expect(page).to have_notice 'Tipo de Contrato apagado com sucesso.'

    expect(page).to_not have_content '123'
    expect(page).to_not have_content 'Contratação de estagiários'
    expect(page).to_not have_content 'Estagiário'
  end

  scenario 'index with columns at the index' do
    ContractType.make!(:trainees)

    navigate 'Comum > Tipos de Contrato'

    within_records do
      expect(page).to have_content 'Descrição'

      within 'tbody tr' do
        expect(page).to have_content 'Contratação de estagiários'
      end
    end
  end
end
