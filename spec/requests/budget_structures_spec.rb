# encoding: utf-8
require 'spec_helper'

feature "BudgetStructure" do
  background do
    sign_in
  end

  scenario 'create a new budget structure' do
    pending "this test will be removed when there is integration with the accounting system"

    BudgetStructureConfiguration.make!(:detran_sopa)
    AdministrationType.make!(:publica)
    Address.make!(:general)
    Employee.make!(:sobrinho)

    navigate 'Outros > Contabilidade > Orçamento > Estrutura Organizacional > Estruturas Orçamentarias'

    click_link 'Criar Estrutura Orçamentaria'

    within_tab 'Informações' do
      fill_modal 'Configuração de estrutura orçamentaria', :with => 'Configuração do Detran', :field => 'Descrição'
      select 'Sintético', :from => 'Tipo'

      within_modal 'Nível' do
        expect(page).to have_field 'Configuração de estrutura orçamentaria', :with => 'Configuração do Detran'
        expect(page).to have_disabled_field 'Configuração de estrutura orçamentaria'
        click_button 'Pesquisar'
        click_record 'Orgão'
      end

      fill_in 'Código', :with => '1'
      expect(page).to have_field 'Estrutura orçamentaria', :with => '1'
      fill_in 'Código do TCE', :with => '051'
      fill_in 'Descrição', :with => 'Secretaria de Educação'
      fill_in 'Sigla', :with => 'SEMUEDU'
      fill_modal 'Tipo de administração', :with => 'Pública', :field => 'Descrição'
      fill_in 'Área de atuação', :with => 'Desenvolvimento Educacional'
    end

    within_tab 'Endereços' do
      fill_modal 'Logradouro', :with => 'Girassol'
      fill_modal 'Bairro', :with => 'São Francisco'
      fill_in 'CEP', :with => "33400-500"
    end

    within_tab 'Responsáveis' do
      click_button 'Adicionar Responsável'

      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'
      fill_in 'Data de início', :with => '01/02/2012'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Estrutura Orçamentaria criada com sucesso.'

    click_link 'Secretaria de Educação'

    within_tab 'Informações' do
      expect(page).to have_field 'Configuração de estrutura orçamentaria', :with => 'Configuração do Detran'
      expect(page).to have_select 'Tipo', :selected => 'Sintético'
      expect(page).to have_field 'Nível', :with => '1 - Orgão'
      expect(page).to have_field 'Código', :with => '1'
      expect(page).to have_field 'Estrutura orçamentaria', :with => '1'
      expect(page).to have_field 'Código do TCE', :with => '051'
      expect(page).to have_field 'Descrição', :with => 'Secretaria de Educação'
      expect(page).to have_field 'Sigla', :with => 'SEMUEDU'
      expect(page).to have_field 'Tipo de administração', :with => 'Pública'
      expect(page).to have_field 'Área de atuação', :with => 'Desenvolvimento Educacional'
    end

    within_tab 'Endereços' do
      expect(page).to have_field 'Logradouro', :with => 'Rua Girassol'
      expect(page).to have_field 'Bairro', :with => 'São Francisco'
      expect(page).to have_field 'CEP', :with => '33400-500'
    end

    within_tab 'Responsáveis' do
      expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Ato regulamentador', :with => 'Lei 1234'
      expect(page).to have_field 'Data de início', :with => '01/02/2012'
      expect(page).to have_field 'Data de término', :with => ''
      expect(page).to have_select 'Status', :selected => 'Ativo'
    end
  end

  scenario 'update an existent budget structure' do
    pending "this test will be removed when there is integration with the accounting system"

    BudgetStructure.make!(:secretaria_de_educacao)
    Address.make!(:education)
    AdministrationType.make!(:executivo)
    Employee.make!(:wenderson)
    RegulatoryAct.make!(:emenda)

    navigate 'Outros > Contabilidade > Orçamento > Estrutura Organizacional > Estruturas Orçamentarias'

    click_link 'Secretaria de Educação'

    within_tab 'Informações' do
      fill_modal 'Configuração de estrutura orçamentaria', :with => 'Configuração do Detran', :field => 'Descrição'
      within_modal 'Nível' do
        expect(page).to have_field 'Configuração de estrutura orçamentaria', :with => 'Configuração do Detran'
        expect(page).to have_disabled_field 'Configuração de estrutura orçamentaria'
        click_button 'Pesquisar'
        click_record 'Orgão'
      end
      fill_in 'Código', :with => '2'
      expect(page).to have_field 'Estrutura orçamentaria', :with => '2'
      fill_in 'Código do TCE', :with => '081'
      fill_in 'Descrição', :with => 'Secretaria de Transporte'
      fill_in 'Sigla', :with => 'SEMUTRA'
      fill_modal 'Tipo de administração', :with => 'Executivo', :field => 'Descrição'
      fill_in 'Área de atuação', :with => 'Desenvolvimento de Transporte'
    end

    within_tab 'Endereços' do
      fill_modal 'Logradouro', :with => 'Amazonas'
      fill_modal 'Bairro', :with => 'Portugal'
      fill_in 'CEP', :with => '33600-500'
    end

    within_tab 'Responsáveis' do
      click_button 'Adicionar Responsável'
      fill_modal 'Responsável', :with => '12903412', :field => 'Matrícula'
      fill_modal 'Ato regulamentador', :with => '4567', :field => 'Número'
      fill_in 'Data de início', :with => I18n.l(Date.current)
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Estrutura Orçamentaria editada com sucesso.'

    click_link 'Secretaria de Transporte'

    within_tab 'Informações' do
      expect(page).to have_field 'Configuração de estrutura orçamentaria', :with => 'Configuração do Detran'
      expect(page).to have_select 'Tipo', :selected => 'Sintético'
      expect(page).to have_field 'Nível', :with => '1 - Orgão'
      expect(page).to have_field 'Código', :with => '2'
      expect(page).to have_field 'Estrutura orçamentaria', :with => '2'
      expect(page).to have_field 'Código do TCE', :with => '081'
      expect(page).to have_field 'Descrição', :with => 'Secretaria de Transporte'
      expect(page).to have_field 'Sigla', :with => 'SEMUTRA'
      expect(page).to have_field 'Tipo de administração', :with => 'Executivo'
      expect(page).to have_field 'Área de atuação', :with => 'Desenvolvimento de Transporte'
    end

    within_tab 'Endereços' do
      expect(page).to have_field 'Logradouro', :with => 'Avenida Amazonas'
      expect(page).to have_field 'Bairro', :with => 'Portugal'
      expect(page).to have_field 'CEP', :with => '33600-500'
    end

    within_tab 'Responsáveis' do
      within 'fieldset:nth-child(1)' do
        expect(page).to have_field 'Responsável', :with => 'Wenderson Malheiros'
        expect(page).to have_field 'Ato regulamentador', :with => 'Emenda constitucional 4567'
        expect(page).to have_field 'Data de início', :with => I18n.l(Date.current)
        expect(page).to have_field  'Data de término', :with => ''
        expect(page).to have_select 'Status', :selected => 'Ativo'
      end
    end
  end

  scenario 'assert that javascript return parent mask when budget structure that have a parent' do
    pending "this test will be removed when there is integration with the accounting system"

    BudgetStructure.make!(:secretaria_de_desenvolvimento)

    navigate 'Outros > Contabilidade > Orçamento > Estrutura Organizacional > Estruturas Orçamentarias'

    click_link 'Secretaria de Desenvolvimento'

    within_tab 'Informações' do
      fill_in 'Código', :with => '12'

      expect(page).to have_field 'Estrutura orçamentaria', :with => '1.12'
    end
  end

  scenario 'update an existent budget structure' do
    pending "this test will be removed when there is integration with the accounting system"

    BudgetStructure.make!(:secretaria_de_desenvolvimento_level_3 )

    navigate 'Outros > Contabilidade > Orçamento > Estrutura Organizacional > Estruturas Orçamentarias'

    click_link 'Secretaria de Educação'

    within_tab 'Informações' do
      fill_modal 'Nível', :with => 'Unidade', :field => 'Descrição'
    end

    click_button 'Salvar'

    expect(page).to have_disabled_field 'Código'
    expect(page).to have_field 'Código', :with => ''
  end

  scenario 'should not create a new budget structure when already exist a code in the same level and configuration' do
    pending "this test will be removed when there is integration with the accounting system"

    BudgetStructure.make!(:secretaria_de_educacao)
    BudgetStructureConfiguration.make!(:detran_sopa)
    AdministrationType.make!(:publica)
    Address.make!(:general)
    Employee.make!(:sobrinho)

    navigate 'Outros > Contabilidade > Orçamento > Estrutura Organizacional > Estruturas Orçamentarias'

    click_link 'Criar Estrutura Orçamentaria'

    within_tab 'Informações' do
      fill_modal 'Configuração de estrutura orçamentaria', :with => 'Configuração do Detran', :field => 'Descrição'
      select 'Sintético', :from => 'Tipo'

      within_modal 'Nível' do
        expect(page).to have_field 'Configuração de estrutura orçamentaria', :with => 'Configuração do Detran'
        expect(page).to have_disabled_field 'Configuração de estrutura orçamentaria'
        click_button 'Pesquisar'
        click_record 'Orgão'
      end

      fill_in 'Código', :with => '1'
      expect(page).to have_field 'Estrutura orçamentaria', :with => '1'
      fill_in 'Código do TCE', :with => '051'
      fill_in 'Descrição', :with => 'Secretaria de Educação'
      fill_in 'Sigla', :with => 'SEMUEDU'
      fill_modal 'Tipo de administração', :with => 'Pública', :field => 'Descrição'
      fill_in 'Área de atuação', :with => 'Desenvolvimento Educacional'
    end

    within_tab 'Endereços' do
      fill_modal 'Logradouro', :with => 'Girassol'
      fill_modal 'Bairro', :with => 'São Francisco'
      fill_in 'CEP', :with => "33400-500"
    end

    within_tab 'Responsáveis' do
      click_button 'Adicionar Responsável'

      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'
      fill_in 'Data de início', :with => '01/02/2012'
      fill_in 'Data de término', :with => '10/02/2012'
    end

    click_button 'Salvar'

    expect(page).to have_content 'já existe um código para este nível desta configuração Estrutura orçamentaria Código do TCE'
  end

  scenario 'validating modal of level' do
    pending "this test will be removed when there is integration with the accounting system"

    BudgetStructure.make!(:secretaria_de_educacao)
    BudgetStructureConfiguration.make!(:secretaria_de_educacao)

    navigate 'Outros > Contabilidade > Orçamento > Estrutura Organizacional > Estruturas Orçamentarias'

    click_link 'Secretaria de Educação'

    within_tab 'Informações' do
      fill_modal 'Configuração de estrutura orçamentaria', :with => 'Configuração do Detran', :field => 'Descrição'
      within_modal 'Nível' do
         click_button 'Pesquisar'

         expect(page).to have_content 'Orgão'
         expect(page).to have_content 'Unidade'
         expect(page).to_not have_content 'Nível 1'
         expect(page).to_not have_content 'Nível 2'
      end
    end
  end

  scenario 'validating modal of budget_structure_parent' do
    pending "this test will be removed when there is integration with the accounting system"

    BudgetStructure.make!(:secretaria_de_educacao)
    BudgetStructure.make!(:secretaria_de_desenvolvimento)

    navigate 'Outros > Contabilidade > Orçamento > Estrutura Organizacional > Estruturas Orçamentarias'

    click_link 'Criar Estrutura Orçamentaria'

    within_tab 'Informações' do
      fill_modal 'Configuração de estrutura orçamentaria', :with => 'Configuração do Detran', :field => 'Descrição'
      select 'Sintético', :from => 'Tipo'

      within_modal 'Nível' do
        expect(page).to have_field 'Configuração de estrutura orçamentaria', :with => 'Configuração do Detran'
        expect(page).to have_disabled_field 'Configuração de estrutura orçamentaria'
        click_button 'Pesquisar'
        click_record 'Unidade'
      end

      within_modal 'Estrutura orçamentaria superior' do
        expect(page).to have_field 'Configuração de estrutura orçamentaria', :with => 'Configuração do Detran'
        expect(page).to have_disabled_field 'Configuração de estrutura orçamentaria'
        expect(page).to have_field 'Nível', :with => '1 - Orgão'
        expect(page).to have_disabled_field 'Nível'

        click_button 'Pesquisar'

        expect(page).to have_content 'Secretaria de Educação'
        expect(page).to_not have_content 'Secretaria de Desenvolvimento'
      end
    end
  end

  scenario 'destroy an existent budget structure' do
    pending "this test will be removed when there is integration with the accounting system"

    BudgetStructure.make!(:secretaria_de_educacao)

    navigate 'Outros > Contabilidade > Orçamento > Estrutura Organizacional > Estruturas Orçamentarias'

    click_link 'Secretaria de Educação'

    click_link 'Apagar'

    expect(page).to have_notice 'Estrutura Orçamentaria apagada com sucesso.'

    expect(page).to_not have_content 'Secretaria de Educação'
    expect(page).to_not have_content 'Configuração do Detran'
    expect(page).to_not have_content '02.00'
    expect(page).to_not have_content '051'
    expect(page).to_not have_content 'SEMUEDU'
    expect(page).to_not have_content 'Pública'
    expect(page).to_not have_content 'Desenvolvimento Educacional'
  end

  scenario 'should allow one responsible by time when new form' do
    pending "this test will be removed when there is integration with the accounting system"

    navigate 'Outros > Contabilidade > Orçamento > Estrutura Organizacional > Estruturas Orçamentarias'

    click_link 'Criar Estrutura Orçamentaria'

    within_tab 'Responsáveis' do
      click_button 'Adicionar Responsável'

      expect(page).to have_css('.remove-budget-structure-responsible', :count => 1)

      expect(page).to have_disabled_button 'Adicionar Responsável'

      click_button 'Remover Responsável'

      expect(page).to_not have_button 'Remover Responsável'

      click_button 'Adicionar Responsável'

      expect(page).to have_css('.remove-budget-structure-responsible', :count => 1)
    end
  end

  scenario 'should allow one responsible by time when edit' do
    pending "this test will be removed when there is integration with the accounting system"

    BudgetStructure.make!(:secretaria_de_educacao)

    navigate 'Outros > Contabilidade > Orçamento > Estrutura Organizacional > Estruturas Orçamentarias'

    click_link 'Secretaria de Educação'

    within_tab 'Responsáveis' do
      click_button 'Adicionar Responsável'

      expect(page).to have_css('.remove-budget-structure-responsible', :count => 1)

      expect(page).to have_disabled_button 'Adicionar Responsável'
    end
  end

  scenario 'should all responsible fields disabled when already stored' do
    pending "this test will be removed when there is integration with the accounting system"

    BudgetStructure.make!(:secretaria_de_educacao)

    navigate 'Outros > Contabilidade > Orçamento > Estrutura Organizacional > Estruturas Orçamentarias'

    click_link 'Secretaria de Educação'

    within_tab 'Responsáveis' do
      expect(page).to have_disabled_field 'Responsável'
      expect(page).to have_disabled_field 'Ato regulamentador'
      expect(page).to have_disabled_field 'Data de início'
      expect(page).to have_disabled_field 'Data de término'
      expect(page).to have_disabled_field 'Status'

      expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Ato regulamentador', :with => 'Lei 1234'
      expect(page).to have_field 'Data de início', :with => '01/02/2012'
      expect(page).to have_select 'Status', :selected => 'Ativo'
    end
  end

  scenario 'should store last responsible end_date as Date.current' do
    pending "this test will be removed when there is integration with the accounting system"

    BudgetStructure.make!(:secretaria_de_educacao)
    Employee.make!(:wenderson)

    navigate 'Outros > Contabilidade > Orçamento > Estrutura Organizacional > Estruturas Orçamentarias'

    click_link 'Secretaria de Educação'

    within_tab 'Responsáveis' do
      click_button 'Adicionar Responsável'

      fill_modal 'Responsável', :with => '12903412', :field => 'Matrícula'
      fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'
      fill_in 'Data de início', :with => I18n.l(Date.current)
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Estrutura Orçamentaria editada com sucesso.'

    click_link 'Secretaria de Educação'

    within_tab 'Responsáveis' do
      within 'fieldset:nth-child(2)' do
        expect(page).to have_field 'Data de término', :with => I18n.l(Date.current)
      end
    end
  end

  scenario 'should store last responsible end_date as Date.current when already have 2 responsibles' do
    pending "this test will be removed when there is integration with the accounting system"

    BudgetStructure.make!(:secretaria_de_educacao_com_dois_responsaveis)
    Employee.make!(:joao_da_silva)

    navigate 'Outros > Contabilidade > Orçamento > Estrutura Organizacional > Estruturas Orçamentarias'

    click_link 'Secretaria de Educação com dois responsaveis'

    within_tab 'Responsáveis' do
      click_button 'Adicionar Responsável'

      fill_modal 'Responsável', :with => '21430921', :field => 'Matrícula'
      fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'
      fill_in 'Data de início', :with => I18n.l(Date.current)
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Estrutura Orçamentaria editada com sucesso.'

    click_link 'Secretaria de Educação com dois responsaveis'

    within_tab 'Responsáveis' do
      within 'fieldset:nth-child(1)' do
        expect(page).to have_field 'Data de término', :with => ''
      end

      within 'fieldset:nth-child(2)' do
        expect(page).to have_field 'Data de término', :with => I18n.l(Date.current)
      end

      within 'fieldset:nth-child(3)' do
        expect(page).to have_field 'Data de término', :with => '01/04/2012'
      end
    end
  end

  scenario 'when have errors on new responsible should show first new responsible and should not set end_date' do
    pending "this test will be removed when there is integration with the accounting system"

    BudgetStructure.make!(:secretaria_de_educacao)
    Employee.make!(:wenderson)

    navigate 'Outros > Contabilidade > Orçamento > Estrutura Organizacional > Estruturas Orçamentarias'

    click_link 'Secretaria de Educação'

    within_tab 'Responsáveis' do
      click_button 'Adicionar Responsável'
      fill_in 'Data de início', :with => I18n.l(Date.current)
    end

    click_button 'Salvar'

    within_tab 'Responsáveis' do
      within 'fieldset:nth-child(1)' do
        expect(page).to have_content 'não pode ficar em branco'
      end

      within 'fieldset:nth-child(2)' do
        expect(page).to have_field 'Data de término', :with => ''
      end
    end
  end

  scenario 'when update budget_structure without add new responsible should not set end_date' do
    pending "this test will be removed when there is integration with the accounting system"

    BudgetStructure.make!(:secretaria_de_educacao)

    navigate 'Outros > Contabilidade > Orçamento > Estrutura Organizacional > Estruturas Orçamentarias'

    click_link 'Secretaria de Educação'

    within_tab 'Informações' do
      fill_in 'Código', :with => '2'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Estrutura Orçamentaria editada com sucesso.'

    click_link 'Secretaria de Educação'

    within_tab 'Responsáveis' do
      expect(page).to have_field 'Data de término', :with => ''
    end
  end
end
