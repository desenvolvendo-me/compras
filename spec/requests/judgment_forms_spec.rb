# encoding: utf-8
require 'spec_helper'

feature "JudgmentForms" do
  background do
    sign_in
  end

  scenario 'create a new judgment_form' do
    click_link 'Processos Administrativos'

    click_link 'Formas de Julgamento das Licitações'

    click_link 'Criar Forma de Julgamento de Licitação'

    fill_in 'Descrição', :with => 'Forma Global com Menor Preço'
    select 'Global', :from => 'Tipo de julgamento'
    select 'Menor preço', :from => 'Tipo de licitação'

    click_button 'Criar Forma de Julgamento de Licitação'

    page.should have_notice 'Forma de Julgamento de Licitação criado com sucesso.'

    click_link 'Forma Global com Menor Preço'

    page.should have_field 'Descrição', :with => 'Forma Global com Menor Preço'
    page.should have_select 'Tipo de julgamento', :selected => 'Global'
    page.should have_select 'Tipo de licitação', :selected => 'Menor preço'
  end

  scenario 'update an existent judgment_form' do
    JudgmentForm.make!(:global_com_menor_preco)

    click_link 'Processos Administrativos'

    click_link 'Formas de Julgamento das Licitações'

    click_link 'Forma Global com Menor Preço'

    fill_in 'Descrição', :with => 'Por item com melhor técnica'
    select 'Por item', :from => 'Tipo de julgamento'
    select 'Melhor técnica', :from => 'Tipo de licitação'

    click_button 'Atualizar Forma de Julgamento de Licitação'

    page.should have_notice 'Forma de Julgamento de Licitação editado com sucesso.'

    click_link 'Por item com melhor técnica'

    page.should have_field 'Descrição', :with => 'Por item com melhor técnica'
    page.should have_select 'Tipo de julgamento', :selected => 'Por item'
    page.should have_select 'Tipo de licitação', :selected => 'Melhor técnica'
  end

  scenario 'destroy an existent judgment_form' do
    JudgmentForm.make!(:global_com_menor_preco)

    click_link 'Processos Administrativos'

    click_link 'Formas de Julgamento das Licitações'

    click_link 'Forma Global com Menor Preço'

    click_link 'Apagar Forma Global com Menor Preço', :confirm => true

    page.should have_notice 'Forma de Julgamento de Licitação apagado com sucesso.'

    page.should_not have_field 'Descrição', :with => 'Forma Global com Menor Preço'
    page.should_not have_select 'Tipo de julgamento', :selected => 'Global'
    page.should_not have_select 'Tipo de licitação', :selected => 'Menor preço'
  end

  scenario 'should validate uniqueness of description' do
    JudgmentForm.make!(:global_com_menor_preco)

    click_link 'Processos Administrativos'

    click_link 'Formas de Julgamento das Licitações'

    click_link 'Criar Forma de Julgamento de Licitação'

    fill_in 'Descrição', :with => 'Forma Global com Menor Preço'

    click_button 'Criar Forma de Julgamento de Licitação'

    page.should have_content 'já está em uso'
  end
end
