# encoding: utf-8
require 'spec_helper'

feature "MaterialsClasses" do
  background do
    sign_in
  end

  scenario 'create a new materials_class' do
    navigate 'Comum > Cadastrais > Materiais > Classes de Materiais'

    click_link 'Criar Classe de Materiais'

    fill_in 'Código', :with => '01'
    fill_in 'Descrição', :with => 'Materiais de Escritório'
    fill_in 'Detalhamento', :with => 'materiais para escritório'

    click_button 'Salvar'

    expect(page).to have_notice 'Classe de Materiais criada com sucesso.'

    click_link 'Materiais de Escritório'

    expect(page).to have_field 'Código', :with => '01'
    expect(page).to have_field 'Descrição', :with => 'Materiais de Escritório'
    expect(page).to have_field 'Detalhamento', :with => 'materiais para escritório'
  end

  scenario 'update an existent materials_class' do
    MaterialsClass.make!(:software)

    navigate 'Comum > Cadastrais > Materiais > Classes de Materiais'

    click_link 'Software'

    fill_in 'Código', :with => '02'
    fill_in 'Descrição', :with => 'Lampada'
    fill_in 'Detalhamento', :with => 'descricao'

    click_button 'Salvar'

    expect(page).to have_notice 'Classe de Materiais editada com sucesso.'

    click_link 'Lampada'

    expect(page).to have_field 'Código', :with => '02'
    expect(page).to have_field 'Descrição', :with => 'Lampada'
    expect(page).to have_field 'Detalhamento', :with => 'descricao'
  end

  scenario 'destroy an existent materials_class' do
    MaterialsClass.make!(:software)

    navigate 'Comum > Cadastrais > Materiais > Classes de Materiais'

    click_link 'Software'

    click_link 'Apagar'

    expect(page).to have_notice 'Classe de Materiais apagada com sucesso.'

    expect(page).to_not have_content '01 - Informática'
    expect(page).to_not have_content 'Software'
    expect(page).to_not have_content 'Softwares de computador'
  end

  scenario 'index with columns at the index' do
    MaterialsClass.make!(:software)

    navigate 'Comum > Cadastrais > Materiais > Classes de Materiais'

    within_records do
      expect(page).to have_content 'Descrição'
      expect(page).to have_content 'Código'

      within 'tbody tr' do
        expect(page).to have_content 'Software'
        expect(page).to have_content '01'
      end
    end
  end
end
