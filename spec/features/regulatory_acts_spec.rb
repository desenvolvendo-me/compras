require 'spec_helper'

feature "RegulatoryActs" do
  background do
    sign_in
  end

  scenario 'create a new regulatory_act' do
    RegulatoryAct.make!(:emenda,
      :regulatory_act_type => RegulatoryActType::LOA,
      :authorized_value => 1,
      :additional_percent => 1
    )

    DisseminationSource.make!(:jornal_municipal,
      :communication_source => CommunicationSource.make!(:jornal_estadual)
    )

    navigate 'Cadastro > Legislação > Atos Regulamentadores'

    click_link 'Criar Ato Regulamentador'

    within_tab "Principal" do
      fill_in 'Número', :with => '123466'
      fill_modal 'Ato principal', :with => '4567', :field => 'Número'

      expect(page).to_not have_field 'Valor autorizado'
      expect(page).to_not have_field 'Percentual de suplementação'
      expect(page).to_not have_field 'Percentual utilizado'
      expect(page).to_not have_select 'Tipo de decreto de alteração orçamentária'

      select 'Alteração Orçamentária', :from => 'Tipo'
      select 'Decreto', :from => 'Classificação'
      expect(page).to have_select 'Tipo de decreto de alteração orçamentária'
      expect(page).to have_field 'Valor autorizado'

      select 'Lei', :from => 'Classificação'
      expect(page).to have_field 'Valor autorizado'
      expect(page).to have_field 'Percentual de suplementação'
      expect(page).to have_field 'Percentual utilizado', disabled: true

      select 'LOA', :from => 'Tipo'
      expect(page).to have_field 'Valor autorizado'
      expect(page).to have_field 'Percentual de suplementação'
      expect(page).to have_field 'Percentual utilizado', disabled: true

      select 'Alteração Orçamentária', :from => 'Tipo'
      select 'Decreto', :from => 'Classificação'
      expect(page).to have_field 'Valor autorizado'
      expect(page).to have_select 'Tipo de decreto de alteração orçamentária'

      select 'Decreto de Crédito Suplementar', :from => 'Tipo de decreto de alteração orçamentária'

      fill_in 'Data da criação', :with => '01/01/2012'
      fill_in 'Valor autorizado', :with => '1,00'
      fill_in 'Data da assinatura', :with => '01/01/2012'
      fill_in 'Data da publicação', :with => '02/01/2012'
      fill_in 'Data a vigorar', :with => '03/01/2012'
      fill_in 'Data do término', :with => '09/01/2012'
      fill_in 'Ementa', :with => 'conteudo ementa'
    end

    within_tab "Complementar" do
      fill_in 'Número do artigo', :with => '123456'
      fill_in 'Descrição do artigo', :with => 'Descrição'
    end

    within_tab 'Meios de divulgação' do
      fill_modal 'Meio de divulgação', :with => 'Jornal Oficial do Município', :field => 'Descrição'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Ato Regulamentador criado com sucesso.'

    click_link 'Alteração Orçamentária'

    within_tab 'Principal' do
      expect(page).to have_field 'Número', :with => '123466'
      expect(page).to have_field 'Ato principal', :with => 'LOA 4567'
      expect(page).to have_select 'Tipo', :selected => 'Alteração Orçamentária'
      expect(page).to have_select 'Classificação', :selected => 'Decreto'
      expect(page).to have_select 'Tipo de decreto de alteração orçamentária',
                                  :selected => 'Decreto de Crédito Suplementar'
      expect(page).to have_field 'Data da criação', :with => '01/01/2012'
      expect(page).to have_field 'Data da assinatura', :with => '01/01/2012'
      expect(page).to have_field 'Data da publicação', :with => '02/01/2012'
      expect(page).to have_field 'Data a vigorar', :with => '03/01/2012'
      expect(page).to have_field 'Data do término', :with => '09/01/2012'
      expect(page).to have_field 'Ementa', :with => 'conteudo ementa'
    end

    within_tab 'Complementar' do
      expect(page).to have_field 'Número do artigo', :with => '123456'
      expect(page).to have_field 'Descrição do artigo', :with => 'Descrição'
    end

    within_tab 'Meios de divulgação' do
      expect(page).to have_content 'Jornal Oficial do Município'
    end
  end

  scenario 'update an existent regulatory_act' do
    RegulatoryAct.make!(:sopa,
      :act_number => 1221,
      :content => "ementa",
      :parent => RegulatoryAct.make!(:emenda)
    )

    RegulatoryAct.make!(:emenda,
      :act_number => '4881',
      :content => 'Outro conteudo'
    )

    DisseminationSource.make!(:jornal_municipal)

    navigate 'Cadastro > Legislação > Atos Regulamentadores'

    click_link 'LDO'

    within_tab 'Principal' do
      fill_in 'Número', :with => '678966'
      fill_modal 'Ato principal', :with => '4881', :field => 'Número'
      select 'PPA', :from => 'Tipo'
      select 'Portaria', :from => 'Classificação'
      fill_in 'Data da criação', :with => '01/01/2013'
      fill_in 'Data da assinatura', :with => '01/01/2013'
      fill_in 'Data da publicação', :with => '02/01/2013'
      fill_in 'Data a vigorar', :with => '03/01/2013'
      fill_in 'Data do término', :with => '09/01/2013'
      fill_in 'Ementa', :with => 'novo conteudo ementa'
    end

    within_tab 'Meios de divulgação' do
      expect(page).to have_content 'Jornal Oficial do Bairro'
      click_button 'Remover'
      fill_modal 'Meio de divulgação', :with => 'Jornal Oficial do Município', :field => 'Descrição'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Ato Regulamentador editado com sucesso.'

    click_link 'PPA'

    within_tab 'Principal' do
      expect(page).to have_field 'Número', :with => '678966'
      expect(page).to have_field 'Ato principal', :with => 'LDO 4881'
      expect(page).to have_select 'Tipo', :selected => 'PPA'
      expect(page).to have_select 'Classificação', :selected => 'Portaria'
      expect(page).to have_field 'Data da criação', :with => '01/01/2013'
      expect(page).to have_field 'Data da assinatura', :with => '01/01/2013'
      expect(page).to have_field 'Data da publicação', :with => '02/01/2013'
      expect(page).to have_field 'Data a vigorar', :with => '03/01/2013'
      expect(page).to have_field 'Data do término', :with => '09/01/2013'
      expect(page).to have_field 'Ementa', :with => 'novo conteudo ementa'
    end

    within_tab 'Meios de divulgação' do
      expect(page).to have_content 'Jornal Oficial do Município'
    end
  end

  scenario 'update budget_change_decree_type of an existent regulatory_act' do
    RegulatoryAct.make!(
      :sopa,
      :act_number => 111,
      :content => "ementa",
      :regulatory_act_type => RegulatoryActType::BUDGET_CHANGE,
      :classification => RegulatoryActClassification::DECREE,
      :budget_change_decree_type => BudgetChangeDecreeType::SPECIAL_CREDIT_DECREE,
      :parent => RegulatoryAct.make!(:emenda)
    )

    navigate 'Cadastro > Legislação > Atos Regulamentadores'

    click_link 'Alteração Orçamentária'

    within_tab 'Principal' do
      expect(page).to have_select 'Tipo', :selected => 'Alteração Orçamentária'
      expect(page).to have_select 'Classificação', :selected => 'Decreto'
      expect(page).to have_select 'Tipo de decreto de alteração orçamentária', :selected => 'Decreto de Crédito Especial'

      select 'Decreto de Crédito Suplementar', :from => 'Tipo de decreto de alteração orçamentária'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Ato Regulamentador editado com sucesso.'

    click_link 'Alteração Orçamentária'

    within_tab 'Principal' do
      expect(page).to have_select 'Tipo', :selected => 'Alteração Orçamentária'
      expect(page).to have_select 'Classificação', :selected => 'Decreto'
      expect(page).to have_select 'Tipo de decreto de alteração orçamentária', :selected => 'Decreto de Crédito Suplementar'

      select 'PPA', :from => 'Tipo'
      select 'Portaria', :from => 'Classificação'
      expect(page).to_not have_select 'Tipo de decreto de alteração orçamentária'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Ato Regulamentador editado com sucesso.'

    click_link 'PPA'

    within_tab 'Principal' do
      expect(page).to have_select 'Tipo', :selected => 'PPA'
      expect(page).to have_select 'Classificação', :selected => 'Portaria'
      expect(page).to_not have_select 'Tipo de decreto de alteração orçamentária'

      select 'Alteração Orçamentária', :from => 'Tipo'
      select 'Decreto', :from => 'Classificação'
      expect(page).to have_select 'Tipo de decreto de alteração orçamentária', :selected => ''
    end
  end

  scenario 'update origin of an existent regulatory_act' do
    RegulatoryAct.make!(
      :sopa,
      :act_number => 1212,
      :content => "ementa",
      :regulatory_act_type => RegulatoryActType::BUDGET_CHANGE,
      :classification => RegulatoryActClassification::DECREE,
      :budget_change_decree_type => BudgetChangeDecreeType::SPECIAL_CREDIT_DECREE,
      :origin => Origin::FINANCIAL_SURPLUS,
      :parent => RegulatoryAct.make!(:emenda)
    )

    navigate 'Cadastro > Legislação > Atos Regulamentadores'

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
    RegulatoryAct.make!(
      :sopa,
      :act_number => 122,
      :content => "ementa",
      :regulatory_act_type => RegulatoryActType::BUDGET_CHANGE,
      :classification => RegulatoryActClassification::LAW,
      :budget_change_law_type => BudgetChangeLawType::SPECIAL_CREDIT_AUTHORIZATION_LAW,
      :authorized_value => 0.5,
      :additional_percent => 0.5
    )

    navigate 'Cadastro > Legislação > Atos Regulamentadores'

    click_link 'Alteração Orçamentária'

    within_tab 'Principal' do
      expect(page).to have_select 'Tipo', :selected => 'Alteração Orçamentária'
      expect(page).to have_select 'Classificação', :selected => 'Lei'
      expect(page).to have_select 'Tipo de lei de alteração orçamentária', :selected => 'Lei autorizativa de Crédito Especial'

      select 'Lei autorizativa de Crédito Suplementar', :from => 'Tipo de lei de alteração orçamentária'

      expect(page).to have_field 'Valor autorizado'
      expect(page).to have_field 'Percentual de suplementação'
      expect(page).to have_field 'Percentual utilizado', disabled: true

      fill_in 'Valor autorizado', :with => '1,00'
      fill_in 'Percentual de suplementação', :with => '1,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Ato Regulamentador editado com sucesso.'

    click_link 'Alteração Orçamentária'

    within_tab 'Principal' do
      expect(page).to have_select 'Tipo', :selected => 'Alteração Orçamentária'
      expect(page).to have_select 'Classificação', :selected => 'Lei'
      expect(page).to have_select 'Tipo de lei de alteração orçamentária', :selected => 'Lei autorizativa de Crédito Suplementar'

      select 'PPA', :from => 'Tipo'
      select 'Portaria', :from => 'Classificação'
      expect(page).to_not have_select 'Tipo de lei de alteração orçamentária'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Ato Regulamentador editado com sucesso.'

    click_link 'PPA'

    within_tab 'Principal' do
      expect(page).to have_select 'Tipo', :selected => 'PPA'
      expect(page).to have_select 'Classificação', :selected => 'Portaria'
      expect(page).to_not have_select 'Tipo de lei de alteração orçamentária'

      select 'Alteração Orçamentária', :from => 'Tipo'
      select 'Lei', :from => 'Classificação'
      expect(page).to have_select 'Tipo de lei de alteração orçamentária', :selected => ''
    end
  end

  scenario 'destroy an existent regulatory_act' do
    RegulatoryAct.make!(:emenda, :regulatory_act_type => RegulatoryActType::PPA)

    navigate 'Cadastro > Legislação > Atos Regulamentadores'

    click_link 'PPA'

    click_link 'Apagar'

    expect(page).to have_notice 'Ato Regulamentador apagado com sucesso.'

    expect(page).to_not have_link 'PPA'
  end
end
