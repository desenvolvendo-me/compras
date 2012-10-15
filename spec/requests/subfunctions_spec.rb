# encoding: utf-8
require 'spec_helper'

feature "Subfunctions" do
  background do
    sign_in
  end

  scenario 'create a new subfunction' do
    Function.make!(:administracao)
    Descriptor.make!(:detran_2012)

    navigate 'Outros > Contabilidade > Orçamento > Classificação Funcional > Subfunções'

    click_link 'Criar Subfunção'

    fill_modal 'Descritor', :with => '2012', :field => 'Exercício'
    fill_modal 'Função', :with => '04', :field => "Código"
    fill_in 'Código', :with => '01'
    fill_in 'Descrição', :with => 'Administração Geral'

    click_button 'Salvar'

    expect(page).to have_notice 'Subfunção criada com sucesso.'

    click_link '01'

    expect(page).to have_field 'Descritor', :with => '2012 - Detran'
    expect(page).to have_field 'Código', :with => '01'
    expect(page).to have_field 'Descrição', :with => 'Administração Geral'
    expect(page).to have_field 'Função', :with => '04 - Administração'
  end

  scenario 'update an existent subfunction' do
    Subfunction.make!(:geral)
    Function.make!(:execucao)
    Descriptor.make!(:secretaria_de_educacao_2011)

    navigate 'Outros > Contabilidade > Orçamento > Classificação Funcional > Subfunções'

    click_link '01'

    fill_modal 'Descritor', :with => '2011', :field => 'Exercício'
    fill_modal 'Função', :with => '05', :field => "Código"
    fill_in 'Código', :with => '02'
    fill_in 'Descrição', :with => 'Legislativa'

    click_button 'Salvar'

    expect(page).to have_notice 'Subfunção editada com sucesso.'

    click_link '02'

    expect(page).to have_field 'Descritor', :with => '2011 - Secretaria de Educação'
    expect(page).to have_field 'Código', :with => '02'
    expect(page).to have_field 'Descrição', :with => 'Legislativa'
    expect(page).to have_field 'Função', :with => '05 - Execução'
  end

  scenario 'destroy an existent subfunction' do
    Subfunction.make!(:geral)

    navigate 'Outros > Contabilidade > Orçamento > Classificação Funcional > Subfunções'

    click_link '01'

    click_link 'Apagar'

    expect(page).to have_notice 'Subfunção apagada com sucesso.'

    expect(page).to_not have_content '01'
    expect(page).to_not have_content 'Adminstração Geral'
  end

  scenario 'validate uniqueness of code' do
    Subfunction.make!(:geral)

    navigate 'Outros > Contabilidade > Orçamento > Classificação Funcional > Subfunções'

    click_link 'Criar Subfunção'

    fill_in 'Código', :with => '01'

    click_button 'Salvar'

    expect(page).to have_content 'já está em uso'
  end

  scenario 'validate uniqueness of description' do
    Subfunction.make!(:geral)

    navigate 'Outros > Contabilidade > Orçamento > Classificação Funcional > Subfunções'

    click_link 'Criar Subfunção'

    fill_in 'Descrição', :with => 'Administração Geral'

    click_button 'Salvar'

    expect(page).to have_content 'já está em uso'
  end
end
