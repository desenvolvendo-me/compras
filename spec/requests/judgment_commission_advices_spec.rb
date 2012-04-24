# encoding: utf-8
require 'spec_helper'

feature "JudgmentCommissionAdvices" do
  background do
    sign_in
  end

  scenario 'create a new judgment_commission_advice' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio)
    licitation_commission = LicitationCommission.make!(:comissao)
    Person.make!(:sobrinho)

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

    within_tab 'Membros' do
      click_button 'Adicionar Membro'

      fill_modal 'Membro', :with => 'Gabriel Sobrinho'
      select 'Presidente', :from => 'Função'
      select 'Servidor efetivo', :from => 'Natureza do cargo'
      fill_in 'Matrícula', :with => '3456789'
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

    within_tab 'Membros' do
      page.should have_field 'Membro', :with => 'Gabriel Sobrinho'
      page.should have_select 'Função', :selected => 'Presidente'
      page.should have_select 'Natureza do cargo', :selected => 'Servidor efetivo'
      page.should have_field 'Matrícula', :with => '3456789'
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

    within_tab 'Membros' do
      click_button 'Adicionar Membro'

      within '.member:last' do
        fill_modal 'Membro', :with => 'Gabriel Sobrinho'
        select 'Apoio', :from => 'Função'
        select 'Outros', :from => 'Natureza do cargo'
        fill_in 'Matrícula', :with => '987654'
      end
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

    within_tab 'Membros' do
      within '.member:last' do
        page.should have_field 'Membro', :with => 'Gabriel Sobrinho'
        page.should have_select 'Função', :selected => 'Apoio'
        page.should have_select 'Natureza do cargo', :selected => 'Outros'
        page.should have_field 'Matrícula', :with => '987654'
      end
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

  scenario 'asserting that duplicated individuals on members can not be saved' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio)
    licitation_commission = LicitationCommission.make!(:comissao)
    Person.make!(:sobrinho)

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

    within_tab 'Membros' do
      click_button 'Adicionar Membro'

      fill_modal 'Membro', :with => 'Gabriel Sobrinho'
      select 'Presidente', :from => 'Função'
      select 'Servidor efetivo', :from => 'Natureza do cargo'
      fill_in 'Matrícula', :with => '3456789'

      click_button 'Adicionar Membro'

      within '.member:last' do
        fill_modal 'Membro', :with => 'Gabriel Sobrinho'
        select 'Apoio', :from => 'Função'
        select 'Outros', :from => 'Natureza do cargo'
        fill_in 'Matrícula', :with => '987654'
      end
    end

    click_button 'Criar Parecer da Comissão Julgadora'

    within_tab 'Membros' do
      page.should have_content 'já está em uso'
    end
  end

  scenario 'should get the CPF number when selecting individual' do
    Person.make!(:wenderson)

    click_link 'Processos'

    click_link 'Pareceres das Comissões Julgadoras'

    click_link 'Criar Parecer da Comissão Julgadora'

    within_tab 'Membros' do
      click_button 'Adicionar Membro'

      fill_modal 'Membro', :with => 'Wenderson Malheiros'

      page.should have_disabled_field 'CPF'
      page.should have_field 'CPF', :with => '003.149.513-34'

      clear_modal 'Membro'
      page.should have_disabled_field 'CPF'
      page.should have_field 'CPF', :with => ''
    end
  end
end
