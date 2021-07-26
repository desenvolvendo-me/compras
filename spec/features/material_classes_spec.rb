require 'spec_helper'

feature "MaterialClasses" do
  background do
    sign_in
  end

  scenario 'create, update and destroy an materials_class' do
    navigate 'Cadastro > Cadastrais > Materiais > Classes de Materiais'

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

    fill_in 'Código', :with => '23'
    fill_in 'Descrição', :with => 'Cooler de mesa'
    fill_in 'Detalhamento', :with => 'Cooler de mesa para resfriamento de notebook'

    click_button 'Salvar'

    expect(page).to have_notice 'Classe de Materiais editada com sucesso.'

    click_link 'Cooler de mesa'

    within '.number-prepend' do
      expect(page).to have_content '01.32'
    end

    expect(page).to have_field 'Classe superior', :with => '01.32 - Software'
    expect(page).to have_field 'Código', :with => '23'
    expect(page).to have_field 'Descrição', :with => 'Cooler de mesa'
    expect(page).to have_field 'Detalhamento', :with => 'Cooler de mesa para resfriamento de notebook'

    click_link 'Apagar'

    expect(page).to have_notice 'Classe de Materiais apagada com sucesso.'

    expect(page).to_not have_content 'Cooler de mesa'
    expect(page).to_not have_content '013223'
  end

  scenario 'index with columns at the index' do
    navigate 'Cadastro > Cadastrais > Materiais > Classes de Materiais'

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
    navigate 'Cadastro > Cadastrais > Materiais > Classes de Materiais'

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
    FactoryGirl.create(:material_class, :masked_number => '01.32.15.000.000', :class_number => '013215000000', :imported => true)

    navigate 'Cadastro > Cadastrais > Materiais > Classes de Materiais'

    click_link 'Software'

    within '.number-prepend' do
      expect(page).to have_content '01.32.'
    end

    expect(page).to_not have_button 'Salvar'
    expect(page).to_not have_link 'Apagar'

    expect(page).to have_field 'Classe superior', :with => '01.32 - Software', disabled: true
    expect(page).to have_field 'Código', :with => '15', disabled: true
    expect(page).to have_field 'Descrição', :with => 'Software', disabled: true
    expect(page).to have_field 'Detalhamento', :with => 'Softwares de computador', disabled: true
  end

  scenario 'filter and modal can search class_number with dot' do
    navigate 'Cadastro > Cadastrais > Materiais > Classes de Materiais'

    click_link 'Filtrar Classes de Materiais'

    fill_in 'Código', :with => '013.20'

    click_button 'Pesquisar'

    within_records do
      expect(page).to have_content "Software"
      expect(page).to have_content "01.32"
    end
  end

  scenario 'update an existent materials_class when at first level' do
    FactoryGirl.create(:material_class, :description => 'Segurança', :masked_number => '01.00.00.000.000')

    navigate 'Cadastro > Cadastrais > Materiais > Classes de Materiais'
    click_link 'Segurança'

    expect(page).to have_field 'Classe superior', :with => ''
    expect(page).to have_field 'Código', :with => '01'
  end

  scenario 'should has mask when has not a parent class number' do
    navigate 'Cadastro > Cadastrais > Materiais > Classes de Materiais'

    click_link 'Criar Classe de Materiais'

    fill_in 'Código', :with => '1234567'

    expect(page).to have_field 'Classe superior', :with => ''
    expect(page).to have_field 'Código', :with => '12'
  end

  scenario 'should keep data when form has errors' do
    navigate 'Cadastro > Cadastrais > Materiais > Classes de Materiais'

    click_link 'Criar Classe de Materiais'

    fill_with_autocomplete 'Classe superior', :with => 'Software'

    expect(page).to have_field 'Classe superior', :with => '01.32 - Software'

    within '.number-prepend' do
      expect(page).to have_content '01.32.'
    end

    fill_in 'Código', :with => '22'
    fill_in 'Detalhamento', :with => 'materiais para escritório'

    click_button 'Salvar'

    expect(page).to have_no_notice 'Classe de Materiais criada com sucesso.'

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
    navigate 'Cadastro > Cadastrais > Materiais > Classes de Materiais'

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
