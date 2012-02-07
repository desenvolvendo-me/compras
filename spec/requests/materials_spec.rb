# encoding: utf-8
require 'spec_helper'

feature "Materials" do
  background do
    sign_in
  end

  scenario 'create a new material' do
    make_dependencies!

    click_link 'Cadastros Diversos'

    click_link 'Materiais'

    click_link 'Criar Material'

    fill_modal 'Grupo', :with => 'Generos alimenticios', :field => 'Nome'
    fill_modal 'Classe', :with => 'Hortifrutigranjeiros', :field => 'Nome'
    fill_in 'Código', :with => '01'
    fill_in 'Nome', :with => 'Caixa'
    fill_in 'Descrição', :with => 'description'
    fill_in 'Estoque mínimo', :with => '10'
    fill_modal 'Unidade de medida', :with => 'Unidade', :field => 'Nome'
    fill_in 'Referência do fabricante', :with => 'manufacturer'
    check 'Material perecível'
    check 'Material estocável'

    # testing javascript
    select 'Material', :from => 'Característica'
    page.should_not have_field 'Tipo de serviço'

    select 'Serviço', :from => 'Característica'
    page.should_not have_field 'Tipo de material'
    #end of javascript test

    fill_modal 'Tipo de serviço', :with => 'Contratação de estagiários', :field => 'Descrição'
    fill_in 'Portaria STN', :with => 'stn_ordinance'
    fill_in 'Elemento de despesa', :with => 'expense_element'

    click_button 'Criar Material'

    page.should have_notice 'Material criado com sucesso.'

    click_link 'Caixa'

    page.should have_field 'Grupo', :with => '01 - Generos alimenticios'
    page.should have_field 'Classe', :with => '01 - Hortifrutigranjeiros'
    page.should have_field 'Código', :with => '01'
    page.should have_field 'Nome', :with => 'Caixa'
    page.should have_field 'Descrição', :with => 'description'
    page.should have_field 'Estoque mínimo', :with => '10'
    page.should have_field 'Unidade de medida', :with => 'Unidade'
    page.should have_field 'Referência do fabricante', :with => 'manufacturer'
    page.should have_checked_field 'Material perecível'
    page.should have_checked_field 'Material estocável'
    page.should_not have_checked_field 'Material combustível'
    page.should have_select 'Característica', :with => 'Material'
    page.should have_field 'Tipo de serviço', :with => 'Contratação de estagiários'
    page.should_not have_field 'Tipo de material'
    page.should have_field 'Portaria STN', :with => 'stn_ordinance'
    page.should have_field 'Elemento de despesa', :with => 'expense_element'
  end

  scenario 'update an existent material' do
    make_dependencies!

    Material.make!(:manga)
    ReferenceUnit.make!(:metro)
    MaterialsGroup.make!(:limpeza)
    MaterialsClass.make!(:pecas)

    click_link 'Cadastros Diversos'

    click_link 'Materiais'

    click_link 'Manga'

    fill_modal 'Grupo', :with => 'Limpeza', :field => 'Nome'
    fill_modal 'Classe', :with => 'Peças', :field => 'Nome'
    fill_in 'Nome', :with => 'Parafuso'
    fill_in 'Descrição', :with => 'de rosca'
    fill_in 'Estoque mínimo', :with => '20'
    fill_modal 'Unidade de medida', :with => 'Metro', :field => 'Nome'
    fill_in 'Referência do fabricante', :with => 'outro fabricante'
    uncheck 'Material perecível'
    uncheck 'Material estocável'
    check 'Material combustível'
    select 'Material', :from => 'Característica'

    # testing javascript
    page.should_not have_field 'Tipo de serviço'
    # end of javascript test

    select 'De consumo', :from => 'Tipo de material'
    fill_in 'Portaria STN', :with => 'outro'
    fill_in 'Elemento de despesa', :with => 'outro elemento'

    click_button 'Atualizar Material'

    page.should have_notice 'Material editado com sucesso.'

    click_link 'Parafuso'

    page.should have_field 'Grupo', :with => '02 - Limpeza'
    page.should have_field 'Classe', :with => '02 - Peças'
    page.should have_field 'Nome', :with => 'Parafuso'
    page.should have_field 'Descrição', :with => 'de rosca'
    page.should have_field 'Estoque mínimo', :with => '20'
    page.should have_field 'Unidade de medida', :with => 'Metro'
    page.should have_field 'Referência do fabricante', :with => 'outro fabricante'
    page.should_not have_checked_field 'Material perecível'
    page.should_not have_checked_field 'Material estocável'
    page.should have_checked_field 'Material combustível'
    page.should have_select 'Característica', :with => 'Serviço'
    page.should_not have_field 'Tipo de serviço'
    page.should have_select 'Tipo de material', :with => 'De consumo'
    page.should have_field 'Portaria STN', :with => 'outro'
    page.should have_field 'Elemento de despesa', :with => 'outro elemento'
  end

  scenario 'destroy an existent material' do
    Material.make!(:manga)
    click_link 'Cadastros Diversos'

    click_link 'Materiais'

    click_link 'Manga'

    click_link 'Apagar 01 - Manga', :confirm => true

    page.should have_notice 'Material apagado com sucesso.'

    page.should_not have_content 'Manga'
  end

  scenario 'should validate uniqueness of code' do
    Material.make!(:manga)

    click_link 'Cadastros Diversos'

    click_link 'Materiais'

    click_link 'Criar Material'

    fill_in 'Código', :with => '01'

    click_button 'Criar Material'

    page.should have_content 'já está em uso'
  end

  scenario 'should validate uniqueness of name' do
    Material.make!(:manga)

    click_link 'Cadastros Diversos'

    click_link 'Materiais'

    click_link 'Criar Material'

    fill_in 'Nome', :with => 'Manga'

    click_button 'Criar Material'

    page.should have_content 'já está em uso'
  end

  scenario 'should clean the unnecessary type of material or service depending on characteristic' do
    Material.make!(:manga)

    click_link 'Cadastros Diversos'

    click_link 'Materiais'

    click_link 'Manga'

    select 'Material', :from => "Característica"

    select 'De consumo', :from => 'Tipo de material'

    click_button 'Atualizar Material'

    click_link 'Manga'

    select 'Serviço', :from => "Característica"

    page.should have_field 'Tipo de serviço', :with => ''

    fill_modal 'Tipo de serviço', :with => 'Reparos', :field => 'Descrição'

    click_button 'Atualizar Material'

    click_link 'Manga'

    select 'Material', :from => "Característica"

    page.should have_select 'Tipo de material', :with => ''
  end

  it 'should show selected group on class modal' do
    make_dependencies!

    click_link 'Cadastros Diversos'

    click_link 'Materiais'

    click_link 'Criar Material'

    page.should have_disabled_field 'Classe'

    fill_modal 'Grupo', :with => 'Generos alimenticios', :field => 'Nome'

    page.should_not have_disabled_field 'Classe'

    fill_modal 'Classe', :with => 'Hortifrutigranjeiros' do
      page.should have_field 'filter_materials_group', :with => '01 - Generos alimenticios'
    end
  end

  it 'should not have the class disabled when editing material' do
    make_dependencies!

    Material.make!(:manga)

    click_link 'Cadastros Diversos'

    click_link 'Materiais'

    click_link 'Manga'

    page.should_not have_disabled_field 'Classe'
  end

  it 'should disable and empty class when group are removed' do
    make_dependencies!

    click_link 'Cadastros Diversos'

    click_link 'Materiais'

    click_link 'Criar Material'

    fill_modal 'Grupo', :with => 'Generos alimenticios', :field => 'Nome'

    fill_modal 'Classe', :with => 'Hortifrutigranjeiros'

    fill_in 'Grupo', :with => ''

    page.should have_disabled_field 'Classe', :with => ''
  end

  def make_dependencies!
    MaterialsGroup.make!(:alimenticios)
    MaterialsClass.make!(:hortifrutigranjeiros)
    ReferenceUnit.make!(:unidade)
    ServiceOrContractType.make!(:trainees)
  end
end
