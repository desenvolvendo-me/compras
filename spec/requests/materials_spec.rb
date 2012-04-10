# encoding: utf-8
require 'spec_helper'

feature "Materials" do
  background do
    sign_in
  end

  scenario 'create a new material' do
    make_dependencies!

    click_link 'Solicitações'

    click_link 'Materiais'

    click_link 'Criar Material'

    page.should have_disabled_field 'Tipo de material'
    page.should have_disabled_field 'Tipo de serviço'

    fill_modal 'Grupo', :with => 'Informática', :field => 'Descrição'
    fill_modal 'Classe', :with => 'Software', :field => 'Descrição'
    fill_in 'Descrição', :with => 'Caixa'
    fill_in 'Descrição detalhada', :with => 'Uma caixa'
    fill_in 'Estoque mínimo', :with => '10'
    fill_modal 'Unidade de medida', :with => 'Unidade', :field => 'Descrição'
    fill_in 'Referência do fabricante', :with => 'manufacturer'
    check 'Material perecível'
    check 'Material estocável'

    # testing javascript
    select 'Material', :from => 'Característica'
    page.should have_disabled_field 'Tipo de serviço'

    select 'Serviço', :from => 'Característica'
    page.should have_disabled_field 'Tipo de material'
    #end of javascript test

    fill_modal 'Tipo de serviço', :with => 'Contratação de estagiários', :field => 'Descrição'
    fill_modal 'Natureza de despesa', :with => '3.1.90.11.01.00.00.00', :field => 'Classificação da natureza da despesa'

    click_button 'Criar Material'

    page.should have_notice 'Material criado com sucesso.'

    click_link 'Caixa'

    page.should have_field 'Grupo', :with => '01 - Informática'
    page.should have_field 'Classe', :with => '01 - Software'
    page.should have_field 'Descrição', :with => 'Caixa'
    page.should have_field 'Descrição detalhada', :with => 'Uma caixa'
    page.should have_field 'Estoque mínimo', :with => '10'
    page.should have_field 'Unidade de medida', :with => 'Unidade'
    page.should have_field 'Referência do fabricante', :with => 'manufacturer'
    page.should have_checked_field 'Material perecível'
    page.should have_checked_field 'Material estocável'
    page.should_not have_checked_field 'Material combustível'
    page.should have_select 'Característica', :selected => 'Serviço'
    page.should have_field 'Tipo de serviço', :with => 'Contratação de estagiários'
    page.should have_disabled_field 'Tipo de material'
    page.should have_field 'Natureza de despesa', :with => '3.1.90.11.01.00.00.00'
  end

  scenario 'generate code' do
    make_dependencies!

    click_link 'Solicitações'

    click_link 'Materiais'

    click_link 'Criar Material'

    fill_modal 'Grupo', :with => 'Informática', :field => 'Descrição'
    fill_modal 'Classe', :with => 'Software', :field => 'Descrição'
    fill_in 'Descrição', :with => 'Caixa'
    fill_in 'Descrição detalhada', :with => 'Outra descrição'
    fill_in 'Estoque mínimo', :with => '10'
    fill_modal 'Unidade de medida', :with => 'Unidade', :field => 'Descrição'
    fill_in 'Referência do fabricante', :with => 'manufacturer'
    check 'Material perecível'
    check 'Material estocável'

    select 'Serviço', :from => 'Característica'

    fill_modal 'Tipo de serviço', :with => 'Contratação de estagiários', :field => 'Descrição'
    fill_modal 'Natureza de despesa', :with => '3.1.90.11.01.00.00.00', :field => 'Classificação da natureza da despesa'

    click_button 'Criar Material'

    page.should have_notice 'Material criado com sucesso.'

    page.should have_content '01.01.00001'
  end

  scenario 'update an existent material' do
    make_dependencies!

    # Ensure the update of code
    # begin (do not change this order)
    Material.make!(:arame_comum)
    Material.make!(:antivirus)
    Material.make!(:arame_farpado)
    # end

    ReferenceUnit.make!(:metro)
    MaterialsGroup.make!(:ferro_aco)
    MaterialsClass.make!(:arames)
    ExpenseNature.make!(:compra_de_material)

    click_link 'Solicitações'

    click_link 'Materiais'

    click_link 'Antivirus'

    fill_modal 'Grupo', :with => 'Ferro e Aço', :field => 'Descrição'
    fill_modal 'Classe', :with => 'Arames', :field => 'Descrição'
    fill_in 'Descrição', :with => 'Parafuso'
    fill_in 'Descrição detalhada', :with => 'de rosca'
    fill_in 'Estoque mínimo', :with => '20'
    fill_modal 'Unidade de medida', :with => 'Metro', :field => 'Descrição'
    fill_in 'Referência do fabricante', :with => 'outro fabricante'
    uncheck 'Material perecível'
    uncheck 'Material estocável'
    check 'Material combustível'
    select 'Material', :from => 'Característica'

    # testing javascript
    page.should have_disabled_field 'Tipo de serviço'
    # end of javascript test

    select 'De consumo', :from => 'Tipo de material'
    fill_modal 'Natureza de despesa', :with => '2.2.22.11.01.00.00.00', :field => 'Classificação da natureza da despesa'

    click_button 'Atualizar Material'

    page.should have_notice 'Material editado com sucesso.'

    click_link 'Parafuso'

    page.should have_field 'Grupo', :with => '02 - Ferro e Aço'
    page.should have_field 'Classe', :with => '02 - Arames'
    page.should have_field 'Código', :with => '02.02.00003'
    page.should have_field 'Descrição', :with => 'Parafuso'
    page.should have_field 'Descrição detalhada', :with => 'de rosca'
    page.should have_field 'Estoque mínimo', :with => '20'
    page.should have_field 'Unidade de medida', :with => 'Metro', :field => 'Descrição'
    page.should have_field 'Referência do fabricante', :with => 'outro fabricante'
    page.should_not have_checked_field 'Material perecível'
    page.should_not have_checked_field 'Material estocável'
    page.should have_checked_field 'Material combustível'
    page.should have_select 'Característica', :selected => 'Material'
    page.should have_disabled_field 'Tipo de serviço'
    page.should have_select 'Tipo de material', :selected => 'De consumo'
    page.should have_field 'Natureza de despesa', :with => '2.2.22.11.01.00.00.00'
  end

  scenario 'destroy an existent material' do
    Material.make!(:antivirus)

    click_link 'Solicitações'

    click_link 'Materiais'

    click_link 'Antivirus'

    click_link 'Apagar 01.01.00001 - Antivirus', :confirm => true

    page.should have_notice 'Material apagado com sucesso.'

    page.should_not have_content 'Antivirus'
  end

  scenario 'should validate uniqueness of name' do
    Material.make!(:antivirus)

    click_link 'Solicitações'

    click_link 'Materiais'

    click_link 'Criar Material'

    fill_in 'Descrição', :with => 'Antivirus'

    click_button 'Criar Material'

    page.should have_content 'já está em uso'
  end

  scenario 'should clean the unnecessary type of material or service depending on characteristic' do
    Material.make!(:antivirus)

    click_link 'Solicitações'

    click_link 'Materiais'

    click_link 'Antivirus'

    select 'Material', :from => "Característica"

    select 'De consumo', :from => 'Tipo de material'

    click_button 'Atualizar Material'

    click_link 'Antivirus'

    select 'Serviço', :from => "Característica"

    page.should have_field 'Tipo de serviço', :with => ''

    fill_modal 'Tipo de serviço', :with => 'Reparos', :field => 'Descrição'

    click_button 'Atualizar Material'

    click_link 'Antivirus'

    select 'Material', :from => "Característica"

    page.should have_select 'Tipo de material', :selected => ''
  end

  it 'should show selected group on class modal' do
    make_dependencies!

    click_link 'Solicitações'

    click_link 'Materiais'

    click_link 'Criar Material'

    page.should have_disabled_field 'Classe'

    fill_modal 'Grupo', :with => 'Informática', :field => 'Descrição'

    page.should_not have_disabled_field 'Classe'

    fill_modal 'Classe', :with => 'Software', :field => 'Descrição' do
      page.should have_field 'filter_materials_group', :with => '01 - Informática'
    end
  end

  it 'should not have the class disabled when editing material' do
    make_dependencies!

    Material.make!(:antivirus)

    click_link 'Solicitações'

    click_link 'Materiais'

    click_link 'Antivirus'

    page.should_not have_disabled_field 'Classe'
  end

  it 'should disable and empty the class when the group is removed' do
    make_dependencies!

    click_link 'Solicitações'

    click_link 'Materiais'

    click_link 'Criar Material'

    fill_modal 'Grupo', :with => 'Informática', :field => 'Descrição'

    fill_modal 'Classe', :with => 'Software', :field => 'Descrição'

    clear_modal 'Grupo'

    page.should have_disabled_field 'Classe'
    page.should have_field 'Classe', :with => ''
  end

  it 'should empty the class when the group are changed' do
    MaterialsGroup.make!(:ferro_aco)
    make_dependencies!

    click_link 'Solicitações'

    click_link 'Materiais'

    click_link 'Criar Material'

    fill_modal 'Grupo', :with => 'Informática', :field => 'Descrição'

    fill_modal 'Classe', :with => 'Software', :field => 'Descrição'

    fill_modal 'Grupo', :with => 'Ferro e Aço', :field => 'Descrição'

    page.should have_field 'Classe', :with => ''
  end

  it 'should not have the expense economic classification disabled when editing material' do
    make_dependencies!

    Material.make!(:antivirus)

    click_link 'Solicitações'

    click_link 'Materiais'

    click_link 'Antivirus'

    page.should_not have_disabled_field 'Natureza de despesa'
  end

  def make_dependencies!
    MaterialsGroup.make!(:informatica)
    MaterialsClass.make!(:software)
    ReferenceUnit.make!(:unidade)
    ServiceOrContractType.make!(:trainees)
    ExpenseNature.make!(:vencimento_e_salarios)
  end
end
