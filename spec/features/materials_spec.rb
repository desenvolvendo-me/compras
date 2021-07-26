require 'spec_helper'

feature "Materials" do
  background do
    sign_in

    ExpenseNature.stub(:all).and_return [expense_nature]
    ExpenseNature.stub(:find).with(1, params: {}).and_return expense_nature
  end

  let(:expense_nature) do
    ExpenseNature.new(
      id: 1,
      regulatory_act_id: 1,
      expense_nature: '3.0.10.01.12',
      kind: 'analytical',
      description: 'Vencimentos e Salários',
      docket: 'Registra o valor das despesas com vencimentos')
  end

  scenario 'create a new material, update and destroy an existing' do
    navigate 'Cadastro > Cadastrais > Materiais > Materiais'
    click_link 'Criar Material'

    expect(page).to have_checked_field 'Ativo'
    expect(page).to_not have_field 'Controla quantidade'

    fill_with_autocomplete 'Classe', :with => 'Software'
    fill_in 'Descrição', :with => 'Caixa'
    fill_in 'Descrição detalhada', :with => 'Uma caixa'
    fill_modal 'Unidade', :with => 'Unidade', :field => 'Descrição'
    fill_in 'Referência do fabricante', :with => 'manufacturer'
    uncheck 'Ativo'

    # testing javascript
    select 'Material de consumo', :from => 'Tipo de material'
    expect(page).to_not have_field 'Controla quantidade'

    select 'Serviço', :from => 'Tipo de material'
    expect(page).to have_field 'Controla quantidade'
    # end of javascript test

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
    expect(page).to_not have_checked_field 'Ativo'
    expect(page).to have_select 'Tipo de material', :selected => 'Serviço'
    expect(page).to have_field 'Natureza da despesa', :with => '3.0.10.01.12 - Vencimentos e Salários'
    expect(page).to have_unchecked_field 'Controla quantidade'

    fill_in 'Descrição', :with => 'Desfragmentador de disco'
    fill_in 'Descrição detalhada', :with => 'Desfragmentador de disco com antivirus'
    fill_in 'Referência do fabricante', :with => 'outro fabricante'
    check 'Material combustível'
    select 'Material de consumo', :from => 'Tipo de material'

    click_button 'Salvar'

    expect(page).to have_notice 'Material editado com sucesso.'

    click_link 'Desfragmentador de disco'

    expect(page).to have_field 'Classe', :with => '01.32.00.000.000 - Software'
    expect(page).to have_field 'Descrição', :with => 'Desfragmentador de disco'
    expect(page).to have_field 'Descrição detalhada', :with => 'Desfragmentador de disco com antivirus'
    expect(page).to have_field 'Unidade', :with => 'UN'
    expect(page).to have_field 'Referência do fabricante', :with => 'outro fabricante'
    expect(page).to have_checked_field 'Material combustível'
    expect(page).to have_select 'Tipo de material', :selected => 'Material de consumo'
    expect(page).to have_field 'Natureza da despesa', :with => '3.0.10.01.12 - Vencimentos e Salários'

    click_link 'Apagar'

    expect(page).to have_notice 'Material apagado com sucesso.'

    expect(page).to_not have_content 'Parafuso'
  end

  scenario 'generate code' do
    navigate 'Cadastro > Cadastrais > Materiais > Materiais'

    click_link 'Criar Material'

    fill_with_autocomplete 'Classe', :with => 'Software'
    fill_in 'Descrição', :with => 'Caixa'
    fill_in 'Descrição detalhada', :with => 'Outra descrição'
    fill_modal 'Unidade', :with => 'Unidade', :field => 'Descrição'
    fill_in 'Referência do fabricante', :with => 'manufacturer'

    select 'Serviço', :from => 'Tipo de material'

    check 'Controla quantidade'

    fill_modal 'Natureza da despesa', :with => '3.0.10.01.12', :field => 'Natureza da despesa'

    click_button 'Salvar'

    expect(page).to have_notice 'Material criado com sucesso.'

    expect(page).to have_content '01.32.00.000.000.00001'

    click_link 'Caixa'

    expect(page).to have_checked_field 'Ativo'
    expect(page).to have_checked_field 'Controla quantidade'
  end

  scenario 'should clean the unnecessary service depending on material type' do
    Material.make!(:antivirus)

    navigate 'Cadastro > Cadastrais > Materiais > Materiais'

    click_link 'Antivirus'

    select 'Material de consumo', :from => 'Tipo de material'

    click_button 'Salvar'

    expect(page).to have_notice 'Material editado com sucesso'

    click_link 'Antivirus'

    select 'Serviço', :from => "Tipo de material"

    click_button 'Salvar'

    expect(page).to have_notice 'Material editado com sucesso'
  end

  it 'should not have the class disabled when editing material' do
    Material.make!(:antivirus)

    navigate 'Cadastro > Cadastrais > Materiais > Materiais'

    click_link 'Antivirus'

    expect(page).to_not have_field 'Classe', disabled: true
  end

  it 'should not have the expense economic classification disabled when editing material' do
    Material.make!(:antivirus)

    navigate 'Cadastro > Cadastrais > Materiais > Materiais'

    click_link 'Antivirus'

    expect(page).to_not have_field 'Natureza da despesa', disabled: true
  end

  scenario "provides a filter by material_type" do
    navigate 'Cadastro > Cadastrais > Materiais > Materiais'

    click_link "Filtrar Materiais"

    expect(page).to have_field "Tipo de material"
  end

  scenario 'index with columns at the index' do
    Material.make!(:antivirus)

    navigate 'Cadastro > Cadastrais > Materiais > Materiais'

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
    FactoryGirl.create(:material_class,
      :masked_number => "01.32.15.000.000", :description => 'Antivirus')

    navigate 'Cadastro > Cadastrais > Materiais > Materiais'

    click_link 'Criar Material'

    within_autocomplete 'Classe', :with => '01.' do
      expect(page).to have_content 'Antivirus'
      expect(page).to_not have_content 'Software'
    end
  end

  scenario 'uncheck control_amount when material_type is not service' do
    navigate 'Cadastro > Cadastrais > Materiais > Materiais'

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

    navigate 'Cadastro > Cadastrais > Materiais > Materiais'

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
end
