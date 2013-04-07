# encoding: utf-8
require 'spec_helper'

feature "MaterialsClasses" do
  background do
    sign_in
  end

  scenario 'create a new materials_class' do
    navigate 'Comum > Cadastrais > Materiais > Classes de Materiais'

    click_link 'Criar Classe de Materiais'

    fill_with_autocomplete 'Classe superior', :with => 'Software'

    expect(page).to have_field 'Classe superior', :with => '01.32 - Software'

    within '.number-prepend' do
      expect(page).to have_content '01.32.'
    end

    fill_in 'Código', :with => '22'
    fill_in 'Descrição', :with => 'Materiais de Escritório'
    fill_in 'Detalhamento', :with => 'materiais para escritório'

    click_button 'Salvar'

    expect(page).to have_notice 'Classe de Materiais criada com sucesso.'

    click_link 'Materiais de Escritório'

    within '.number-prepend' do
      expect(page).to have_content '01.32.'
    end

    expect(page).to have_field 'Classe superior', :with => '01.32 - Software'
    expect(page).to have_field 'Código', :with => '22'
    expect(page).to have_field 'Descrição', :with => 'Materiais de Escritório'
    expect(page).to have_field 'Detalhamento', :with => 'materiais para escritório'
  end

  scenario 'update an existent materials_class' do
    navigate 'Comum > Cadastrais > Materiais > Classes de Materiais'

    click_link 'Componentes elétricos'

    fill_with_autocomplete 'Classe superior', :with => 'Arames'

    expect(page).to have_field 'Classe superior', :with => '02.44.65.430 - Arames'

    within '.number-prepend' do
      expect(page).to have_content '02.44.65.430.'
    end

    fill_in 'Código', :with => '234'
    fill_in 'Descrição', :with => 'Lampada'
    fill_in 'Detalhamento', :with => 'Lampadas para escritório'

    click_button 'Salvar'

    expect(page).to have_notice 'Classe de Materiais editada com sucesso.'

    click_link 'Lampada'

    within '.number-prepend' do
      expect(page).to have_content '02.44.65.430.'
    end

    expect(page).to have_field 'Classe superior', :with => '02.44.65.430 - Arames'
    expect(page).to have_field 'Código', :with => '234'
    expect(page).to have_field 'Descrição', :with => 'Lampada'
    expect(page).to have_field 'Detalhamento', :with => 'Lampadas para escritório'
  end

  scenario 'destroy an existent materials_class' do
    navigate 'Comum > Cadastrais > Materiais > Classes de Materiais'

    click_link 'Componentes elétricos'

    click_link 'Apagar'

    expect(page).to have_notice 'Classe de Materiais apagada com sucesso.'

    expect(page).to_not have_content 'Componentes elétricos'
    expect(page).to_not have_content '03053300000000'
  end

  scenario 'index with columns at the index' do
    navigate 'Comum > Cadastrais > Materiais > Classes de Materiais'

    within_records do
      expect(page).to have_content 'Descrição'
      expect(page).to have_content 'Código'

      within 'tbody tr' do
        expect(page).to have_content 'Arames'
        expect(page).to have_content '02.44'
      end
    end
  end

  scenario 'use the autocomplete to fill parent class by description or class_number' do
    navigate 'Comum > Cadastrais > Materiais > Classes de Materiais'

    click_link 'Criar Classe de Materiais'

    fill_with_autocomplete 'Classe superior', :with => 'Soft'

    expect(page).to have_field 'Classe superior', :with => '01.32 - Software'

    within '.number-prepend' do
      expect(page).to have_content '01.32.'
    end

    fill_with_autocomplete 'Classe superior', :with => 'Arames'

    expect(page).to have_field 'Classe superior', :with => '02.44.65.430 - Arames'

    within '.number-prepend' do
      expect(page).to have_content '02.44.65.430.'
    end

    fill_with_autocomplete 'Classe superior', :with => '01.'

    expect(page).to have_field 'Classe superior', :with => '01.32 - Software'

    within '.number-prepend' do
      expect(page).to have_content '01.32'
    end

    fill_with_autocomplete 'Classe superior', :with => '02.'

    expect(page).to have_field 'Classe superior', :with => '02.44.65.430 - Arames'

    within '.number-prepend' do
      expect(page).to have_content '02.44.65.430.'
    end
  end

  scenario 'cannot edit when material class is imported' do
    FactoryGirl.create(:materials_class, :masked_number => '01.32.15.000.000', :class_number => '013215000000', :imported => true)

    navigate 'Comum > Cadastrais > Materiais > Classes de Materiais'

    click_link 'Software'

    within '.number-prepend' do
      expect(page).to have_content '01.32.'
    end

    expect(page).to_not have_button 'Salvar'
    expect(page).to_not have_link 'Apagar'

    expect(page).to have_disabled_field 'Classe superior', :with => '01.32 - Software'
    expect(page).to have_disabled_field 'Código', :with => '15'
    expect(page).to have_disabled_field 'Descrição', :with => 'Software'
    expect(page).to have_disabled_field 'Detalhamento', :with => 'Softwares de computador'
  end

  scenario 'filter and modal can search class_number with dot' do
    navigate 'Comum > Cadastrais > Materiais > Classes de Materiais'

    click_link 'Filtrar Classes de Materiais'

    fill_in 'Código', :with => '013.20'

    click_button 'Pesquisar'

    within_records do
      expect(page).to have_content "Software"
      expect(page).to have_content "01.32"
    end
  end

  scenario 'update an existent materials_class when at first level' do
    FactoryGirl.create(:materials_class, :description => 'Segurança', :masked_number => '01.00.00.000.000')

    navigate 'Comum > Cadastrais > Materiais > Classes de Materiais'
    click_link 'Segurança'

    expect(page).to have_field 'Classe superior', :with => ''
    expect(page).to have_field 'Código', :with => '01'
  end

  scenario 'should has mask when has not a parent class number' do
    navigate 'Comum > Cadastrais > Materiais > Classes de Materiais'

    click_link 'Criar Classe de Materiais'

    fill_in 'Código', :with => '1234567'

    expect(page).to have_field 'Classe superior', :with => ''
    expect(page).to have_field 'Código', :with => '12'
  end

  scenario 'should keep data when form has errors' do
    navigate 'Comum > Cadastrais > Materiais > Classes de Materiais'

    click_link 'Criar Classe de Materiais'

    fill_with_autocomplete 'Classe superior', :with => 'Software'

    expect(page).to have_field 'Classe superior', :with => '01.32 - Software'

    within '.number-prepend' do
      expect(page).to have_content '01.32.'
    end

    fill_in 'Código', :with => '22'
    fill_in 'Detalhamento', :with => 'materiais para escritório'

    click_button 'Salvar'

    expect(page).to_not have_notice 'Classe de Materiais criada com sucesso.'

    within '.number-prepend' do
      expect(page).to have_content '01.32.'
    end

    expect(page).to have_field 'Classe superior', :with => '01.32 - Software'
    expect(page).to have_field 'Código', :with => '22'
    expect(page).to have_field 'Detalhamento', :with => 'materiais para escritório'

    fill_in 'Descrição', :with => 'Materiais de Escritório'

    click_button 'Salvar'

    expect(page).to have_notice 'Classe de Materiais criada com sucesso.'

    click_link 'Materiais de Escritório'

    within '.number-prepend' do
      expect(page).to have_content '01.32.'
    end

    expect(page).to have_field 'Classe superior', :with => '01.32 - Software'
    expect(page).to have_field 'Código', :with => '22'
    expect(page).to have_field 'Descrição', :with => 'Materiais de Escritório'
    expect(page).to have_field 'Detalhamento', :with => 'materiais para escritório'
  end

  scenario 'modal form at filter should have an autocomplete for class_number' do
    navigate 'Comum > Cadastrais > Materiais > Classes de Materiais'

    within_records do
      expect(page).to have_content 'Software'
      expect(page).to have_content 'Arame'
    end

    click_link 'Filtrar Classes de Materiais'

    fill_with_autocomplete 'Código', :with => 'Software'

    click_button 'Pesquisar'

    within_records do
      expect(page).to have_content 'Software'
      expect(page).to_not have_content 'Arame'
    end
  end
end
