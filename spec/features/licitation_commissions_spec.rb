require 'spec_helper'

feature "LicitationCommissions" do
  background do
    sign_in
  end

  scenario 'create, update and destroy a new licitation_commission' do
    RegulatoryAct.make!(:sopa)
    Person.make!(:wenderson)
    Person.make!(:sobrinho)

    navigate 'Cadastro > Auxiliar > Comissões de Licitação'

    click_link 'Criar Comissão de Licitação'

    within_tab 'Principal' do
      select 'Especial', :from => 'Tipo de comissão'

      fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'

      expect(page).to have_field 'Ato regulamentador', :with => 'LDO 1234'

      expect(page).to have_field 'Data da publicação do ato', :with => '02/01/2012', disabled: true

      fill_in 'Data da nomeação', :with => '20/03/2012'
      fill_in 'Data da expiração', :with => '22/03/2012'
      fill_in 'Data da exoneração', :with => '25/03/2012'
      fill_in 'Descrição e finalidade da comissão', :with => 'Minha comissão é essa e tem essa finalidade'
    end

    within_tab 'Responsáveis' do
      click_button 'Adicionar Responsável'

      fill_modal 'Autoridade', :with => 'Wenderson Malheiros'
      select 'Advogado', :from => 'Cargo'
      fill_in 'Registro da classe', :with => '123456'
    end

    within_tab 'Membros' do
      click_button 'Adicionar Membro'

      fill_modal 'Membro', :with => 'Gabriel Sobrinho'
      fill_in 'Matrícula', :with => '3456789'
      select 'Presidente', :from => 'Função'
      select 'Servidor efetivo', :from => 'Natureza do cargo'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Comissão de Licitação criada com sucesso.'

    click_link 'Minha comissão é essa e tem essa finalidade'

    within_tab 'Principal' do
      expect(page).to have_select 'Tipo de comissão', :selected => 'Especial'
      expect(page).to have_field 'Data da nomeação', :with => '20/03/2012'
      expect(page).to have_field 'Data da expiração', :with => '22/03/2012'
      expect(page).to have_field 'Data da exoneração', :with => '25/03/2012'
      expect(page).to have_field 'Descrição e finalidade da comissão', :with => 'Minha comissão é essa e tem essa finalidade'
    end

    within_tab 'Responsáveis' do
      expect(page).to have_field 'Autoridade', :with => 'Wenderson Malheiros'
      expect(page).to have_select 'Cargo', :selected => 'Advogado'
      expect(page).to have_field 'Registro da classe', :with => '123456'
    end

    within_tab 'Membros' do
      expect(page).to have_field 'Membro', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Matrícula', :with => '3456789'
      expect(page).to have_select 'Função', :selected => 'Presidente'
      expect(page).to have_select 'Natureza do cargo', :selected => 'Servidor efetivo'
    end

    within_tab 'Principal' do
      select 'Leiloeiros', :from => 'Tipo de comissão'

      fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'

      expect(page).to have_field 'Ato regulamentador', :with => 'LDO 1234'

      expect(page).to have_field 'Data da publicação do ato', :with => '02/01/2012', disabled: true

      fill_in 'Data da nomeação', :with => '20/03/2014'
      fill_in 'Data da expiração', :with => '22/03/2014'
      fill_in 'Data da exoneração', :with => '25/03/2014'
      fill_in 'Descrição e finalidade da comissão', :with => 'nova descrição'
    end

    within_tab 'Responsáveis' do
      click_button 'Remover Responsável'

      click_button 'Adicionar Responsável'

      fill_modal 'Autoridade', :with => 'Gabriel Sobrinho'
      select 'Prefeito municipal', :from => 'Cargo'
    end

    within_tab 'Membros' do
      within '.member:nth-child(1)' do
        fill_modal 'Membro', :with => 'Wenderson Malheiros'
        fill_in 'Matrícula', :with => '123456'
        select 'Presidente', :from => 'Função'
        select 'Outros', :from => 'Natureza do cargo'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Comissão de Licitação editada com sucesso.'

    click_link 'nova descrição'

    within_tab 'Principal' do
      expect(page).to have_select 'Tipo de comissão', :selected => 'Leiloeiros'
      expect(page).to have_field 'Data da nomeação', :with => '20/03/2014'
      expect(page).to have_field 'Data da expiração', :with => '22/03/2014'
      expect(page).to have_field 'Data da exoneração', :with => '25/03/2014'
      expect(page).to have_field 'Descrição e finalidade da comissão', :with => 'nova descrição'
    end

    within_tab 'Responsáveis' do
      expect(page).to_not have_field 'Autoridade', :with => 'Wenderson Malheiros'

      expect(page).to have_field 'Autoridade', :with => 'Gabriel Sobrinho'
      expect(page).to have_select 'Cargo', :selected => 'Prefeito municipal'
    end

    within_tab 'Membros' do
      expect(page).to_not have_field 'Membro', :with => 'Gabriel Sobrinho'

      within '.member' do
        expect(page).to have_field 'Membro', :with => 'Wenderson Malheiros'
        expect(page).to have_field 'Matrícula', :with => '123456'
        expect(page).to have_select 'Função', :selected => 'Presidente'
        expect(page).to have_select 'Natureza do cargo', :selected => 'Outros'
      end
    end

    click_link 'Apagar'

    expect(page).to have_notice 'Comissão de Licitação apagada com sucesso.'

    expect(page).to_not have_link 'nova descrição'
  end

  scenario 'should clear publication_date when administractive act is clean' do
    LicitationCommission.make!(:comissao)

    navigate 'Cadastro > Auxiliar > Comissões de Licitação'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      select 'Pregão', :from => 'Tipo de comissão'

      expect(page).to have_field 'Ato regulamentador', :with => 'LDO 1234'
      expect(page).to have_field 'Data da publicação do ato', :with => '02/01/2012', disabled: true

      clear_modal 'Ato regulamentador'

      expect(page).to have_field 'Ato regulamentador', :with => ''
      expect(page).to have_field 'Data da publicação do ato', :with => '', disabled: true
    end
  end

  scenario 'should get the CPF number when selecting individual' do
    Person.make!(:wenderson)

    navigate 'Cadastro > Auxiliar > Comissões de Licitação'

    click_link 'Criar Comissão de Licitação'

    within_tab 'Responsáveis' do
      click_button 'Adicionar Responsável'

      fill_modal 'Autoridade', :with => 'Wenderson Malheiros'

      expect(page).to have_field 'CPF', :with => '003.149.513-34', disabled: true

      clear_modal 'Autoridade'

      expect(page).to have_field 'CPF', :with => '', disabled: true
    end

    within_tab 'Membros' do
      click_button 'Adicionar Membro'

      fill_modal 'Membro', :with => 'Wenderson Malheiros'

      expect(page).to have_field 'CPF', :with => '003.149.513-34', disabled: true

      clear_modal 'Membro'
      expect(page).to have_field 'CPF', :with => '', disabled: true
    end
  end

  scenario 'should enable/disable class_register field depending on selected role' do
    navigate 'Cadastro > Auxiliar > Comissões de Licitação'

    click_link 'Criar Comissão de Licitação'

    within_tab 'Responsáveis' do
      click_button 'Adicionar Responsável'

      select 'Prefeito municipal', :from => 'Cargo'
      expect(page).to have_field 'Registro da classe', disabled: true

      select 'Secretário de finanças', :from => 'Cargo'
      expect(page).to have_field 'Registro da classe', disabled: true

      select 'Secretário de administração', :from => 'Cargo'
      expect(page).to have_field 'Registro da classe', disabled: true

      select 'Diretor de compras e licitações', :from => 'Cargo'
      expect(page).to have_field 'Registro da classe', disabled: true

      select 'Chefe do setor de compras e licitações', :from => 'Cargo'
      expect(page).to have_field 'Registro da classe', disabled: true

      select 'Advogado', :from => 'Cargo'
      expect(page).to_not have_field 'Registro da classe', disabled: true
    end
  end

  scenario "should clean the class_register when value selected for role is not lawyer" do
    LicitationCommission.make!(:comissao)

    navigate 'Cadastro > Auxiliar > Comissões de Licitação'

    within_records do
      page.find('a').click
    end

    within_tab 'Responsáveis' do
      expect(page).to have_select 'Cargo', :selected => 'Advogado'
      expect(page).to have_field 'Registro da classe', :with => '123457'

      select 'Prefeito municipal', :from => 'Cargo'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Comissão de Licitação editada com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Responsáveis' do
      expect(page).to have_select 'Cargo', :selected => 'Prefeito municipal'
      expect(page).to have_field 'Registro da classe', :with => '', disabled: true
    end
  end

  scenario "using the description field to filter licitation commissions" do
    LicitationCommission.make!(:comissao)

    navigate 'Cadastro > Auxiliar > Comissões de Licitação'

    click_link "Filtrar Comissões de Licitação"

    expect(page).to have_field "Descrição"
  end

  scenario 'creating a trading licitation commission' do
    RegulatoryAct.make!(:sopa)
    Person.make!(:wenderson)
    Person.make!(:sobrinho)
    Person.make!(:joao_da_silva)

    navigate 'Cadastro > Auxiliar > Comissões de Licitação'

    click_link 'Criar Comissão de Licitação'

    within_tab 'Principal' do
      select 'Pregão', :from => 'Tipo de comissão'

      fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'

      expect(page).to have_field 'Ato regulamentador', :with => 'LDO 1234'

      expect(page).to have_field 'Data da publicação do ato', :with => '02/01/2012', disabled: true

      fill_in 'Data da nomeação', :with => '20/03/2012'
      fill_in 'Data da expiração', :with => '22/03/2012'
      fill_in 'Data da exoneração', :with => '25/03/2012'
      fill_in 'Descrição e finalidade da comissão', :with => 'descrição'
    end

    within_tab 'Responsáveis' do
      click_button 'Adicionar Responsável'

      fill_modal 'Autoridade', :with => 'Wenderson Malheiros'
      select 'Advogado', :from => 'Cargo'
      fill_in 'Registro da classe', :with => '123456'
    end

    within_tab 'Membros' do
      click_button 'Adicionar Membro'

      fill_modal 'Membro', :with => 'Gabriel Sobrinho'
      fill_in 'Matrícula', :with => '3456789'
      select 'Pregoeiro', :from => 'Função'
      select 'Servidor efetivo', :from => 'Natureza do cargo'

      click_button 'Adicionar Membro'

      fill_modal 'Membro', :with => 'Joao da Silva'
      fill_in 'Matrícula', :with => '1234'
      select 'Equipe de Apoio', :from => 'Função'
      select 'Servidor efetivo', :from => 'Natureza do cargo'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Comissão de Licitação criada com sucesso.'
  end
end
