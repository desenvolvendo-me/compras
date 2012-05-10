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
    Person.make!(:wenderson)

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

      fill_mask 'Ano', :with => '2012'
      fill_modal 'Comissão julgadora', :with => '20/03/2012', :field => 'Data da nomeação'

      # testing delegated president name from licitation commission
      page.should have_disabled_field 'Presidente da comissão'
      page.should have_field 'Presidente da comissão', :with => 'Wenderson Malheiros'
    end

    within_tab 'Membros' do
      # Verifying member that comes from Licitation Commission
      page.should have_disabled_field 'Membro'
      page.should have_disabled_field 'CPF'
      page.should have_disabled_field 'Função'
      page.should have_disabled_field 'Natureza do cargo'
      page.should have_disabled_field 'Matrícula'

      page.should have_field 'Membro', :with => 'Wenderson Malheiros'
      page.should have_field 'CPF', :with => '003.149.513-34'
      page.should have_field 'Função', :with => 'Presidente'
      page.should have_field 'Natureza do cargo', :with => 'Servidor efetivo'
      page.should have_field 'Matrícula', :with => '38'

      click_button 'Adicionar Membro'

      within '.member:first' do
        fill_modal 'Membro', :with => 'Gabriel Sobrinho'
        select 'Presidente', :from => 'Função'
        select 'Servidor efetivo', :from => 'Natureza do cargo'
        fill_in 'Matrícula', :with => '3456789'
      end
    end

    within_tab 'Parecer' do
      fill_mask "Data do início do julgamento", :with => "20/01/2012"
      fill_mask "Hora do início do julgamento", :with => "12:00"
      fill_mask "Data do fim do julgamento", :with => "21/01/2012"
      fill_mask "Hora do fim do julgamento", :with => "13:00"
      fill_in "Texto da ata sobre as empresas licitantes", :with => "texto 1"
      fill_in "Texto da ata sobre documentação das empresas licitantes", :with => "texto 2"
      fill_in "Texto da ata sobre julgamento das propostas / justificativas", :with => "texto 3"
      fill_in "Texto da ata sobre julgamento - pareceres diversos", :with => "texto 4"
    end

    click_button 'Salvar'

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
    end

    within_tab 'Membros' do
      # Verifying member that comes from Licitation Commission
      page.should have_disabled_field 'Membro'
      page.should have_disabled_field 'CPF'
      page.should have_disabled_field 'Função'
      page.should have_disabled_field 'Natureza do cargo'
      page.should have_disabled_field 'Matrícula'

      page.should have_field 'Membro', :with => 'Wenderson Malheiros'
      page.should have_field 'CPF', :with => '003.149.513-34'
      page.should have_field 'Função', :with => 'Presidente'
      page.should have_field 'Natureza do cargo', :with => 'Servidor efetivo'
      page.should have_field 'Matrícula', :with => '38'

      within '.member:last' do
        page.should have_field 'Membro', :with => 'Gabriel Sobrinho'
        page.should have_select 'Função', :selected => 'Presidente'
        page.should have_select 'Natureza do cargo', :selected => 'Servidor efetivo'
        page.should have_field 'Matrícula', :with => '3456789'
      end
    end

    within_tab 'Parecer' do
      page.should have_field "Data do início do julgamento", :with => "20/01/2012"
      page.should have_field "Hora do início do julgamento", :with => "12:00"
      page.should have_field "Data do fim do julgamento", :with => "21/01/2012"
      page.should have_field "Hora do fim do julgamento", :with => "13:00"
      page.should have_field "Texto da ata sobre as empresas licitantes", :with => "texto 1"
      page.should have_field "Texto da ata sobre documentação das empresas licitantes", :with => "texto 2"
      page.should have_field "Texto da ata sobre julgamento das propostas / justificativas", :with => "texto 3"
      page.should have_field "Texto da ata sobre julgamento - pareceres diversos", :with => "texto 4"
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

      fill_mask 'Ano', :with => '2013'
      fill_modal 'Comissão julgadora', :with => '20/04/2012', :field => 'Data da nomeação'
    end

    within_tab 'Membros' do
      page.should have_field 'Membro', :with => 'Gabriel Sobrinho'

      within '.member:last' do
        page.should have_field 'Membro', :with => 'Wenderson Malheiros'

        click_button 'Remover'
      end
    end

    within_tab 'Parecer' do
      fill_mask "Data do início do julgamento", :with => "20/01/2013"
      fill_mask "Hora do início do julgamento", :with => "14:00"
      fill_mask "Data do fim do julgamento", :with => "21/01/2013"
      fill_mask "Hora do fim do julgamento", :with => "15:00"
      fill_in "Texto da ata sobre as empresas licitantes", :with => "novo texto 1"
      fill_in "Texto da ata sobre documentação das empresas licitantes", :with => "novo texto 2"
      fill_in "Texto da ata sobre julgamento das propostas / justificativas", :with => "novo texto 3"
      fill_in "Texto da ata sobre julgamento - pareceres diversos", :with => "novo texto 4"
    end

    click_button 'Salvar'

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
      page.should_not have_field 'Membro', :with => 'Wenderson Malheiros'
      page.should have_field 'Membro', :with => 'Gabriel Sobrinho'
    end

    within_tab 'Parecer' do
      page.should have_field "Data do início do julgamento", :with => "20/01/2013"
      page.should have_field "Hora do início do julgamento", :with => "14:00"
      page.should have_field "Data do fim do julgamento", :with => "21/01/2013"
      page.should have_field "Hora do fim do julgamento", :with => "15:00"
      page.should have_field "Texto da ata sobre as empresas licitantes", :with => "novo texto 1"
      page.should have_field "Texto da ata sobre documentação das empresas licitantes", :with => "novo texto 2"
      page.should have_field "Texto da ata sobre julgamento das propostas / justificativas", :with => "novo texto 3"
      page.should have_field "Texto da ata sobre julgamento - pareceres diversos", :with => "novo texto 4"
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

      fill_mask 'Ano', :with => '2012'
      fill_modal 'Comissão julgadora', :with => '20/03/2012', :field => 'Data da nomeação'
    end

    within_tab 'Parecer' do
      fill_mask "Data do início do julgamento", :with => "20/01/2012"
      fill_mask "Hora do início do julgamento", :with => "12:00"
      fill_mask "Data do fim do julgamento", :with => "21/01/2012"
      fill_mask "Hora do fim do julgamento", :with => "13:00"
      fill_in "Texto da ata sobre as empresas licitantes", :with => "texto 1"
      fill_in "Texto da ata sobre documentação das empresas licitantes", :with => "texto 2"
      fill_in "Texto da ata sobre julgamento das propostas / justificativas", :with => "texto 3"
      fill_in "Texto da ata sobre julgamento - pareceres diversos", :with => "texto 4"
    end

    click_button 'Salvar'

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
    Person.make!(:wenderson)

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

      fill_mask 'Ano', :with => '2012'
      fill_modal 'Comissão julgadora', :with => '20/03/2012', :field => 'Data da nomeação'

      # testing delegated president name from licitation commission
      page.should have_disabled_field 'Presidente da comissão'
      page.should have_field 'Presidente da comissão', :with => 'Wenderson Malheiros'
    end

    within_tab 'Membros' do
      click_button 'Adicionar Membro'

      within '.member:first' do
        fill_modal 'Membro', :with => 'Gabriel Sobrinho'
        select 'Presidente', :from => 'Função'
        select 'Servidor efetivo', :from => 'Natureza do cargo'
        fill_in 'Matrícula', :with => '3456789'
      end

      click_button 'Adicionar Membro'

      within '.member:first' do
        fill_modal 'Membro', :with => 'Gabriel Sobrinho'
        select 'Apoio', :from => 'Função'
        select 'Outros', :from => 'Natureza do cargo'
        fill_in 'Matrícula', :with => '987654'
      end
    end

    within_tab 'Parecer' do
      fill_mask "Data do início do julgamento", :with => "20/01/2012"
      fill_mask "Hora do início do julgamento", :with => "12:00"
      fill_mask "Data do fim do julgamento", :with => "21/01/2012"
      fill_mask "Hora do fim do julgamento", :with => "13:00"
      fill_in "Texto da ata sobre as empresas licitantes", :with => "texto 1"
      fill_in "Texto da ata sobre documentação das empresas licitantes", :with => "texto 2"
      fill_in "Texto da ata sobre julgamento das propostas / justificativas", :with => "texto 3"
      fill_in "Texto da ata sobre julgamento - pareceres diversos", :with => "texto 4"
    end

    click_button 'Salvar'

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

  scenario 'should clean delegated fields and inherited members when cleaning modal fileds' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio)
    licitation_commission = LicitationCommission.make!(:comissao)
    Person.make!(:sobrinho)
    Person.make!(:wenderson)

    click_link 'Processos'

    click_link 'Pareceres das Comissões Julgadoras'

    click_link 'Criar Parecer da Comissão Julgadora'

    within_tab 'Principal' do
      fill_modal 'Processo licitatório', :with => '2012', :field => 'Ano'

      # testing delegated modality and next judgment commission advice number from licitation process
      page.should have_field 'Modalidade', :with => 'CV'
      page.should have_field 'Sequência de julgamento', :with => '1'

      # removing licitation process
      clear_modal 'Processo licitatório'
      page.should have_field 'Modalidade', :with => ''
      page.should have_field 'Sequência de julgamento', :with => ''

      fill_modal 'Comissão julgadora', :with => '20/03/2012', :field => 'Data da nomeação'

      # testing delegated president name from licitation commission
      page.should have_field 'Presidente da comissão', :with => 'Wenderson Malheiros'
    end

    within_tab 'Membros' do
      # Verifying member that comes from Licitation Commission
      page.should have_field 'Membro', :with => 'Wenderson Malheiros'
      page.should have_field 'CPF', :with => '003.149.513-34'
      page.should have_field 'Função', :with => 'Presidente'
      page.should have_field 'Natureza do cargo', :with => 'Servidor efetivo'
      page.should have_field 'Matrícula', :with => '38'
    end

    within_tab 'Principal' do
      clear_modal 'Comissão julgadora'
    end

    within_tab 'Membros' do
      # Verifying member that comes from Licitation Commission
      page.should_not have_field 'Membro', :with => 'Wenderson Malheiros'
      page.should_not have_field 'CPF', :with => '003.149.513-34'
      page.should_not have_field 'Função', :with => 'Presidente'
      page.should_not have_field 'Natureza do cargo', :with => 'Servidor efetivo'
      page.should_not have_field 'Matrícula', :with => '38'
    end
  end
end
