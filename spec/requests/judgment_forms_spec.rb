# encoding: utf-8
require 'spec_helper'

feature "JudgmentForms" do
  background do
    sign_in
  end

  scenario 'cannot create a new judgment_form' do
    navigate 'Processo Administrativo/Licitatório > Auxiliar > Formas de Julgamento das Licitações'

    expect(page).to_not have_link 'Criar Forma de Julgamento de Licitação'
  end

  scenario 'update an existent judgment_form' do
    JudgmentForm.make!(:global_com_menor_preco)

    navigate 'Processo Administrativo/Licitatório > Auxiliar > Formas de Julgamento das Licitações'

    click_link 'Forma Global com Menor Preço'

    expect(page).to_not have_link 'Apagar'

    fill_in 'Descrição', :with => 'Por item com melhor técnica'
    select 'Por item', :from => 'Tipo de julgamento'
    select 'Melhor técnica', :from => 'Tipo de licitação'

    click_button 'Salvar'

    expect(page).to have_notice 'Forma de Julgamento de Licitação editada com sucesso.'

    click_link 'Por item com melhor técnica'

    expect(page).to have_field 'Descrição', :with => 'Por item com melhor técnica'
    expect(page).to have_select 'Tipo de julgamento', :selected => 'Por item'
    expect(page).to have_select 'Tipo de licitação', :selected => 'Melhor técnica'
  end
end
