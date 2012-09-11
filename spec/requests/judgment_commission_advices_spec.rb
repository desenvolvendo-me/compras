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

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Pareceres da comissão julgadora'

    click_link 'Criar Parecer da Comissão Julgadora'

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2012'
      fill_modal 'Comissão julgadora', :with => '20/03/2012', :field => 'Data da nomeação'

      # testing delegated president name from licitation commission
      expect(page).to have_disabled_field 'Presidente da comissão'
      expect(page).to have_field 'Presidente da comissão', :with => 'Wenderson Malheiros'
    end

    within_tab 'Membros' do
      # Verifying member that comes from Licitation Commission
      expect(page).to have_disabled_field 'Membro'
      expect(page).to have_disabled_field 'CPF'
      expect(page).to have_disabled_field 'Função'
      expect(page).to have_disabled_field 'Natureza do cargo'
      expect(page).to have_disabled_field 'Matrícula'

      expect(page).to have_field 'Membro', :with => 'Wenderson Malheiros'
      expect(page).to have_field 'CPF', :with => '003.149.513-34'
      expect(page).to have_field 'Função', :with => 'Presidente'
      expect(page).to have_field 'Natureza do cargo', :with => 'Servidor efetivo'
      expect(page).to have_field 'Matrícula', :with => '38'

      click_button 'Adicionar Membro'

      within '.member:first' do
        fill_modal 'Membro', :with => 'Gabriel Sobrinho'
        select 'Presidente', :from => 'Função'
        select 'Servidor efetivo', :from => 'Natureza do cargo'
        fill_in 'Matrícula', :with => '3456789'
      end
    end

    within_tab 'Parecer' do
      fill_in "Data do início do julgamento", :with => "20/01/2012"
      fill_in "Hora do início do julgamento", :with => "12:00"
      fill_in "Data do fim do julgamento", :with => "21/01/2012"
      fill_in "Hora do fim do julgamento", :with => "13:00"
      fill_in "Texto da ata sobre as empresas licitantes", :with => "texto 1"
      fill_in "Texto da ata sobre documentação das empresas licitantes", :with => "texto 2"
      fill_in "Texto da ata sobre julgamento das propostas / justificativas", :with => "texto 3"
      fill_in "Texto da ata sobre julgamento - pareceres diversos", :with => "texto 4"
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Parecer da Comissão Julgadora criado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      expect(page).to have_field 'Número da ata', :with => '1'
      expect(page).to have_field 'Ano', :with => '2012'
      expect(page).to have_field 'Comissão julgadora', :with => licitation_commission.to_s
      expect(page).to have_field 'Presidente da comissão', :with => 'Wenderson Malheiros'
    end

    within_tab 'Membros' do
      # Verifying member that comes from Licitation Commission
      expect(page).to have_disabled_field 'Membro'
      expect(page).to have_disabled_field 'CPF'
      expect(page).to have_disabled_field 'Função'
      expect(page).to have_disabled_field 'Natureza do cargo'
      expect(page).to have_disabled_field 'Matrícula'

      expect(page).to have_field 'Membro', :with => 'Wenderson Malheiros'
      expect(page).to have_field 'CPF', :with => '003.149.513-34'
      expect(page).to have_field 'Função', :with => 'Presidente'
      expect(page).to have_field 'Natureza do cargo', :with => 'Servidor efetivo'
      expect(page).to have_field 'Matrícula', :with => '38'

      within '.member:last' do
        expect(page).to have_field 'Membro', :with => 'Gabriel Sobrinho'
        expect(page).to have_select 'Função', :selected => 'Presidente'
        expect(page).to have_select 'Natureza do cargo', :selected => 'Servidor efetivo'
        expect(page).to have_field 'Matrícula', :with => '3456789'
      end
    end

    within_tab 'Parecer' do
      expect(page).to have_field "Data do início do julgamento", :with => "20/01/2012"
      expect(page).to have_field "Hora do início do julgamento", :with => "12:00"
      expect(page).to have_field "Data do fim do julgamento", :with => "21/01/2012"
      expect(page).to have_field "Hora do fim do julgamento", :with => "13:00"
      expect(page).to have_field "Texto da ata sobre as empresas licitantes", :with => "texto 1"
      expect(page).to have_field "Texto da ata sobre documentação das empresas licitantes", :with => "texto 2"
      expect(page).to have_field "Texto da ata sobre julgamento das propostas / justificativas", :with => "texto 3"
      expect(page).to have_field "Texto da ata sobre julgamento - pareceres diversos", :with => "texto 4"
    end
  end

  scenario 'update an existent judgment_commission_advice' do
    JudgmentCommissionAdvice.make!(:parecer)
    new_licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)
    new_licitation_commission = LicitationCommission.make!(:comissao_nova)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Pareceres da comissão julgadora'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2013'
      fill_modal 'Comissão julgadora', :with => '20/04/2012', :field => 'Data da nomeação'
    end

    within_tab 'Membros' do
      expect(page).to have_field 'Membro', :with => 'Gabriel Sobrinho'

      within '.member:last' do
        expect(page).to have_field 'Membro', :with => 'Wenderson Malheiros'

        click_button 'Remover'
      end
    end

    within_tab 'Parecer' do
      fill_in "Data do início do julgamento", :with => "20/01/2013"
      fill_in "Hora do início do julgamento", :with => "14:00"
      fill_in "Data do fim do julgamento", :with => "21/01/2013"
      fill_in "Hora do fim do julgamento", :with => "15:00"
      fill_in "Texto da ata sobre as empresas licitantes", :with => "novo texto 1"
      fill_in "Texto da ata sobre documentação das empresas licitantes", :with => "novo texto 2"
      fill_in "Texto da ata sobre julgamento das propostas / justificativas", :with => "novo texto 3"
      fill_in "Texto da ata sobre julgamento - pareceres diversos", :with => "novo texto 4"
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Parecer da Comissão Julgadora editado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      expect(page).to have_field 'Número da ata', :with => '1'
      expect(page).to have_field 'Ano', :with => '2013'
      expect(page).to have_field 'Comissão julgadora', :with => new_licitation_commission.to_s
    end

    within_tab 'Membros' do
      expect(page).to_not have_field 'Membro', :with => 'Wenderson Malheiros'
      expect(page).to have_field 'Membro', :with => 'Gabriel Sobrinho'
    end

    within_tab 'Parecer' do
      expect(page).to have_field "Data do início do julgamento", :with => "20/01/2013"
      expect(page).to have_field "Hora do início do julgamento", :with => "14:00"
      expect(page).to have_field "Data do fim do julgamento", :with => "21/01/2013"
      expect(page).to have_field "Hora do fim do julgamento", :with => "15:00"
      expect(page).to have_field "Texto da ata sobre as empresas licitantes", :with => "novo texto 1"
      expect(page).to have_field "Texto da ata sobre documentação das empresas licitantes", :with => "novo texto 2"
      expect(page).to have_field "Texto da ata sobre julgamento das propostas / justificativas", :with => "novo texto 3"
      expect(page).to have_field "Texto da ata sobre julgamento - pareceres diversos", :with => "novo texto 4"
    end
  end

  scenario 'destroy an existent judgment_commission_advice' do
    advice = JudgmentCommissionAdvice.make!(:parecer)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Pareceres da comissão julgadora'

    expect(page).to have_link advice.to_s

    within_records do
      page.find('a').click
    end

    click_link 'Apagar'

    expect(page).to have_notice 'Parecer da Comissão Julgadora apagado com sucesso.'

    expect(page).to_not have_link advice.to_s
  end

  scenario 'create another judgment_commission_advice to test the generated minutes number and judgment sequence' do
    JudgmentCommissionAdvice.make!(:parecer)
    LicitationProcess.make!(:processo_licitatorio)
    LicitationCommission.make!(:comissao)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Pareceres da comissão julgadora'

    click_link 'Criar Parecer da Comissão Julgadora'

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2012'
      fill_modal 'Comissão julgadora', :with => '20/03/2012', :field => 'Data da nomeação'
    end

    within_tab 'Parecer' do
      fill_in "Data do início do julgamento", :with => "20/01/2012"
      fill_in "Hora do início do julgamento", :with => "12:00"
      fill_in "Data do fim do julgamento", :with => "21/01/2012"
      fill_in "Hora do fim do julgamento", :with => "13:00"
      fill_in "Texto da ata sobre as empresas licitantes", :with => "texto 1"
      fill_in "Texto da ata sobre documentação das empresas licitantes", :with => "texto 2"
      fill_in "Texto da ata sobre julgamento das propostas / justificativas", :with => "texto 3"
      fill_in "Texto da ata sobre julgamento - pareceres diversos", :with => "texto 4"
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Parecer da Comissão Julgadora criado com sucesso.'

    click_link JudgmentCommissionAdvice.last.to_s

    within_tab 'Principal' do
      expect(page).to have_field 'Número da ata', :with => '2'
    end
  end

  scenario 'asserting that duplicated individuals on members can not be saved' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio)
    licitation_commission = LicitationCommission.make!(:comissao)
    Person.make!(:sobrinho)
    Person.make!(:wenderson)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Pareceres da comissão julgadora'

    click_link 'Criar Parecer da Comissão Julgadora'

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2012'
      fill_modal 'Comissão julgadora', :with => '20/03/2012', :field => 'Data da nomeação'

      # testing delegated president name from licitation commission
      expect(page).to have_disabled_field 'Presidente da comissão'
      expect(page).to have_field 'Presidente da comissão', :with => 'Wenderson Malheiros'
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
      fill_in "Data do início do julgamento", :with => "20/01/2012"
      fill_in "Hora do início do julgamento", :with => "12:00"
      fill_in "Data do fim do julgamento", :with => "21/01/2012"
      fill_in "Hora do fim do julgamento", :with => "13:00"
      fill_in "Texto da ata sobre as empresas licitantes", :with => "texto 1"
      fill_in "Texto da ata sobre documentação das empresas licitantes", :with => "texto 2"
      fill_in "Texto da ata sobre julgamento das propostas / justificativas", :with => "texto 3"
      fill_in "Texto da ata sobre julgamento - pareceres diversos", :with => "texto 4"
    end

    click_button 'Salvar'

    within_tab 'Membros' do
      expect(page).to have_content 'já está em uso'
    end
  end

  scenario 'should get the CPF number when selecting individual' do
    Person.make!(:wenderson)
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Pareceres da comissão julgadora'

    click_link 'Criar Parecer da Comissão Julgadora'

    within_tab 'Membros' do
      click_button 'Adicionar Membro'

      fill_modal 'Membro', :with => 'Wenderson Malheiros'

      expect(page).to have_disabled_field 'CPF'
      expect(page).to have_field 'CPF', :with => '003.149.513-34'

      clear_modal 'Membro'
      expect(page).to have_disabled_field 'CPF'
      expect(page).to have_field 'CPF', :with => ''
    end
  end
end
