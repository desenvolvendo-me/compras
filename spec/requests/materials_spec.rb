# encoding: utf-8
require 'spec_helper'

feature "Materials" do
  background do
    sign_in
  end

  scenario 'create a new material' do
    make_dependencies!

    navigate 'Comum > Cadastrais > Materiais > Materiais'

    click_link 'Criar Material'

    expect(page).to have_disabled_field 'Tipo de material'
    expect(page).to have_disabled_field 'Tipo de serviço'

    fill_modal 'Classe', :with => 'Software', :field => 'Descrição'
    fill_in 'Descrição', :with => 'Caixa'
    fill_in 'Descrição detalhada', :with => 'Uma caixa'
    fill_in 'Estoque mínimo', :with => '10'
    fill_modal 'Unidade', :with => 'Unidade', :field => 'Descrição'
    fill_in 'Referência do fabricante', :with => 'manufacturer'
    check 'Material perecível'
    check 'Material estocável'

    # testing javascript
    select 'Material', :from => 'Característica'
    expect(page).to have_disabled_field 'Tipo de serviço'

    select 'Serviço', :from => 'Característica'
    expect(page).to have_disabled_field 'Tipo de material'
    # end of javascript test

    fill_modal 'Tipo de serviço', :with => 'Contratação de estagiários', :field => 'Descrição'
    fill_modal 'Natureza da despesa', :with => '3.0.10.01.12', :field => 'Natureza da despesa'

    click_button 'Salvar'

    expect(page).to have_notice 'Material criado com sucesso.'

    click_link 'Caixa'

    expect(page).to have_field 'Classe', :with => '01 - Software'
    expect(page).to have_field 'Descrição', :with => 'Caixa'
    expect(page).to have_field 'Descrição detalhada', :with => 'Uma caixa'
    expect(page).to have_field 'Estoque mínimo', :with => '10'
    expect(page).to have_field 'Unidade', :with => 'UN'
    expect(page).to have_field 'Referência do fabricante', :with => 'manufacturer'
    expect(page).to have_checked_field 'Material perecível'
    expect(page).to have_checked_field 'Material estocável'
    expect(page).to_not have_checked_field 'Material combustível'
    expect(page).to have_select 'Característica', :selected => 'Serviço'
    expect(page).to have_field 'Tipo de serviço', :with => 'Contratação de estagiários'
    expect(page).to have_disabled_field 'Tipo de material'
    expect(page).to have_field 'Natureza da despesa', :with => '3.0.10.01.12 - Vencimentos e Salários'
  end

  scenario 'generate code' do
    make_dependencies!

    navigate 'Comum > Cadastrais > Materiais > Materiais'

    click_link 'Criar Material'

    fill_modal 'Classe', :with => 'Software', :field => 'Descrição'
    fill_in 'Descrição', :with => 'Caixa'
    fill_in 'Descrição detalhada', :with => 'Outra descrição'
    fill_in 'Estoque mínimo', :with => '10'
    fill_modal 'Unidade', :with => 'Unidade', :field => 'Descrição'
    fill_in 'Referência do fabricante', :with => 'manufacturer'
    check 'Material perecível'
    check 'Material estocável'

    select 'Serviço', :from => 'Característica'

    fill_modal 'Tipo de serviço', :with => 'Contratação de estagiários', :field => 'Descrição'
    fill_modal 'Natureza da despesa', :with => '3.0.10.01.12', :field => 'Natureza da despesa'

    click_button 'Salvar'

    expect(page).to have_notice 'Material criado com sucesso.'

    expect(page).to have_content '01.00001'
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
    MaterialsClass.make!(:arames)
    ExpenseNature.make!(:compra_de_material)

    navigate 'Comum > Cadastrais > Materiais > Materiais'

    click_link 'Antivirus'

    fill_modal 'Classe', :with => 'Arames', :field => 'Descrição'
    fill_in 'Descrição', :with => 'Parafuso'
    fill_in 'Descrição detalhada', :with => 'de rosca'
    fill_in 'Estoque mínimo', :with => '20'
    fill_modal 'Unidade', :with => 'Metro', :field => 'Descrição'
    fill_in 'Referência do fabricante', :with => 'outro fabricante'
    uncheck 'Material perecível'
    uncheck 'Material estocável'
    check 'Material combustível'
    select 'Material', :from => 'Característica'

    # testing javascript
    expect(page).to have_disabled_field 'Tipo de serviço'
    # end of javascript test

    select 'De consumo', :from => 'Tipo de material'
    fill_modal 'Natureza da despesa', :with => '3.0.10.01.11', :field => 'Natureza da despesa'

    click_button 'Salvar'

    expect(page).to have_notice 'Material editado com sucesso.'

    click_link 'Parafuso'

    expect(page).to have_field 'Classe', :with => '02 - Arames'
    expect(page).to have_field 'Código', :with => '02.00003'
    expect(page).to have_field 'Descrição', :with => 'Parafuso'
    expect(page).to have_field 'Descrição detalhada', :with => 'de rosca'
    expect(page).to have_field 'Estoque mínimo', :with => '20'
    expect(page).to have_field 'Unidade', :with => 'M'
    expect(page).to have_field 'Referência do fabricante', :with => 'outro fabricante'
    expect(page).to_not have_checked_field 'Material perecível'
    expect(page).to_not have_checked_field 'Material estocável'
    expect(page).to have_checked_field 'Material combustível'
    expect(page).to have_select 'Característica', :selected => 'Material'
    expect(page).to have_disabled_field 'Tipo de serviço'
    expect(page).to have_select 'Tipo de material', :selected => 'De consumo'
    expect(page).to have_field 'Natureza da despesa', :with => '3.0.10.01.11 - Compra de Material'
  end

  scenario 'destroy an existent material' do
    Material.make!(:antivirus)

    navigate 'Comum > Cadastrais > Materiais > Materiais'

    click_link 'Antivirus'

    click_link 'Apagar'

    expect(page).to have_notice 'Material apagado com sucesso.'

    expect(page).to_not have_content 'Antivirus'
  end

  scenario 'cannot destroy an existent material with licitation_objects' do
    LicitationObject.make!(:ponte)

    navigate 'Comum > Cadastrais > Materiais > Materiais'

    click_link 'Antivirus'

    click_link 'Apagar'

    expect(page).to_not have_notice 'Material apagado com sucesso.'

    expect(page).to have_alert 'Material não pode ser apagado.'
  end

  scenario 'should clean the unnecessary type of material or service depending on characteristic' do
    Material.make!(:antivirus)

    navigate 'Comum > Cadastrais > Materiais > Materiais'

    click_link 'Antivirus'

    select 'Material', :from => "Característica"

    select 'De consumo', :from => 'Tipo de material'

    click_button 'Salvar'

    click_link 'Antivirus'

    select 'Serviço', :from => "Característica"

    expect(page).to have_field 'Tipo de serviço', :with => ''

    fill_modal 'Tipo de serviço', :with => 'Reparos', :field => 'Descrição'

    click_button 'Salvar'

    click_link 'Antivirus'

    select 'Material', :from => "Característica"

    expect(page).to have_select 'Tipo de material', :selected => ''
  end

  it 'should not have the class disabled when editing material' do
    make_dependencies!

    Material.make!(:antivirus)

    navigate 'Comum > Cadastrais > Materiais > Materiais'

    click_link 'Antivirus'

    expect(page).to_not have_disabled_field 'Classe'
  end

  it 'should not have the expense economic classification disabled when editing material' do
    make_dependencies!

    Material.make!(:antivirus)

    navigate 'Comum > Cadastrais > Materiais > Materiais'

    click_link 'Antivirus'

    expect(page).to_not have_disabled_field 'Natureza da despesa'
  end

  scenario "provides a filter by characteristic" do
    navigate 'Comum > Cadastrais > Materiais > Materiais'

    click_link "Filtrar Materiais"

    expect(page).to have_field "Característica"
  end

  scenario 'index with columns at the index' do
    Material.make!(:antivirus)

    navigate 'Comum > Cadastrais > Materiais > Materiais'

    within_records do
      expect(page).to have_content 'Descrição'
      expect(page).to have_content 'Código'
      expect(page).to have_content 'Classe'

      within 'tbody tr' do
        expect(page).to have_content 'Antivirus'
        expect(page).to have_content '01.00001'
        expect(page).to have_content 'Software'
      end
    end
  end

  def make_dependencies!
    MaterialsClass.make!(:software)
    ReferenceUnit.make!(:unidade)
    ServiceOrContractType.make!(:trainees)
    ExpenseNature.make!(:vencimento_e_salarios)
  end
end
