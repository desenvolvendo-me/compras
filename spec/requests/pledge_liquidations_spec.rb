# encoding: utf-8
require 'spec_helper'

feature "PledgeLiquidations" do
  background do
    sign_in
  end

  scenario 'create a new pledge_liquidation' do
    pledge = Pledge.make!(:empenho_com_dois_vencimentos)

    navigate 'Contabilidade > Execução > Empenho > Liquidações de Empenhos'

    click_link 'Criar Liquidação de Empenho'

    within_tab 'Principal' do
      fill_modal 'Empenho', :with => pledge.code.to_s, :field => 'Código'
      fill_in 'Valor a ser liquidado', :with => '150,00'
      fill_in 'Data *', :with => I18n.l(Date.tomorrow)
      fill_in 'Objeto do empenho', :with => 'Para empenho 2012'
    end

    within_tab 'Parcelas' do
      click_button 'Adicionar Parcela'

      fill_in 'Valor *', :with => '150,00'
    end

    click_button 'Salvar'

    page.should have_notice 'Liquidação de Empenho criado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      page.should have_field 'Empenho', :with => pledge.to_s
      page.should have_disabled_field 'Data de emissão'
      page.should have_field 'Data de emissão', :with => I18n.l(Date.current)

      page.find('#pledge_value').should have_content 'R$ 200,00'
      page.find('#pledge_liquidations_sum').should have_content 'R$ 150,00'
      page.find('#pledge_cancellations_sum').should have_content 'R$ 0,00'
      page.find('#pledge_balance').should have_content 'R$ 50,00'

      page.should have_field 'Valor a ser liquidado', :with => '150,00'
      page.should have_field 'Data *', :with => I18n.l(Date.tomorrow)
      page.should have_field 'Objeto do empenho', :with => 'Para empenho 2012'
    end

    within_tab 'Parcelas' do
      page.should have_field 'Parcela', :with => '1'
      page.should have_field 'Valor *', :with => '150,00'
    end
  end


  scenario 'set sequencial parcel number' do
    navigate 'Contabilidade > Execução > Empenho > Liquidações de Empenhos'

    click_link 'Criar Liquidação de Empenho'

    within_tab 'Parcelas' do
      click_button 'Adicionar Parcela'

      within '.parcel:first' do
        page.should have_field 'Parcela', :with => '1'
      end

      click_button 'Adicionar Parcela'

      within '.parcel:last' do
        page.should have_field 'Parcela', :with => '2'
      end

      within '.parcel:first' do
        click_button 'Remover Parcela'
      end

      within '.parcel:last' do
        page.should have_field 'Parcela', :with => '1'
      end
    end
  end

  scenario 'should validate total parcels sum' do
    navigate 'Contabilidade > Execução > Empenho > Liquidações de Empenhos'

    click_link 'Criar Liquidação de Empenho'

    within_tab 'Principal' do
      fill_in 'Valor a ser liquidado', :with => '100,00'
    end

    within_tab 'Parcelas' do
      click_button 'Adicionar Parcela'

      fill_in 'Valor *', :with => '80,00'
    end

    click_button 'Salvar'

    within_tab 'Parcelas' do
      page.should have_content 'deve ser igual ao valor (R$ 100,00)'
    end
  end

  scenario 'should replicate value to parcels tab' do
    navigate 'Contabilidade > Execução > Empenho > Liquidações de Empenhos'

    click_link 'Criar Liquidação de Empenho'

    within_tab 'Principal' do
      fill_in 'Valor a ser liquidado', :with => '100,00'
    end

    page.should have_field 'Valor', :with => '100,00'
  end

  scenario 'replicate value to parcels tab should not have erros' do
    pledge = Pledge.make!(:empenho_com_dois_vencimentos)

    navigate 'Contabilidade > Execução > Empenho > Liquidações de Empenhos'

    click_link 'Criar Liquidação de Empenho'

    within_tab 'Principal' do
      fill_modal 'Empenho', :with => pledge.code.to_s, :field => 'Código'
      fill_in 'Data *', :with => I18n.l(Date.tomorrow)
      fill_in 'Objeto do empenho', :with => 'Para empenho 2012'
    end

    within_tab 'Parcelas' do
      click_button 'Adicionar Parcela'

      fill_in 'Valor *', :with => '150,00'
    end

    click_button 'Salvar'

    within_tab 'Principal' do
      page.should have_content 'não pode ficar em branco'
    end

    within_tab 'Parcelas' do
      page.should_not have_content 'não pode ficar em branco'
    end
  end

  scenario 'when fill/clear pledge should fill/clear delegateds fields' do
    pledge = Pledge.make!(:empenho_com_dois_vencimentos)

    navigate 'Contabilidade > Execução > Empenho > Liquidações de Empenhos'

    click_link 'Criar Liquidação de Empenho'

    within_tab 'Principal' do
      fill_modal 'Empenho', :with => pledge.code.to_s, :field => 'Código'
      page.should have_field 'Empenho', :with => pledge.to_s
      page.should have_disabled_field 'Data de emissão'
      page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
      page.should have_field 'Objeto do empenho', :with => 'Descricao'

      page.find('#pledge_value').should have_content 'R$ 200,00'
      page.find('#pledge_liquidations_sum').should have_content 'R$ 0,00'
      page.find('#pledge_cancellations_sum').should have_content 'R$ 0,00'
      page.find('#pledge_balance').should have_content 'R$ 200,00'

      clear_modal 'Empenho'

      page.should have_field 'Empenho', :with => ''
      page.should have_disabled_field 'Data de emissão'
      page.should have_field 'Data de emissão', :with => ''
    end
  end

  scenario 'should have all disabled fields when edit existent pledge_liquidation' do
    pledge = Pledge.make!(:empenho)
    pledge_liquidation = PledgeLiquidation.make!(:empenho_2012)

    navigate 'Contabilidade > Execução > Empenho > Liquidações de Empenhos'

    click_link pledge_liquidation.to_s

    should_not have_button 'Criar Liquidação de Empenho'

    within_tab 'Principal' do
      page.should have_field 'Empenho', :with => pledge.to_s
      page.should have_disabled_field 'Data de emissão'
      page.should have_field 'Data de emissão', :with => I18n.l(Date.current)

      page.should have_field 'Valor a ser liquidado', :with => '1,00'
      page.should have_field 'Data *', :with => I18n.l(Date.tomorrow)
      page.should have_disabled_field 'Objeto do empenho'
      page.should have_field 'Objeto do empenho', :with => 'Para empenho 2012'
    end

    within_tab 'Parcelas' do
      page.should have_disabled_field 'Parcela'
      page.should have_field 'Parcela', :with => '1'
      page.should have_disabled_field 'Valor *'
      page.should have_field 'Valor *', :with => '1,00'

      page.should_not have_button 'Adicionar Parcela'
      page.should_not have_button 'Remover Parcela'
    end
  end

  scenario 'should not have a button to destroy an existent pledge_liquidation' do
    Pledge.make!(:empenho)
    pledge_liquidation = PledgeLiquidation.make!(:empenho_2012)

    navigate 'Contabilidade > Execução > Empenho > Liquidações de Empenhos'

    click_link pledge_liquidation.to_s

    page.should_not have_link 'Apagar'
  end

  scenario 'should not have a annul link when was creating a new solicitation' do
    navigate 'Contabilidade > Execução > Empenho > Liquidações de Empenho'

    click_link 'Criar Liquidação de Empenho'

    page.should_not have_link 'Anular'
    page.should_not have_link 'Anulação'
  end

  context 'filtering' do
    scenario 'filter by pledge' do
      pledge = Pledge.make!(:empenho)
      liquidation_2012 = PledgeLiquidation.make!(:empenho_2012)
      liquidation_other = PledgeLiquidation.make!(:liquidacao_para_dois_vencimentos)

      navigate 'Contabilidade > Execução > Empenho > Liquidações de Empenho'

      click_link 'Filtrar Liquidações de Empenhos'

      within_modal 'Empenho' do
        fill_in 'Código', :with => pledge.code.to_s
        click_button 'Pesquisar'
        click_record pledge.code.to_s
      end

      click_button 'Pesquisar'

      page.should have_content liquidation_2012.id.to_s
      page.should_not have_content liquidation_other.id.to_s
    end

    scenario 'filter by value' do
      liquidation_2012 = PledgeLiquidation.make!(:empenho_2012)
      liquidation_other = PledgeLiquidation.make!(:liquidacao_para_dois_vencimentos)

      navigate 'Contabilidade > Execução > Empenho > Liquidações de Empenho'

      click_link 'Filtrar Liquidações de Empenhos'

      fill_in 'Valor', :with => '1,00'

      click_button 'Pesquisar'

      page.should have_content liquidation_2012.id.to_s
      page.should_not have_content liquidation_other.id.to_s
    end

    scenario 'filter by date' do
      liquidation_2012 = PledgeLiquidation.make!(:empenho_2012)
      liquidation_other = PledgeLiquidation.make!(:empenho_em_15_dias)

      navigate 'Contabilidade > Execução > Empenho > Liquidações de Empenho'

      click_link 'Filtrar Liquidações de Empenhos'

      fill_in 'Data', :with => I18n.l(Date.tomorrow)

      click_button 'Pesquisar'

      page.should have_content liquidation_2012.id.to_s
      page.should_not have_content liquidation_other.id.to_s
    end
  end
end
