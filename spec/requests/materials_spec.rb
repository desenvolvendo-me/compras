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

    fill_modal 'Grupo', :with => 'Generos alimenticios', :field => 'Descrição'
    fill_modal 'Classe', :with => 'Hortifrutigranjeiros', :field => 'Descrição'
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
    fill_modal 'Portaria do STN', :with => 'Portaria Geral', :field => 'Descrição'
    fill_modal 'Elemento de despesa', :with => '3.1.90.11.01.00.00.00', :field => 'Classificação da natureza da despesa'

    click_button 'Criar Material'

    page.should have_notice 'Material criado com sucesso.'

    click_link 'Caixa'

    page.should have_field 'Grupo', :with => '01 - Generos alimenticios'
    page.should have_field 'Classe', :with => '01 - Hortifrutigranjeiros'
    page.should have_field 'Descrição', :with => 'Caixa'
    page.should have_field 'Descrição detalhada', :with => 'Uma caixa'
    page.should have_field 'Estoque mínimo', :with => '10'
    page.should have_field 'Unidade de medida', :with => 'Unidade'
    page.should have_field 'Referência do fabricante', :with => 'manufacturer'
    page.should have_checked_field 'Material perecível'
    page.should have_checked_field 'Material estocável'
    page.should_not have_checked_field 'Material combustível'
    page.should have_select 'Característica', :with => 'Material'
    page.should have_field 'Tipo de serviço', :with => 'Contratação de estagiários'
    page.should have_disabled_field 'Tipo de material'
    page.should have_field 'Portaria do STN', :with => 'Portaria Geral'
    page.should have_field 'Elemento de despesa', :with => '3.1.90.11.01.00.00.00'
  end

  scenario 'generate code' do
    make_dependencies!

    click_link 'Solicitações'

    click_link 'Materiais'

    click_link 'Criar Material'

    fill_modal 'Grupo', :with => 'Generos alimenticios', :field => 'Descrição'
    fill_modal 'Classe', :with => 'Hortifrutigranjeiros', :field => 'Descrição'
    fill_in 'Descrição', :with => 'Caixa'
    fill_in 'Descrição detalhada', :with => 'Outra descrição'
    fill_in 'Estoque mínimo', :with => '10'
    fill_modal 'Unidade de medida', :with => 'Unidade', :field => 'Descrição'
    fill_in 'Referência do fabricante', :with => 'manufacturer'
    check 'Material perecível'
    check 'Material estocável'

    select 'Serviço', :from => 'Característica'

    fill_modal 'Tipo de serviço', :with => 'Contratação de estagiários', :field => 'Descrição'
    fill_modal 'Portaria do STN', :with => 'Portaria Geral', :field => 'Descrição'
    fill_modal 'Elemento de despesa', :with => '3.1.90.11.01.00.00.00', :field => 'Classificação da natureza da despesa'

    click_button 'Criar Material'

    page.should have_notice 'Material criado com sucesso.'

    page.should have_content '01.01.00001'
  end

  scenario 'update an existent material' do
    make_dependencies!

    # Ensure the update of code
    # begin (do not change this order)
    Material.make!(:balde)
    Material.make!(:manga)
    Material.make!(:cadeira)
    # end

    ReferenceUnit.make!(:metro)
    MaterialsGroup.make!(:limpeza)
    MaterialsClass.make!(:pecas)
    EconomicClassificationOfExpenditure.make!(:compra_de_material)
    StnOrdinance.make!(:interministerial)

    click_link 'Solicitações'

    click_link 'Materiais'

    click_link 'Manga'

    fill_modal 'Grupo', :with => 'Limpeza', :field => 'Descrição'
    fill_modal 'Classe', :with => 'Peças', :field => 'Descrição'
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
    fill_modal 'Portaria do STN', :with => 'Portaria Interministerial', :field => 'Descrição'
    fill_modal 'Elemento de despesa', :with => '2.2.22.11.01.00.00.00', :field => 'Classificação da natureza da despesa'

    click_button 'Atualizar Material'

    page.should have_notice 'Material editado com sucesso.'

    click_link 'Parafuso'

    page.should have_field 'Grupo', :with => '02 - Limpeza'
    page.should have_field 'Classe', :with => '02 - Peças'
    page.should have_field 'Código', :with => '02.02.00003'
    page.should have_field 'Descrição', :with => 'Parafuso'
    page.should have_field 'Descrição detalhada', :with => 'de rosca'
    page.should have_field 'Estoque mínimo', :with => '20'
    page.should have_field 'Unidade de medida', :with => 'Metro', :field => 'Descrição'
    page.should have_field 'Referência do fabricante', :with => 'outro fabricante'
    page.should_not have_checked_field 'Material perecível'
    page.should_not have_checked_field 'Material estocável'
    page.should have_checked_field 'Material combustível'
    page.should have_select 'Característica', :with => 'Serviço'
    page.should have_disabled_field 'Tipo de serviço'
    page.should have_select 'Tipo de material', :with => 'De consumo'
    page.should have_field 'Portaria do STN', :with => 'Portaria Interministerial'
    page.should have_field 'Elemento de despesa', :with => '2.2.22.11.01.00.00.00'
  end

  scenario 'destroy an existent material' do
    Material.make!(:manga)

    click_link 'Solicitações'

    click_link 'Materiais'

    click_link 'Manga'

    click_link 'Apagar 01.01.00001 - Manga', :confirm => true

    page.should have_notice 'Material apagado com sucesso.'

    page.should_not have_content 'Manga'
  end

  scenario 'should validate uniqueness of name' do
    Material.make!(:manga)

    click_link 'Solicitações'

    click_link 'Materiais'

    click_link 'Criar Material'

    fill_in 'Descrição', :with => 'Manga'

    click_button 'Criar Material'

    page.should have_content 'já está em uso'
  end

  scenario 'should clean the unnecessary type of material or service depending on characteristic' do
    Material.make!(:manga)

    click_link 'Solicitações'

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

    click_link 'Solicitações'

    click_link 'Materiais'

    click_link 'Criar Material'

    page.should have_disabled_field 'Classe'

    fill_modal 'Grupo', :with => 'Generos alimenticios', :field => 'Descrição'

    page.should_not have_disabled_field 'Classe'

    fill_modal 'Classe', :with => 'Hortifrutigranjeiros', :field => 'Descrição' do
      page.should have_field 'filter_materials_group', :with => '01 - Generos alimenticios'
    end
  end

  it 'should not have the class disabled when editing material' do
    make_dependencies!

    Material.make!(:manga)

    click_link 'Solicitações'

    click_link 'Materiais'

    click_link 'Manga'

    page.should_not have_disabled_field 'Classe'
  end

  it 'should disable and empty the class when the group is removed' do
    make_dependencies!

    click_link 'Solicitações'

    click_link 'Materiais'

    click_link 'Criar Material'

    fill_modal 'Grupo', :with => 'Generos alimenticios', :field => 'Descrição'

    fill_modal 'Classe', :with => 'Hortifrutigranjeiros', :field => 'Descrição'

    clear_modal 'Grupo'

    page.should have_disabled_field 'Classe'
    page.should have_field 'Classe', :with => ''
  end

  it 'should empty the class when the group are changed' do
    MaterialsGroup.make!(:limpeza)
    make_dependencies!

    click_link 'Solicitações'

    click_link 'Materiais'

    click_link 'Criar Material'

    fill_modal 'Grupo', :with => 'Generos alimenticios', :field => 'Descrição'

    fill_modal 'Classe', :with => 'Hortifrutigranjeiros', :field => 'Descrição'

    fill_modal 'Grupo', :with => 'Limpeza', :field => 'Descrição'

    page.should have_field 'Classe', :with => ''
  end

  it 'should show selected stn ordinance on economic classification of expediture modal' do
    make_dependencies!

    click_link 'Solicitações'

    click_link 'Materiais'

    click_link 'Criar Material'

    page.should have_disabled_field 'Elemento de despesa'

    fill_modal 'Portaria do STN', :with => 'Portaria Geral', :field => 'Descrição'

    page.should_not have_disabled_field 'Elemento de despesa'

    fill_modal 'Elemento de despesa', :with => 'Vencimentos e Salários', :field => 'Descrição' do
      page.should have_field 'filter_stn_ordinance', :with => 'Portaria Geral'
    end
  end

  it 'should not have the economic classification of expenditure disabled when editing material' do
    make_dependencies!

    Material.make!(:manga)

    click_link 'Solicitações'

    click_link 'Materiais'

    click_link 'Manga'

    page.should_not have_disabled_field 'Elemento de despesa'
  end

  it 'should disable and empty the economic classification of expenditure when the stn ordinance is removed' do
    make_dependencies!

    click_link 'Solicitações'

    click_link 'Materiais'

    click_link 'Criar Material'

    fill_modal 'Portaria do STN', :with => 'Portaria Geral', :field => 'Descrição'

    fill_modal 'Elemento de despesa', :with => 'Vencimentos e Salários', :field => 'Descrição'

    clear_modal 'Portaria do STN'

    page.should have_disabled_field 'Elemento de despesa'
    page.should have_field 'Elemento de despesa', :with => ''
  end

  it 'should empty the economic classification of expenditure when the stn ordinance are changed' do
    make_dependencies!

    StnOrdinance.make!(:interministerial)

    click_link 'Solicitações'

    click_link 'Materiais'

    click_link 'Criar Material'

    fill_modal 'Portaria do STN', :with => 'Portaria Geral', :field => 'Descrição'

    fill_modal 'Elemento de despesa', :with => 'Vencimentos e Salários', :field => 'Descrição'

    fill_modal 'Portaria do STN', :with => 'Portaria Interministerial', :field => 'Descrição'

    page.should have_field 'Elemento de despesa', :with => ''
  end

  def make_dependencies!
    MaterialsGroup.make!(:alimenticios)
    MaterialsClass.make!(:hortifrutigranjeiros)
    ReferenceUnit.make!(:unidade)
    ServiceOrContractType.make!(:trainees)
    EconomicClassificationOfExpenditure.make!(:vencimento_e_salarios)
    StnOrdinance.make!(:geral)
  end
end
