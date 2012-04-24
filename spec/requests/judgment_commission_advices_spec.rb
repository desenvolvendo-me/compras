# encoding: utf-8
require 'spec_helper'

feature "JudgmentCommissionAdvices" do
  background do
    sign_in
  end

  scenario 'create a new judgment_commission_advice' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio)
    licitation_commission = LicitationCommission.make!(:comissao)

    click_link 'Processos'

    click_link 'Pareceres das Comissões Julgadoras'

    click_link 'Criar Parecer da Comissão Julgadora'

    within_tab 'Principal' do
      fill_modal 'Processo licitatório', :with => '2012', :field => 'Ano'

      # testing delegated modality and next judgment commission advice number from licitation process
      page.should have_disabled_field 'Modalidade'
      page.should have_field 'Modalidade', :with => 'CV'
      page.should have_disabled_field 'Sequência de julgamento'
      page.should have_field 'Sequência de julgamento', :with => '1'

      fill_in 'Ano', :with => '2012'
      fill_modal 'Comissão julgadora', :with => '20/03/2012', :field => 'Data da nomeação'

      # testing delegated president name from licitation commission
      page.should have_disabled_field 'Presidente da comissão'
      page.should have_field 'Presidente da comissão', :with => 'Wenderson Malheiros'
    end

    click_button 'Criar Parecer da Comissão Julgadora'

    page.should have_notice 'Parecer da Comissão Julgadora criado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      page.should have_field 'Processo licitatório', :with => licitation_process.to_s
      page.should have_disabled_field 'Modalidade'
      page.should have_field 'Modalidade', :with => 'CV'
      page.should have_field 'Número da ata', :with => '1'
      page.should have_field 'Sequência de julgamento', :with => '1'
      page.should have_field 'Ano', :with => '2012'
      page.should have_field 'Comissão julgadora', :with => licitation_commission.to_s
      page.should have_field 'Presidente da comissão', :with => 'Wenderson Malheiros'

      # testing delegated modality from licitation process when cleaning the licitation process
      clear_modal 'Processo licitatório'
      page.should have_field 'Modalidade', :with => ''

      # testing delegated president from licitation commission when cleaning the licitation commission
      clear_modal 'Comissão julgadora'
      page.should have_field 'Presidente da comissão', :with => ''
    end
  end

  scenario 'update an existent judgment_commission_advice' do
    JudgmentCommissionAdvice.make!(:parecer)
    new_licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)
    new_licitation_commission = LicitationCommission.make!(:comissao_nova)

    click_link 'Processos'

    click_link 'Pareceres das Comissões Julgadoras'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      fill_modal 'Processo licitatório', :with => '2013', :field => 'Ano'

      fill_in 'Ano', :with => '2013'
      fill_modal 'Comissão julgadora', :with => '20/04/2012', :field => 'Data da nomeação'
    end

    click_button 'Atualizar Parecer da Comissão Julgadora'

    page.should have_notice 'Parecer da Comissão Julgadora editado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      page.should have_field 'Processo licitatório', :with => new_licitation_process.to_s
      page.should have_field 'Modalidade', :with => 'CV'
      page.should have_field 'Número da ata', :with => '1'
      page.should have_field 'Ano', :with => '2013'
      page.should have_field 'Sequência de julgamento', :with => '1'
      page.should have_field 'Comissão julgadora', :with => new_licitation_commission.to_s
    end
  end

  scenario 'destroy an existent judgment_commission_advice' do
    advice = JudgmentCommissionAdvice.make!(:parecer)

    click_link 'Processos'

    click_link 'Pareceres das Comissões Julgadoras'

    page.should have_link advice.to_s

    within_records do
      page.find('a').click
    end

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Parecer da Comissão Julgadora apagado com sucesso.'

    page.should_not have_link advice.to_s
  end

  scenario 'create another judgment_commission_advice to test the generated minutes number and judgment sequence' do
    JudgmentCommissionAdvice.make!(:parecer)
    LicitationProcess.make!(:processo_licitatorio)
    LicitationCommission.make!(:comissao)

    click_link 'Processos'

    click_link 'Pareceres das Comissões Julgadoras'

    click_link 'Criar Parecer da Comissão Julgadora'

    within_tab 'Principal' do
      fill_modal 'Processo licitatório', :with => '2012', :field => 'Ano'

      fill_in 'Ano', :with => '2012'
      fill_modal 'Comissão julgadora', :with => '20/03/2012', :field => 'Data da nomeação'
    end

    click_button 'Criar Parecer da Comissão Julgadora'

    page.should have_notice 'Parecer da Comissão Julgadora criado com sucesso.'

    click_link JudgmentCommissionAdvice.last.to_s

    within_tab 'Principal' do
      page.should have_field 'Número da ata', :with => '2'
      page.should have_field 'Sequência de julgamento', :with => '2'
    end
  end
end
