# encoding: utf-8
require 'spec_helper'

feature "MaterialsClasses" do
  background do
    sign_in
  end

  scenario 'create a new materials_class' do
    MaterialsClass.make!(:software)
    MaterialsClass.make!(:arames)

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
    MaterialsClass.make!(:comp_eletricos)
    MaterialsClass.make!(:arames)

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
    MaterialsClass.make!(:comp_eletricos)

    navigate 'Comum > Cadastrais > Materiais > Classes de Materiais'

    click_link 'Componentes elétricos'

    click_link 'Apagar'

    expect(page).to have_notice 'Classe de Materiais apagada com sucesso.'

    expect(page).to_not have_content 'Componentes elétricos'
    expect(page).to_not have_content '03053300000000'
  end

  scenario 'index with columns at the index' do
    MaterialsClass.make!(:software)

    navigate 'Comum > Cadastrais > Materiais > Classes de Materiais'

    within_records do
      expect(page).to have_content 'Descrição'
      expect(page).to have_content 'Código'

      within 'tbody tr' do
        expect(page).to have_content 'Software'
        expect(page).to have_content '01.32.00.000.000'
      end
    end
  end

  scenario 'use the autocomplete to fill parent class by description or class_number' do
    MaterialsClass.make!(:software)
    MaterialsClass.make!(:arames)

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

    fill_with_autocomplete 'Classe superior', :with => '01'

    expect(page).to have_field 'Classe superior', :with => '01.32 - Software'

    within '.number-prepend' do
      expect(page).to have_content '01.32'
    end

    fill_with_autocomplete 'Classe superior', :with => '02'

    expect(page).to have_field 'Classe superior', :with => '02.44.65.430 - Arames'

    within '.number-prepend' do
      expect(page).to have_content '02.44.65.430.'
    end
  end

  scenario 'cannot edit when material class is imported' do
    MaterialsClass.make!(:software, :imported => true)
    MaterialsClass.make!(:software,
      :masked_number => '01.00.00.000.000',
      :description => 'Teste'
      :imported => true
    )

    navigate 'Comum > Cadastrais > Materiais > Classes de Materiais'

    click_link 'Software'

    within '.number-prepend' do
      expect(page).to have_content '01.'
    end

    expect(page).to_not have_button 'Salvar'
    expect(page).to_not have_link 'Apagar'

    expect(page).to have_disabled_field 'Classe superior', :with => '01 - Teste'
    expect(page).to have_disabled_field 'Código', :with => '32'
    expect(page).to have_disabled_field 'Descrição', :with => 'Software'
    expect(page).to have_disabled_field 'Detalhamento', :with => 'Softwares de computador'
  end

  scenario 'filter and modal can search class_number with dot' do
    MaterialsClass.make!(:software)

    navigate 'Comum > Cadastrais > Materiais > Classes de Materiais'

    click_link 'Filtrar Classes de Materiais'

    fill_in 'Código', :with => '013.20'

    click_button 'Pesquisar'

    expect(page).to have_content "Software"
    expect(page).to have_content "01.32.00.000.000"
  end

  scenario 'update an existent materials_class when at first level' do
    MaterialsClass.make!(:software, :masked_number => '12.00.00.000.000')

    navigate 'Comum > Cadastrais > Materiais > Classes de Materiais'

    click_link 'Software'

    expect(page).to have_field 'Classe superior', :with => ''
    expect(page).to have_field 'Código', :with => '12'
  end

  scenario 'should keep data when form has errors' do
    MaterialsClass.make!(:software)

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
end
