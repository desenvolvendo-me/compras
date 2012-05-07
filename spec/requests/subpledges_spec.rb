# encoding: utf-8
require 'spec_helper'

feature "SubPledges" do
  background do
    sign_in
  end

  scenario 'create a new subpledge' do
    Entity.make!(:detran)
    pledge = Pledge.make!(:empenho)
    Provider.make!(:wenderson_sa)

    click_link 'Contabilidade'

    click_link 'Subempenhos'

    click_link 'Criar Subempenho'

    within_tab 'Principal' do
      fill_modal 'Entidade', :with => 'Detran'
      fill_in 'Ano', :with => '2012'
      fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
      fill_in 'Número do processo', :with => '1239/2012'
      fill_modal 'Fornecedor *', :with => '456789', :field => 'CRC'
      fill_in 'Data *', :with => I18n.l(Date.current)
      fill_in 'Valor *', :with => '1,00'
      fill_in 'Objeto', :with => 'Aquisição de materiais'
    end

    click_button 'Salvar'

    page.should have_notice 'Subempenho criado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      page.should have_field 'Entidade', :with => 'Detran'
      page.should have_disabled_field 'Fornecedor do empenho'
      page.should have_field 'Fornecedor do empenho', :with => 'Wenderson Malheiros'
      page.should have_disabled_field 'Data de emissão'
      page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
      page.should have_disabled_field 'Valor do empenho'
      page.should have_field 'Valor do empenho', :with => '9,99'
      page.should have_disabled_field 'Saldo a subempenhar'
      page.should have_field 'Saldo a subempenhar', :with => '9,99'
      page.should have_field 'Ano', :with => '2012'
      page.should have_field 'Empenho', :with => "#{pledge.id}"
      page.should have_field 'Subempenho', :with => '1'
      page.should have_field 'Número do processo', :with => '1239/2012'
      page.should have_field 'Fornecedor *', :with => 'Wenderson Malheiros'
      page.should have_field 'Data *', :with => I18n.l(Date.current)
      page.should have_field 'Valor *', :with => '1,00'
      page.should have_field 'Objeto', :with => 'Aquisição de materiais'
    end

    within_tab 'Vencimentos' do
      page.should have_content '1'
      page.should have_content I18n.l(Date.current + 1.day)
      page.should have_content '9,99'
    end
  end

  scenario 'set sequencial subpledge expiration number' do
    click_link 'Contabilidade'

    click_link 'Subempenhos'

    click_link 'Criar Subempenho'

    within_tab 'Vencimentos' do
      click_button 'Adicionar Parcela'

      within '.subpledge-expiration:first' do
        page.should have_field 'Número', :with => '1'
      end

      click_button 'Adicionar Parcela'

      within '.subpledge-expiration:last' do
        page.should have_field 'Número', :with => '2'
      end

      within '.subpledge-expiration:first' do
        click_button 'Remover Parcela'
      end

      within '.subpledge-expiration:last' do
        page.should have_field 'Número', :with => '1'
      end
    end
  end

  scenario 'validate subpledge_expiration value sum' do
    click_link 'Contabilidade'

    click_link 'Subempenhos'

    click_link 'Criar Subempenho'

    within_tab 'Principal' do
      fill_in 'Valor *', :with => '10,00'
    end

    within_tab 'Vencimentos' do
      click_button 'Adicionar Parcela'

      within '.subpledge-expiration:first' do
        fill_in 'Valor *', :with => '100,00'
      end
    end

    click_button 'Salvar'

    within_tab 'Vencimentos' do
      within '.subpledge-expiration:first' do
        page.should have_content 'a soma de todos os valores não pode ser maior o valor do subempenho'
      end
    end
  end

  scenario 'should not validate expiration_date when all pledge_parcel dont have balance' do
    Pledge.make!(:empenho_em_quinze_dias)
    pledge_parcel = PledgeParcel.make!(:vencimento_para_empenho_em_quinze_dias)
    PledgeCancellation.make!(:cancelamento_para_empenho_em_quinze_dias)

    click_link 'Contabilidade'

    click_link 'Subempenhos'

    click_link 'Criar Subempenho'

    within_tab 'Principal' do
      fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
    end

    within_tab 'Vencimentos' do
      click_button 'Adicionar Parcela'

      within '.subpledge-expiration:first' do
        fill_in 'Vencimento', :with => I18n.l(Date.current + 18.days)
      end
    end

    click_button 'Salvar'

    within_tab 'Vencimentos' do
      within '.subpledge-expiration:first' do
        page.should_not have_content "não pode ser superior ao vencimento da primeira parcela do empenho com saldo disponível (#{I18n.l(pledge_parcel.expiration_date)})"
      end
    end
  end

  scenario 'validate expiration_date based on first pledge_parcel available' do
    Pledge.make!(:empenho_em_quinze_dias)
    pledge_parcel = PledgeParcel.make!(:vencimento_para_empenho_em_quinze_dias)

    click_link 'Contabilidade'

    click_link 'Subempenhos'

    click_link 'Criar Subempenho'

    within_tab 'Principal' do
      fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
    end

    within_tab 'Vencimentos' do
      click_button 'Adicionar Parcela'

      within '.subpledge-expiration:first' do
        fill_in 'Vencimento', :with => I18n.l(Date.current + 18.days)
      end
    end

    click_button 'Salvar'

    within_tab 'Vencimentos' do
      within '.subpledge-expiration:first' do
        page.should have_content "não pode ser superior ao vencimento da primeira parcela do empenho com saldo disponível (#{I18n.l(pledge_parcel.expiration_date)})"
      end
    end
  end

  scenario 'when fill/clear pledge should update expiration tab' do
    Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Subempenhos'

    click_link 'Criar Subempenho'

    within_tab 'Principal' do
      fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
    end

    within_tab 'Vencimentos' do
      page.should have_content I18n.l(Date.current + 1.day)
      page.should have_content '9,99'
    end

    within_tab 'Principal' do
      clear_modal 'Empenho'
    end

    within_tab 'Vencimentos' do
      page.should_not have_content I18n.l(Date.current + 1.day)
      page.should_not have_content '9,99'
    end
  end

  scenario 'should fill modal only to pledge as pledge_type as global or estimated' do
    Pledge.make!(:empenho)
    Pledge.make!(:empenho_ordinario)
    Pledge.make!(:empenho_estimativo)

    click_link 'Contabilidade'

    click_link 'Subempenhos'

    click_link 'Criar Subempenho'

    within_tab 'Principal' do
      within_modal 'Empenho' do
        click_button 'Pesquisar'

        page.should have_content '2012'
        page.should have_content '2011'
        page.should_not have_content '2010'
      end
    end
  end

  scenario 'should fill pledge related fields with fill pledge' do
    Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Subempenhos'

    click_link 'Criar Subempenho'

    within_tab 'Principal' do
      page.should have_disabled_field 'Fornecedor do empenho'
      page.should have_disabled_field 'Data de emissão'
      page.should have_disabled_field 'Valor do empenho'
      page.should have_disabled_field 'Saldo a subempenhar'

      fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
      page.should have_field 'Fornecedor do empenho', :with => 'Wenderson Malheiros'
      page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
      page.should have_field 'Valor do empenho', :with => '9,99'
      page.should have_field 'Saldo a subempenhar', :with => '9,99'
      page.should have_field 'Fornecedor *', :with => 'Wenderson Malheiros'
      page.should have_field 'Objeto *', :with => 'Descricao'
      page.should have_field 'Valor *', :with => '9,99'

      clear_modal 'Empenho'
      page.should have_field 'Fornecedor do empenho', :with => ''
      page.should have_field 'Data de emissão', :with => ''
      page.should have_field 'Valor do empenho', :with => ''
      page.should have_field 'Saldo a subempenhar', :with => ''
    end
  end

  scenario 'should have all fields disabled when edit subpledge' do
    pledge = Pledge.make!(:empenho)
    subpledge = Subpledge.make!(:empenho_2012)

    click_link 'Contabilidade'

    click_link 'Subempenhos'

    click_link subpledge.to_s

    should_not have_button 'Atualizar Anulação de Empenho'

    within_tab 'Principal' do
      page.should have_disabled_field 'Entidade'
      page.should have_field 'Entidade', :with => 'Detran'
      page.should have_disabled_field 'Ano'
      page.should have_field 'Ano', :with => '2012'
      page.should have_disabled_field 'Empenho'
      page.should have_field 'Empenho', :with => "#{pledge.id}"
      page.should have_disabled_field 'Número do processo'
      page.should have_field 'Número do processo', :with => '1239/2012'
      page.should have_disabled_field 'Fornecedor'
      page.should have_field 'Fornecedor', :with => 'Wenderson Malheiros'
      page.should have_disabled_field 'Data'
      page.should have_field 'Data', :with => I18n.l(Date.current)
      page.should have_disabled_field 'Valor'
      page.should have_field 'Valor', :with => '1,00'
      page.should have_disabled_field 'Objeto'
      page.should have_field 'Objeto', :with => 'Aquisição de material'
    end
  end

  scenario 'should not have a button to destroy an existent pledge' do
    subpledge = Subpledge.make!(:empenho_2012)

    click_link 'Contabilidade'

    click_link 'Subempenhos'

    click_link subpledge.to_s

    page.should_not have_link 'Apagar'
  end
end
