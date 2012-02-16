# encoding: utf-8
require 'spec_helper'

feature "CommitmentTypes" do
  background do
    sign_in
  end

  scenario 'create a new commitment_type' do
    click_link 'Contabilidade'

    click_link 'Tipos de Empenho'

    click_link 'Criar Tipo de Empenho'

    fill_in 'Código', :with => '66'
    fill_in 'Descrição', :with => 'Tipo 01'

    click_button 'Criar Tipo de Empenho'

    page.should have_notice 'Tipo de Empenho criado com sucesso.'

    click_link '66'

    page.should have_field 'Código', :with => '66'
    page.should have_field 'Descrição', :with => 'Tipo 01'
  end

  scenario 'update an existent commitment_type' do
    CommitmentType.make!(:primeiro_empenho)

    click_link 'Contabilidade'

    click_link 'Tipos de Empenho'

    click_link '123'

    fill_in 'Código', :with => '321'
    fill_in 'Descrição', :with => 'Outro Tipo de Empenho'

    click_button 'Atualizar Tipo de Empenho'

    page.should have_notice 'Tipo de Empenho editado com sucesso.'

    click_link '321'

    page.should have_field 'Código', :with => '321'
    page.should have_field 'Descrição', :with => 'Outro Tipo de Empenho'
  end

  scenario 'validate uniqueness of code' do
    CommitmentType.make!(:primeiro_empenho)

    click_link 'Contabilidade'

    click_link 'Tipos de Empenho'

    click_link 'Criar Tipo de Empenho'

    fill_in 'Código', :with => '123'

    click_button 'Criar Tipo de Empenho'

    page.should have_content 'já está em uso'
  end

  scenario 'destroy an existent commitment_type' do
    CommitmentType.make!(:primeiro_empenho)

    click_link 'Contabilidade'

    click_link 'Tipos de Empenho'

    click_link '123'

    click_link 'Apagar 123 - Empenho 01', :confirm => true

    page.should have_notice 'Tipo de Empenho apagado com sucesso.'

    page.should_not have_content '123'
    page.should_not have_content 'Empenho 01'
  end
end
