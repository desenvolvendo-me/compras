# encoding: utf-8
require 'spec_helper'

feature "PriceRegistration" do
  background do
    sign_in
  end

  scenario 'create a new price_registration' do
    LicitationProcess.make!(:processo_licitatorio)
    LicitationProcess.make!(:processo_licitatorio_canetas)
    DeliveryLocation.make!(:education)
    ManagementUnit.make!(:unidade_central)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)
    BudgetStructure.make!(:secretaria_de_educacao)
    BudgetStructure.make!(:secretaria_de_desenvolvimento)
    BudgetStructure.make!(:secretaria_de_educacao_com_dois_responsaveis)

    navigate 'Compras e Licitações > Registros de Preços'

    click_link 'Criar Registro de Preço'

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2012'
      fill_in 'Data', :with => '05/04/2012'
      fill_in 'Data da validade', :with => '05/04/2013'
      select 'Ativo', :from => 'Situação'
      fill_modal 'Processo licitatório', :with => '2012', :field => 'Ano'
      fill_in 'Objeto', :with => 'Aquisição de combustíveis'
      fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      fill_modal 'Unidade gestora', :with => 'Unidade Central', :field => 'Descrição'

      within_modal 'Responsável' do
        fill_modal 'Pessoa', :with => 'Gabriel Sobrinho'

        click_button 'Pesquisar'

        click_record 'Gabriel Sobrinho'
      end

      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Entrega', :with => '1'
      select 'mês/meses', :from => 'Período da entrega'
      fill_in 'Validade', :with => '2'
      select 'ano/anos', :from => 'Período da validade'
      fill_in 'Observações', :with => 'Aquisição de combustíveis'
    end

    within_tab 'Itens por Estruturas Orçamentárias Participantes' do
      click_button 'Adicionar Material'

      fill_modal 'Material', :with => 'Antivirus', :field => 'Material'

      click_button 'Adicionar Dotação'

      fill_modal 'Estrutura orçamentária', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_in 'Quantidade solicitada', :with => '100,00'

      click_button 'Adicionar Dotação'

      within '.price-registration-budget-structure:first' do
        fill_modal 'Estrutura orçamentária', :with => 'Secretaria de Desenvolvimento', :field => 'Descrição'
        fill_in 'Quantidade solicitada', :with => '200,00'
      end

      click_button 'Adicionar Material'

      within 'div.price-registration-item:first' do
        fill_modal 'Material', :with => 'Arame comum', :field => 'Material'

        click_button 'Adicionar Dotação'

        fill_modal 'Estrutura orçamentária', :with => 'Secretaria de Educação com dois responsaveis', :field => 'Descrição'
        fill_in 'Quantidade solicitada', :with => '300,00'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Registro de Preço criado com sucesso.'

    click_link '1/2012'

    within_tab 'Principal' do
      expect(page).to have_field 'Número', :with => '1'
      expect(page).to have_field 'Ano', :with => '2012'
      expect(page).to have_field 'Data', :with => '05/04/2012'
      expect(page).to have_field 'Data da validade', :with => '05/04/2013'
      expect(page).to have_select 'Situação', :selected => 'Ativo'
      expect(page).to have_field 'Processo licitatório', :with => '1/2012'
      expect(page).to have_field 'Objeto', :with => 'Aquisição de combustíveis'
      expect(page).to have_field 'Local de entrega', :with => 'Secretaria da Educação'
      expect(page).to have_field 'Unidade gestora', :with => 'Unidade Central'
      expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Forma de pagamento', :with => 'Dinheiro'
      expect(page).to have_field 'Entrega', :with => '1'
      expect(page).to have_select 'Período da entrega', :selected => 'mês/meses'
      expect(page).to have_field 'Validade', :with => '2'
      expect(page).to have_select 'Período da validade', :selected => 'ano/anos'
      expect(page).to have_field 'Observações', :with => 'Aquisição de combustíveis'
    end

    within_tab 'Itens por Estruturas Orçamentárias Participantes' do

      within 'div.price-registration-item:last' do
        expect(page).to have_field 'Material', :with => '01.01.00001 - Antivirus'
        expect(page).to have_field 'Estrutura orçamentária', :with => '1.2 - Secretaria de Desenvolvimento', :field => 'Descrição'
        expect(page).to have_field 'Quantidade solicitada', :with => '200,00'
        expect(page).to have_select 'Carona', :selected => 'Não'

        within 'div.price-registration-budget-structure:last' do
          expect(page).to have_field 'Estrutura orçamentária', :with => '1 - Secretaria de Educação'
          expect(page).to have_field 'Quantidade solicitada', :with => '100,00'
          expect(page).to have_select 'Carona', :selected => 'Não'
        end
      end

      within 'div.price-registration-item:first' do
        expect(page).to have_field 'Material', :with => '02.02.00002 - Arame comum'
        expect(page).to have_field 'Estrutura orçamentária', :with => '1 - Secretaria de Educação com dois responsaveis', :field => 'Descrição'
        expect(page).to have_field 'Quantidade solicitada', :with => '300,00'
        expect(page).to have_select 'Carona', :selected => 'Não'
      end
    end
  end

  scenario 'update an existent price_registration' do
    PriceRegistration.make!(:registro_de_precos)

    navigate 'Compras e Licitações > Registros de Preços'

    click_link '1/2012'

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2013'
      fill_in 'Data', :with => '05/04/2013'
      fill_in 'Data da validade', :with => '05/04/2014'
      select 'Ativo', :from => 'Situação'
      fill_modal 'Processo licitatório', :with => '2012', :field => 'Ano'
      fill_in 'Objeto', :with => 'Aquisição de combustíveis'
      fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      fill_modal 'Unidade gestora', :with => 'Unidade Central', :field => 'Descrição'

      within_modal 'Responsável' do
        fill_modal 'Pessoa', :with => 'Gabriel Sobrinho'

        click_button 'Pesquisar'

        click_record 'Gabriel Sobrinho'
      end

      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Entrega', :with => '2'
      select 'mês/meses', :from => 'Período da entrega'
      fill_in 'Validade', :with => '3'
      select 'ano/anos', :from => 'Período da validade'
      fill_in 'Observações', :with => 'Aquisição de carne'
    end

    within_tab 'Itens por Estruturas Orçamentárias Participantes' do
      fill_in 'Quantidade solicitada', :with => '400,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Registro de Preço editado com sucesso.'

    click_link '1/2013'

    within_tab 'Principal' do
      expect(page).to have_field 'Número', :with => '1'
      expect(page).to have_field 'Ano', :with => '2013'
      expect(page).to have_field 'Data', :with => '05/04/2013'
      expect(page).to have_field 'Data da validade', :with => '05/04/2014'
      expect(page).to have_select 'Situação', :selected => 'Ativo'
      expect(page).to have_field 'Processo licitatório', :with => '1/2012'
      expect(page).to have_field 'Objeto', :with => 'Aquisição de combustíveis'
      expect(page).to have_field 'Local de entrega', :with => 'Secretaria da Educação'
      expect(page).to have_field 'Unidade gestora', :with => 'Unidade Central'
      expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Forma de pagamento', :with => 'Dinheiro'
      expect(page).to have_field 'Entrega', :with => '2'
      expect(page).to have_select 'Período da entrega', :selected => 'mês/meses'
      expect(page).to have_field 'Validade', :with => '3'
      expect(page).to have_select 'Período da validade', :selected => 'ano/anos'
      expect(page).to have_field 'Observações', :with => 'Aquisição de carne'
    end

    within_tab 'Itens por Estruturas Orçamentárias Participantes' do
      expect(page).to have_field 'Material', :with => '01.01.00001 - Antivirus'
      expect(page).to have_field 'Estrutura orçamentária', :with => '1 - Secretaria de Educação'
      expect(page).to have_field 'Quantidade solicitada', :with => '400,00'
      expect(page).to have_select 'Carona', :selected => 'Não'

      within 'div.price-registration-budget-structure:last' do
        expect(page).to have_field 'Estrutura orçamentária', :with => '1.2 - Secretaria de Desenvolvimento', :field => 'Descrição'
        expect(page).to have_field 'Quantidade solicitada', :with => '200,00'
        expect(page).to have_select 'Carona', :selected => 'Não'
      end
    end
  end

  scenario 'destroy an existent price-registration' do
    PriceRegistration.make!(:registro_de_precos)

    navigate 'Compras e Licitações > Registros de Preços'

    click_link '1/2012'

    click_link 'Apagar'

    expect(page).to have_notice 'Registro de Preço apagado com sucesso.'

    expect(page).to_not have_content '1'
    expect(page).to_not have_content '05/04/2012'
    expect(page).to_not have_content 'Aquisição de combustíveis'
  end

  scenario 'licitation process modal should list only records with price_registrations' do
    LicitationProcess.make!(:processo_licitatorio)
    LicitationProcess.make!(:processo_licitatorio_computador)

    navigate 'Compras e Licitações > Registros de Preços'

    click_link 'Criar Registro de Preço'

    within_tab 'Principal' do
      within_modal 'Processo licitatório' do
        click_button 'Pesquisar'

        within_records do
          expect(page).to_not have_content '2013'
          expect(page).to_not have_content '2/2013'

          expect(page).to have_content '2012'
          expect(page).to have_content '1/2012'
        end
      end
    end
  end
end
