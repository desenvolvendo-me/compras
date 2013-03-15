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

    expect(page).to have_disabled_field 'Tipo de contrato'
    expect(page).to have_checked_field 'Ativo?'
    expect(page).to_not have_field 'Controla quantidade'

    fill_with_autocomplete 'Classe', :with => 'Software'
    fill_in 'Descrição', :with => 'Caixa'
    fill_in 'Descrição detalhada', :with => 'Uma caixa'
    fill_modal 'Unidade', :with => 'Unidade', :field => 'Descrição'
    fill_in 'Referência do fabricante', :with => 'manufacturer'
    uncheck 'Ativo?'

    # testing javascript
    select 'Material de consumo', :from => 'Tipo de material'
    expect(page).to have_disabled_field 'Tipo de contrato'
    expect(page).to_not have_field 'Controla quantidade'

    select 'Serviço', :from => 'Tipo de material'
    expect(page).to have_field 'Controla quantidade'
    # end of javascript test

    fill_modal 'Tipo de contrato', :with => 'Contratação de estagiários', :field => 'Descrição'
    fill_modal 'Natureza da despesa', :with => '3.0.10.01.12', :field => 'Natureza da despesa'

    click_button 'Salvar'

    expect(page).to have_notice 'Material criado com sucesso.'

    click_link 'Caixa'

    expect(page).to have_field 'Classe', :with => '01.32.00.000.000 - Software'
    expect(page).to have_field 'Descrição', :with => 'Caixa'
    expect(page).to have_field 'Descrição detalhada', :with => 'Uma caixa'
    expect(page).to have_field 'Unidade', :with => 'UN'
    expect(page).to have_field 'Referência do fabricante', :with => 'manufacturer'
    expect(page).to_not have_checked_field 'Material combustível'
    expect(page).to_not have_checked_field 'Ativo?'
    expect(page).to have_select 'Tipo de material', :selected => 'Serviço'
    expect(page).to have_field 'Tipo de contrato', :with => 'Contratação de estagiários'
    expect(page).to have_field 'Natureza da despesa', :with => '3.0.10.01.12 - Vencimentos e Salários'
    expect(page).to have_unchecked_field 'Controla quantidade'
  end

  scenario 'generate code' do
    make_dependencies!

    navigate 'Comum > Cadastrais > Materiais > Materiais'

    click_link 'Criar Material'

    fill_with_autocomplete 'Classe', :with => 'Software'
    fill_in 'Descrição', :with => 'Caixa'
    fill_in 'Descrição detalhada', :with => 'Outra descrição'
    fill_modal 'Unidade', :with => 'Unidade', :field => 'Descrição'
    fill_in 'Referência do fabricante', :with => 'manufacturer'

    select 'Serviço', :from => 'Tipo de material'

    check 'Controla quantidade'

    fill_modal 'Tipo de contrato', :with => 'Contratação de estagiários', :field => 'Descrição'
    fill_modal 'Natureza da despesa', :with => '3.0.10.01.12', :field => 'Natureza da despesa'

    click_button 'Salvar'

    expect(page).to have_notice 'Material criado com sucesso.'

    expect(page).to have_content '01.32.00.000.000.00001'

    click_link 'Caixa'

    expect(page).to have_checked_field 'Ativo?'
    expect(page).to have_checked_field 'Controla quantidade'
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

    fill_with_autocomplete 'Classe', :with => 'Arame'
    fill_in 'Descrição', :with => 'Parafuso'
    fill_in 'Descrição detalhada', :with => 'de rosca'
    fill_modal 'Unidade', :with => 'Metro', :field => 'Descrição'
    fill_in 'Referência do fabricante', :with => 'outro fabricante'
    check 'Material combustível'
    select 'Material de consumo', :from => 'Tipo de material'

    # testing javascript
    expect(page).to have_disabled_field 'Tipo de contrato'
    # end of javascript test

    fill_modal 'Natureza da despesa', :with => '3.0.10.01.11', :field => 'Natureza da despesa'

    click_button 'Salvar'

    expect(page).to have_notice 'Material editado com sucesso.'

    click_link 'Parafuso'

    expect(page).to have_field 'Classe', :with => '02.44.65.430.000 - Arames'
    expect(page).to have_field 'Descrição', :with => 'Parafuso'
    expect(page).to have_field 'Descrição detalhada', :with => 'de rosca'
    expect(page).to have_field 'Unidade', :with => 'M'
    expect(page).to have_field 'Referência do fabricante', :with => 'outro fabricante'
    expect(page).to have_checked_field 'Material combustível'
    expect(page).to have_select 'Tipo de material', :selected => 'Material de consumo'
    expect(page).to have_disabled_field 'Tipo de contrato'
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

  scenario 'should clean the unnecessary service depending on material type' do
    Material.make!(:antivirus)

    navigate 'Comum > Cadastrais > Materiais > Materiais'

    click_link 'Antivirus'

    select 'Material de consumo', :from => 'Tipo de material'

    click_button 'Salvar'

    expect(page).to have_notice 'Material editado com sucesso'

    click_link 'Antivirus'

    select 'Serviço', :from => "Tipo de material"

    expect(page).to have_field 'Tipo de contrato', :with => ''

    fill_modal 'Tipo de contrato', :with => 'Reparos', :field => 'Descrição'

    click_button 'Salvar'

    expect(page).to have_notice 'Material editado com sucesso'
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

  scenario "provides a filter by material_type" do
    navigate 'Comum > Cadastrais > Materiais > Materiais'

    click_link "Filtrar Materiais"

    expect(page).to have_field "Tipo de material"
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

  scenario 'does not show material classes with child' do
    make_dependencies!

    MaterialsClass.make!(:software,
      :masked_number => "01.32.15.000.000", :description => 'Antivirus')

    navigate 'Comum > Cadastrais > Materiais > Materiais'

    click_link 'Criar Material'

    within_autocomplete 'Classe', :with => '01.' do
      expect(page).to have_content 'Antivirus'
      expect(page).to_not have_content 'Software'
    end
  end

  scenario 'uncheck control_amount when material_type is not service' do
    make_dependencies!

    navigate 'Comum > Cadastrais > Materiais > Materiais'

    click_link 'Criar Material'

    select 'Serviço', :from => 'Tipo de material'

    expect(page).to have_unchecked_field 'Controla quantidade'

    check 'Controla quantidade'

    select 'Material de consumo', :from => 'Tipo de material'

    expect(page).to_not have_field 'Controla quantidade'

    select 'Serviço', :from => 'Tipo de material'

    expect(page).to have_unchecked_field 'Controla quantidade'
  end

  scenario 'show stock of material' do
    material = Material.make!(:antivirus)
    MaterialsControl.make!(:antivirus_general, :material => material)
    MaterialsControl.make!(:antivirus_general,
                           :material => material,
                           :replacement_quantity => 3)

    navigate 'Comum > Cadastrais > Materiais > Materiais'

    click_link 'Antivirus'

    expect(page).to_not have_css '#stock' # A tabela do stoque deve estar invisível

    click_link 'Visualizar estoque'

    expect(page).to_not have_link 'Visualizar estoque'
    expect(page).to have_link 'Esconder estoque'
    expect(page).to have_css '#stock' # A tabela do stoque deve estar visível

    within '#stock' do
      expect(page).to have_content 'Almoxarifado'
      expect(page).to have_content 'Máximo'
      expect(page).to have_content 'Mínimo'
      expect(page).to have_content 'Médio'
      expect(page).to have_content 'Reposição'

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Almoxarifado Geral'
        expect(page).to have_content '20,00'
        expect(page).to have_content '10,00'
        expect(page).to have_content '15,00'
        expect(page).to have_content '5,00'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content 'Almoxarifado Geral'
        expect(page).to have_content '20,00'
        expect(page).to have_content '10,00'
        expect(page).to have_content '15,00'
        expect(page).to have_content '3,00'
      end
    end

    click_link 'Esconder estoque'

    expect(page).to have_link 'Visualizar estoque'
    expect(page).to_not have_link 'Esconder estoque'

    expect(page).to_not have_css '#stock' # A tabela do stoque deve estar invisível
  end

  def make_dependencies!
    MaterialsClass.make!(:software)
    ReferenceUnit.make!(:unidade)
    ContractType.make!(:trainees)
    ExpenseNature.make!(:vencimento_e_salarios)
  end
end
