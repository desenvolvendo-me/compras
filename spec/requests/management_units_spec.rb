# encoding: utf-8
require 'spec_helper'

feature "ManagementUnits" do
  background do
    sign_in
  end

  scenario 'create a new management_unit' do
    click_link 'Contabilidade'

    click_link 'Unidades Gestoras'

    click_link 'Criar Unidade Gestora'

    fill_in 'Descrição', :with => 'Unidade Central'
    fill_in 'Sigla', :with => 'UGC'
    select 'Ativo', :from => 'Status'

    click_button 'Criar Unidade Gestora'

    page.should have_notice 'Unidade Gestora criada com sucesso.'

    click_link 'Unidade Central'

    page.should have_field 'Descrição', :with => 'Unidade Central'
    page.should have_field 'Sigla', :with => 'UGC'
    page.should have_select 'Status', :selected => 'Ativo'
  end

  scenario 'update an existent management_unit' do
    ManagementUnit.make!(:unidade_central)

    click_link 'Contabilidade'

    click_link 'Unidades Gestoras'

    click_link 'Unidade Central'

    fill_in 'Descrição', :with => 'Unidade Auxiliar'
    fill_in 'Sigla', :with => 'UGA'
    select 'Desativado', :from => 'Status'

    click_button 'Atualizar Unidade Gestora'

    page.should have_notice 'Unidade Gestora editada com sucesso.'

    click_link 'Unidade Auxiliar'

    page.should have_field 'Descrição', :with => 'Unidade Auxiliar'
    page.should have_field 'Sigla', :with => 'UGA'
    page.should have_select 'Status', :selected => 'Desativado'
  end

  scenario 'destroy an existent management_unit' do
    ManagementUnit.make!(:unidade_central)
    click_link 'Contabilidade'

    click_link 'Unidades Gestoras'

    click_link 'Unidade Central'

    click_link 'Apagar Unidade Central', :confirm => true

    page.should have_notice 'Unidade Gestora apagada com sucesso.'

    page.should_not have_content 'Unidade Central'
    page.should_not have_content 'UGC'
    page.should_not have_content 'Ativo'
  end
end
