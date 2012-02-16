# encoding: utf-8
require 'spec_helper'

feature "Subfunctions" do
  background do
    sign_in
  end

  scenario 'create a new subfunction' do
    Function.make!(:administracao)

    click_link 'Contabilidade'

    click_link 'Subfunções'

    click_link 'Criar Subfunção'

    fill_modal 'Função', :with => '04', :field => "Código"
    fill_in 'Código', :with => '01'
    fill_in 'Descrição', :with => 'Administração Geral'

    click_button 'Criar Subfunção'

    page.should have_notice 'Subfunção criada com sucesso.'

    click_link '01'

    page.should have_field 'Código', :with => '01'
    page.should have_field 'Descrição', :with => 'Administração Geral'
    page.should have_field 'Função', :with => '04 - Administração'
  end

  scenario 'update an existent subfunction' do
    Subfunction.make!(:geral)
    Function.make!(:execucao)

    click_link 'Contabilidade'

    click_link 'Subfunções'

    click_link '01'

    fill_modal 'Função', :with => '05', :field => "Código"
    fill_in 'Código', :with => '02'
    fill_in 'Descrição', :with => 'Legislativa'

    click_button 'Atualizar Subfunção'

    page.should have_notice 'Subfunção editada com sucesso.'

    click_link '02'

    page.should have_field 'Código', :with => '02'
    page.should have_field 'Descrição', :with => 'Legislativa'
    page.should have_field 'Função', :with => '05 - Execução'
  end

  scenario 'destroy an existent subfunction' do
    Subfunction.make!(:geral)

    click_link 'Contabilidade'

    click_link 'Subfunções'

    click_link '01'

    click_link 'Apagar 01 - Administração Geral', :confirm => true

    page.should have_notice 'Subfunção apagada com sucesso.'

    page.should_not have_content '01'
    page.should_not have_content 'Adminstração Geral'
  end

  scenario 'validate uniqueness of code' do
    Subfunction.make!(:geral)

    click_link 'Contabilidade'

    click_link 'Subfunções'

    click_link 'Criar Subfunção'

    fill_in 'Código', :with => '01'

    click_button 'Criar Subfunção'

    page.should have_content 'já está em uso'
  end
end
