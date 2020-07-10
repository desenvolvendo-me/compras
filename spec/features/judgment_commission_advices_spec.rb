require 'spec_helper'

feature "JudgmentCommissionAdvices", vcr: { cassette_name: :judgment_commission_advices } do
  let(:current_user) { User.make!(:sobrinho) }

  background do
    create_roles ['licitation_processes',
                  'licitation_commissions', 'individuals']
    sign_in
  end

  scenario 'create, update and destroy a new judgment_commission_advice' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio)
    licitation_commission = LicitationCommission.make!(:comissao)
    Person.make!(:sobrinho)
    Person.make!(:wenderson)

    navigate 'Licitações > Processos de Compras'

    

    within_records do
      click_link '1/2012'
    end

    click_link 'Pareceres da comissão julgadora'

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2012'
      fill_modal 'Comissão julgadora', :with => '20/03/2012', :field => 'Data da nomeação'

      # testing delegated president name from licitation commission
      expect(page).to have_field 'Presidente da comissão', :with => 'Wenderson Malheiros', disabled: true
    end

    within_tab 'Membros' do
      # Verifying member that comes from Licitation Commission
      expect(page).to have_field 'Membro', :with => 'Wenderson Malheiros', disabled: true
      expect(page).to have_field 'CPF', :with => '003.149.513-34', disabled: true
      expect(page).to have_field 'Função', :with => 'Presidente', disabled: true
      expect(page).to have_field 'Natureza do cargo', :with => 'Servidor efetivo', disabled: true
      expect(page).to have_field 'Matrícula', :with => '38', disabled: true

      click_button 'Adicionar Membro'

      within '.member:nth-child(1)' do
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

    click_link 'Pareceres da comissão julgadora'

    within_tab 'Principal' do
      expect(page).to have_field 'Número da ata', :with => '1', disabled: true
      expect(page).to have_field 'Ano', :with => '2012'
      expect(page).to have_field 'Comissão julgadora', :with => licitation_commission.to_s
      expect(page).to have_field 'Presidente da comissão', :with => 'Wenderson Malheiros', disabled: true
    end

    within_tab 'Membros' do
      # Verifying member that comes from Licitation Commission
      expect(page).to have_field 'Membro', :with => 'Wenderson Malheiros', disabled: true
      expect(page).to have_field 'CPF', :with => '003.149.513-34', disabled: true
      expect(page).to have_field 'Função', :with => 'Presidente', disabled: true
      expect(page).to have_field 'Natureza do cargo', :with => 'Servidor efetivo', disabled: true
      expect(page).to have_field 'Matrícula', :with => '38', disabled: true

      within '.member:nth-last-child(1)' do
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

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2013'
      fill_modal 'Comissão julgadora', :with => '20/03/2012', :field => 'Data da nomeação'
    end

    within_tab 'Membros' do
      expect(page).to have_field 'Membro', :with => 'Wenderson Malheiros', disabled: true

      within '.member:nth-last-child(1)' do
        expect(page).to have_field 'Membro', :with => 'Gabriel Sobrinho'

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

    click_link 'Pareceres da comissão julgadora'

    within_tab 'Principal' do
      expect(page).to have_field 'Número da ata', :with => '1', disabled: true
      expect(page).to have_field 'Ano', :with => '2013'
      expect(page).to have_field 'Comissão julgadora', :with => licitation_commission.to_s
    end

    within_tab 'Membros' do
      expect(page).to_not have_field 'Membro', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Membro', :with => 'Wenderson Malheiros', disabled: true
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

  scenario 'should get the CPF number when selecting individual' do
    Person.make!(:wenderson)
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Licitações > Processos de Compras'

    

    within_records do
      click_link '1/2012'
    end

    click_link 'Pareceres da comissão julgadora'

    within_tab 'Membros' do
      click_button 'Adicionar Membro'

      fill_modal 'Membro', :with => 'Wenderson Malheiros'

      expect(page).to have_field 'CPF', :with => '003.149.513-34', disabled: true

      clear_modal 'Membro'
      expect(page).to have_field 'CPF', :with => '', disabled: true
    end
  end

  scenario 'should hidden Parecer when licitation_process is direct_purchase' do
    LicitationProcess.make!(:compra_direta)
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Licitações > Processos de Compras'

    

    within_records do
      click_link '1/2012'
    end

    click_link 'Pareceres da comissão julgadora'

    within '#judment_commission_advices' do
      expect(page).to have_link 'Parecer'
    end

    navigate 'Licitações > Processos de Compras'

    

    within_records do
      click_link '2/2013'
    end

    click_link 'Pareceres da comissão julgadora'

    within '#judment_commission_advices' do
      expect(page).to_not have_link 'Parecer'
    end
  end

  scenario 'should hidden Parecer when licitation_process is direct_purchase' do
    LicitationProcess.make!(:compra_direta)
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Licitações > Processos de Compras'

    

    within_records do
      click_link '1/2012'
    end

    click_link 'Pareceres da comissão julgadora'

    within '#judment_commission_advices' do
      expect(page).to have_link 'Parecer'
    end

    navigate 'Licitações > Processos de Compras'

    

    within_records do
      click_link '2/2013'
    end

    click_link 'Pareceres da comissão julgadora'

    within '#judment_commission_advices' do
      expect(page).to_not have_link 'Parecer'
    end
  end
end
