# encoding: utf-8
require 'spec_helper'

feature "JudgmentForms" do
  background do
    sign_in
  end

  scenario 'create a new judgment_form' do
    navigate 'Compras e Licitações > Cadastros Gerais > Formas de Julgamento das Licitações'

    click_link 'Criar Forma de Julgamento de Licitação'

    fill_in 'Descrição', :with => 'Forma Global com Menor Preço'
    select 'Global', :from => 'Tipo de julgamento'
    select 'Menor preço', :from => 'Tipo de licitação'

    click_button 'Salvar'

    expect(page).to have_notice 'Forma de Julgamento de Licitação criado com sucesso.'

    click_link 'Forma Global com Menor Preço'

    expect(page).to have_field 'Descrição', :with => 'Forma Global com Menor Preço'
    expect(page).to have_select 'Tipo de julgamento', :selected => 'Global'
    expect(page).to have_select 'Tipo de licitação', :selected => 'Menor preço'
  end

  scenario 'update an existent judgment_form' do
    JudgmentForm.make!(:global_com_menor_preco)

    navigate 'Compras e Licitações > Cadastros Gerais > Formas de Julgamento das Licitações'

    click_link 'Forma Global com Menor Preço'

    fill_in 'Descrição', :with => 'Por item com melhor técnica'
    select 'Por item', :from => 'Tipo de julgamento'
    select 'Melhor técnica', :from => 'Tipo de licitação'

    click_button 'Salvar'

    expect(page).to have_notice 'Forma de Julgamento de Licitação editado com sucesso.'

    click_link 'Por item com melhor técnica'

    expect(page).to have_field 'Descrição', :with => 'Por item com melhor técnica'
    expect(page).to have_select 'Tipo de julgamento', :selected => 'Por item'
    expect(page).to have_select 'Tipo de licitação', :selected => 'Melhor técnica'
  end

  scenario 'destroy an existent judgment_form' do
    JudgmentForm.make!(:global_com_menor_preco)

    navigate 'Compras e Licitações > Cadastros Gerais > Formas de Julgamento das Licitações'

    click_link 'Forma Global com Menor Preço'

    click_link 'Apagar'

    expect(page).to have_notice 'Forma de Julgamento de Licitação apagado com sucesso.'

    expect(page).to_not have_content 'Forma Global com Menor Preço'
    expect(page).to_not have_content 'Global'
    expect(page).to_not have_content 'Menor preço'
  end

  scenario 'should validate uniqueness of description' do
    JudgmentForm.make!(:global_com_menor_preco)

    navigate 'Compras e Licitações > Cadastros Gerais > Formas de Julgamento das Licitações'

    click_link 'Criar Forma de Julgamento de Licitação'

    fill_in 'Descrição', :with => 'Forma Global com Menor Preço'

    click_button 'Salvar'

    expect(page).to have_content 'já está em uso'
  end
end
