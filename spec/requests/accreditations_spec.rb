# encoding: utf-8
require 'spec_helper'

feature "Accreditations" do
  background do
    sign_in
  end

  scenario 'acreditation button link should not exists on licitation process creation' do
    click_link 'Processos'

    click_link 'Processos Licitatórios'

    click_link  'Criar Processo Licitatório'
    
    page.should_not have_link "Novo credenciamento"
    page.should_not have_link "Editar credenciamento"
  end

  scenario 'accreditation button link to licitation process without accreditation' do
    LicitationProcess.make!(:processo_licitatorio)
    
    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end
    
    page.should have_link "Novo credenciamento"
  end

  scenario 'accreditation button link at licitation process with accreditation' do
    accreditation = Accreditation.make!(:credenciamento)
    
    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end
    
    page.should have_link "Editar credenciamento"
  end

  scenario 'create a new accreditation' do
    LicitationProcess.make!(:processo_licitatorio)
    licitation_commission = LicitationCommission.make!(:comissao)

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Novo credenciamento'

    within_tab 'Principal' do
      page.should have_disabled_field 'Processo licitatório'
      page.should have_disabled_field 'Abrev. modalidade'
      page.should have_disabled_field 'Descrição do objeto'
      
      page.should have_field 'Processo licitatório', :with => '1/2012'
      page.should have_field 'Abrev. modalidade', :with => 'CV'
      page.should have_field 'Descrição do objeto', :with => 'Descricao'

      fill_modal 'Comissão de licitação', :with => '20/03/2012', :field => 'Data da nomeação'
    end

    click_button 'Criar Credenciamento'

    page.should have_notice 'Credenciamento criado com sucesso.'

    click_link 'Editar credenciamento'

    within_tab 'Principal' do
      page.should have_field 'Comissão de licitação', :with => "#{licitation_commission.id}"
    end
  end

  scenario 'edit an existent accreditation' do
    acreditation = Accreditation.make!(:credenciamento)
    licitation_commission = LicitationCommission.make!(:comissao_nova)

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Editar credenciamento'

    within_tab 'Principal' do
      page.should have_disabled_field 'Processo licitatório'
      page.should have_disabled_field 'Abrev. modalidade'
      page.should have_disabled_field 'Descrição do objeto'
      
      page.should have_field 'Processo licitatório', :with => '1/2012'
      page.should have_field 'Abrev. modalidade', :with => 'CV'
      page.should have_field 'Descrição do objeto', :with => 'Descricao'

      fill_modal 'Comissão de licitação', :with => '20/04/2012', :field => 'Data da nomeação'
    end

    click_button 'Atualizar Credenciamento'

    page.should have_notice 'Credenciamento editado com sucesso.'

    page.should have_field 'Comissão de licitação', :with => "#{licitation_commission.id}"
  end

  scenario 'destroy an existent accreditation' do
    accreditation = Accreditation.make!(:credenciamento)

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Editar credenciamento'

    page.should have_link "Apagar #{accreditation}"

    click_link "Apagar #{accreditation}", :confirm => true

    page.should have_notice 'Credenciamento apagado com sucesso.'

    page.should have_link "Novo credenciamento"
  end

  scenario 'change commission president on change licitation_commission' do
    acreditation = Accreditation.make!(:credenciamento)
    licitation_commission = LicitationCommission.make!(:comissao_nova)

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Editar credenciamento'

    within_tab 'Principal' do
      page.should have_field 'Presidente da comissão', :with => ''

      fill_modal 'Comissão de licitação', :with => '20/04/2012', :field => 'Data da nomeação'
      page.should have_field 'Presidente da comissão', :with => 'Wenderson Malheiros'
    end
  end

  scenario 'clear commission president on clear licitation_commission' do
    acreditation = Accreditation.make!(:credenciamento_com_presidente)

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Editar credenciamento'

    within_tab 'Principal' do
      page.should have_field 'Presidente da comissão', :with => 'Wenderson Malheiros'

      clear_modal 'Comissão de licitação'
      
      page.should have_field 'Presidente da comissão', :with => ''
    end
  end
end
