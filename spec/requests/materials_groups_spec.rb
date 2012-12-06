# encoding: utf-8
require 'spec_helper'

feature "MaterialsGroups" do
  background do
    sign_in
  end

  scenario 'create a new materials_group' do
    navigate 'Comum > Cadastrais > Materiais > Grupos de Materiais'

    click_link 'Criar Grupo de Materiais'

    fill_in 'Código', :with => '01'
    fill_in 'Descrição', :with => 'Informática'

    click_button 'Salvar'

    expect(page).to have_notice 'Grupo de Materiais criado com sucesso.'

    click_link 'Informática'

    expect(page).to have_field 'Código', :with => '01'
    expect(page).to have_field 'Descrição', :with => 'Informática'
  end

  scenario 'update an existent materials_group' do
    MaterialsGroup.make!(:informatica)

    navigate 'Comum > Cadastrais > Materiais > Grupos de Materiais'

    click_link 'Informática'

    fill_in 'Código', :with => '02'
    fill_in 'Descrição', :with => 'Materiais de escritorio'

    click_button 'Salvar'

    expect(page).to have_notice 'Grupo de Materiais editado com sucesso.'

    click_link 'Materiais de escritorio'

    expect(page).to have_field 'Código', :with => '02'
    expect(page).to have_field 'Descrição', :with => 'Materiais de escritorio'
  end

  scenario 'destroy an existent materials_group' do
    MaterialsGroup.make!(:informatica)

    navigate 'Comum > Cadastrais > Materiais > Grupos de Materiais'

    click_link 'Informática'

    click_link 'Apagar'

    expect(page).to have_notice 'Grupo de Materiais apagado com sucesso.'

    expect(page).to_not have_content '01'
    expect(page).to_not have_content 'Informática'
  end

  scenario 'index with columns at the index' do
    MaterialsGroup.make!(:informatica)

    navigate 'Comum > Cadastrais > Materiais > Grupos de Materiais'

    within_records do
      expect(page).to have_content 'Descrição'
      expect(page).to have_content 'Código'

      within 'tbody tr' do
        expect(page).to have_content 'Informática'
        expect(page).to have_content '01'
      end
    end
  end
end
