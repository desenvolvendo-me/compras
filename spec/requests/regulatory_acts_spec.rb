# encoding: utf-8
require 'spec_helper'

feature "RegulatoryActs" do
  background do
    sign_in
  end

  scenario 'create a new regulatory_act, update and destroy an existing' do
    make_dependencies!

    navigate 'Comum > Legislação > Ato Regulamentador > Atos Regulamentadores'

    click_link 'Criar Ato Regulamentador'

    within_tab 'Principal' do
      fill_in 'Número', :with => '1234'
      fill_modal 'Ato principal', :with => '4567', :field => 'Número'

      expect(page).to_not have_select 'Tipo de decreto de alteração orçamentária'

      fill_modal 'Tipo', :with => 'Alteração Orçamentária', :field => 'Descrição'
      select 'Decreto', :from => 'Classificação'

      expect(page).to have_select 'Tipo de decreto de alteração orçamentária'

      select 'Decreto de Crédito Suplementar', :from => 'Tipo de decreto de alteração orçamentária'

      fill_in 'Data da criação', :with => '01/01/2012'
      fill_in 'Data da assinatura', :with => '01/01/2012'
      fill_in 'Data da publicação', :with => '02/01/2012'
      fill_in 'Data a vigorar', :with => '03/01/2012'
      fill_in 'Data do término', :with => '09/01/2012'
      fill_in 'Ementa', :with => 'conteudo'
    end

    within_tab "Complementar" do
      fill_in 'Porcentagem de lei orçamentária', :with => '5,00'
      fill_in 'Porcentagem de antecipação da receita', :with => '3,00'
      fill_in 'Valor autorizado da dívida', :with => '7.000,00'
    end

    within_tab 'Meios de divulgação' do
      fill_modal 'Meio de divulgação', :with => 'Jornal Oficial do Município', :field => 'Descrição'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Ato Regulamentador criado com sucesso.'

    click_link 'Alteração Orçamentária'

    within_tab 'Principal' do
      expect(page).to have_field 'Número', :with => '1234'
      expect(page).to have_field 'Ato principal', :with => 'Emenda constitucional 4567'
      expect(page).to have_field 'Tipo', :with => 'Alteração Orçamentária'
      expect(page).to have_select 'Classificação', :selected => 'Decreto'
      expect(page).to have_select 'Tipo de decreto de alteração orçamentária', :selected => 'Decreto de Crédito Suplementar'
      expect(page).to have_field 'Data da criação', :with => '01/01/2012'
      expect(page).to have_field 'Data da assinatura', :with => '01/01/2012'
      expect(page).to have_field 'Data da publicação', :with => '02/01/2012'
      expect(page).to have_field 'Data a vigorar', :with => '03/01/2012'
      expect(page).to have_field 'Data do término', :with => '09/01/2012'
      expect(page).to have_field 'Ementa', :with => 'conteudo'
    end

    within_tab 'Complementar' do
      expect(page).to have_field 'Porcentagem de lei orçamentária', :with => '5,00'
      expect(page).to have_field 'Porcentagem de antecipação da receita', :with => '3,00'
      expect(page).to have_field 'Valor autorizado da dívida', :with => '7.000,00'
    end

    within_tab 'Meios de divulgação' do
      expect(page).to have_content 'Jornal Oficial do Município'
    end

    within_tab 'Principal' do
      fill_in 'Número', :with => '6789'
      select 'Portaria', :from => 'Classificação'
      fill_in 'Data da criação', :with => '01/01/2013'
      fill_in 'Data da assinatura', :with => '01/01/2013'
      fill_in 'Data da publicação', :with => '02/01/2013'
      fill_in 'Data a vigorar', :with => '03/01/2013'
      fill_in 'Data do término', :with => '09/01/2013'
      fill_in 'Ementa', :with => 'novo conteudo'
    end

    within_tab 'Complementar' do
      fill_in 'Porcentagem de lei orçamentária', :with => '15,00'
      fill_in 'Porcentagem de antecipação da receita', :with => '13,00'
      fill_in 'Valor autorizado da dívida', :with => '17.000,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Ato Regulamentador editado com sucesso.'

    click_link 'Alteração Orçamentária'

    within_tab 'Principal' do
      expect(page).to have_field 'Número', :with => '6789'
      expect(page).to have_field 'Data da criação', :with => '01/01/2013'
      expect(page).to have_select 'Classificação', :selected => 'Portaria'
      expect(page).to have_field 'Data da assinatura', :with => '01/01/2013'
      expect(page).to have_field 'Data da publicação', :with => '02/01/2013'
      expect(page).to have_field 'Data a vigorar', :with => '03/01/2013'
      expect(page).to have_field 'Data do término', :with => '09/01/2013'
      expect(page).to have_field 'Ementa', :with => 'novo conteudo'
    end

    within_tab 'Complementar' do
      expect(page).to have_field 'Porcentagem de lei orçamentária', :with => '15,00'
      expect(page).to have_field 'Porcentagem de antecipação da receita', :with => '13,00'
      expect(page).to have_field 'Valor autorizado da dívida', :with => '17.000,00'
    end

    click_link 'Apagar'

    expect(page).to have_notice 'Ato Regulamentador apagado com sucesso.'

    expect(page).to_not have_link 'Lei'
  end

  scenario 'remove dissemination source from an existent regulatory_act' do
    RegulatoryAct.make!(:sopa)

    navigate 'Comum > Legislação > Ato Regulamentador > Atos Regulamentadores'

    click_link 'Lei'

    within_tab 'Meios de divulgação' do
      click_button 'Remover'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Ato Regulamentador editado com sucesso.'

    click_link 'Lei'

    within_tab 'Meios de divulgação' do
      expect(page).to_not have_content 'Jornal Oficial do Bairro'
    end
  end

  scenario 'index with columns at the index' do
    RegulatoryAct.make!(:sopa)

    navigate 'Comum > Legislação > Ato Regulamentador > Atos Regulamentadores'

    within_records do
      expect(page).to have_content 'Tipo'
      expect(page).to have_content 'Número'
      expect(page).to have_content 'Data da criação'

      within 'tbody tr' do
        expect(page).to have_content 'Lei'
        expect(page).to have_content '1234'
        expect(page).to have_content '01/01/2012'
      end
    end
  end

  scenario 'update budget_change_decree_type of an existent regulatory_act' do
    RegulatoryActType.make!(:lei, :description => 'Outro tipo de ato')
    RegulatoryAct.make!(:sopa,
      :regulatory_act_type => RegulatoryActType.make(:lei, description: 'Alteração Orçamentária'),
      :classification => RegulatoryActClassification::DECREE,
      :budget_change_decree_type => BudgetChangeDecreeType::SPECIAL_CREDIT_DECREE,
      :parent => RegulatoryAct.make!(:emenda)
    )

    navigate 'Comum > Legislação > Ato Regulamentador > Atos Regulamentadores'

    click_link 'Alteração Orçamentária'

    within_tab 'Principal' do
      expect(page).to have_field 'Tipo', :with => 'Alteração Orçamentária'
      expect(page).to have_select 'Classificação', :selected => 'Decreto'
      expect(page).to have_select 'Tipo de decreto de alteração orçamentária', :selected => 'Decreto de Crédito Especial'

      select 'Decreto de Crédito Suplementar', :from => 'Tipo de decreto de alteração orçamentária'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Ato Regulamentador editado com sucesso.'

    click_link 'Alteração Orçamentária'

    within_tab 'Principal' do
      expect(page).to have_field 'Tipo', :with => 'Alteração Orçamentária'
      expect(page).to have_select 'Classificação', :selected => 'Decreto'
      expect(page).to have_select 'Tipo de decreto de alteração orçamentária', :selected => 'Decreto de Crédito Suplementar'

      fill_modal 'Tipo', :with => 'Outro tipo de ato', :field => 'Descrição'
      select 'Portaria', :from => 'Classificação'
      expect(page).to_not have_select 'Tipo de decreto de alteração orçamentária'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Ato Regulamentador editado com sucesso.'

    click_link 'Outro tipo de ato'

    within_tab 'Principal' do
      expect(page).to have_field 'Tipo', :with => 'Outro tipo de ato'
      expect(page).to have_select 'Classificação', :selected => 'Portaria'
      expect(page).to_not have_select 'Tipo de decreto de alteração orçamentária'

      fill_modal 'Tipo', :with => 'Alteração Orçamentária', :field => 'Descrição'
      select 'Decreto', :from => 'Classificação'
      expect(page).to have_select 'Tipo de decreto de alteração orçamentária', :selected => ''
    end
  end

  scenario 'update origin of an existent regulatory_act' do
    RegulatoryAct.make!(:sopa,
      :regulatory_act_type => RegulatoryActType.make(:lei, description: 'Alteração Orçamentária'),
      :classification => RegulatoryActClassification::DECREE,
      :budget_change_decree_type => BudgetChangeDecreeType::SPECIAL_CREDIT_DECREE,
      :origin => Origin::FINANCIAL_SURPLUS,
      :parent => RegulatoryAct.make!(:emenda)
    )

    navigate 'Comum > Legislação > Ato Regulamentador > Atos Regulamentadores'

    click_link 'Alteração Orçamentária'

    within_tab 'Principal' do
      expect(page).to have_select 'Tipo de decreto de alteração orçamentária', :selected => 'Decreto de Crédito Especial'
      expect(page).to have_select 'Origem', :selected => 'Superávit Financeiro'

      select 'Operação de crédito', :from => 'Origem'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Ato Regulamentador editado com sucesso.'

    click_link 'Alteração Orçamentária'

    within_tab 'Principal' do
      expect(page).to have_select 'Tipo de decreto de alteração orçamentária', :selected => 'Decreto de Crédito Especial'
      expect(page).to have_select 'Origem', :selected => 'Operação de crédito'

      select 'Decreto de Crédito Extraordinário', :from => 'Tipo de decreto de alteração orçamentária'
      expect(page).to_not have_select 'Origem'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Ato Regulamentador editado com sucesso.'

    click_link 'Alteração Orçamentária'

    within_tab 'Principal' do
      expect(page).to_not have_select 'Origem'

      select 'Decreto de Crédito Suplementar', :from => 'Tipo de decreto de alteração orçamentária'
      expect(page).to have_select 'Origem', :selected => ''
    end
  end

  scenario 'update budget_change_law_type of an existent regulatory_act' do
    RegulatoryActType.make!(:lei, :description => 'Outro tipo de ato')
    RegulatoryAct.make!(
      :sopa,
      :regulatory_act_type => RegulatoryActType.make(:lei, description: 'Alteração Orçamentária'),
      :classification => RegulatoryActClassification::LAW,
      :budget_change_law_type => BudgetChangeLawType::SPECIAL_CREDIT_AUTHORIZATION_LAW
    )

    navigate 'Comum > Legislação > Ato Regulamentador > Atos Regulamentadores'

    click_link 'Alteração Orçamentária'

    within_tab 'Principal' do
      expect(page).to have_field 'Tipo', :with => 'Alteração Orçamentária'
      expect(page).to have_select 'Classificação', :selected => 'Lei'
      expect(page).to have_select 'Tipo de lei de alteração orçamentária', :selected => 'Lei autorizativa de Crédito Especial'

      select 'Lei autorizativa de Crédito Suplementar', :from => 'Tipo de lei de alteração orçamentária'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Ato Regulamentador editado com sucesso.'

    click_link 'Alteração Orçamentária'

    within_tab 'Principal' do
      expect(page).to have_field 'Tipo', :with => 'Alteração Orçamentária'
      expect(page).to have_select 'Classificação', :selected => 'Lei'
      expect(page).to have_select 'Tipo de lei de alteração orçamentária', :selected => 'Lei autorizativa de Crédito Suplementar'

      fill_modal 'Tipo', :with => 'Outro tipo de ato', :field => 'Descrição'
      select 'Portaria', :from => 'Classificação'
      expect(page).to_not have_select 'Tipo de lei de alteração orçamentária'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Ato Regulamentador editado com sucesso.'

    click_link 'Outro tipo de ato'

    within_tab 'Principal' do
      expect(page).to have_field 'Tipo', :with => 'Outro tipo de ato'
      expect(page).to have_select 'Classificação', :selected => 'Portaria'
      expect(page).to_not have_select 'Tipo de lei de alteração orçamentária'

      fill_modal 'Tipo', :with => 'Alteração Orçamentária', :field => 'Descrição'
      select 'Lei', :from => 'Classificação'
      expect(page).to have_select 'Tipo de lei de alteração orçamentária', :selected => ''
    end
  end

  def make_dependencies!
    RegulatoryActType.make!(:lei)
    RegulatoryActType.make!(:emenda, description: 'Alteração Orçamentária')
    RegulatoryAct.make!(:emenda)
    DisseminationSource.make!(:jornal_municipal)
  end
end
