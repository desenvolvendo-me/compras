# encoding: utf-8
require 'spec_helper'

feature "Agreements" do
  background do
    sign_in
  end

  scenario 'checking regulatory act model info at additivies tab in a new agreement' do
    RegulatoryAct.make!(:sopa)

    navigate 'Contabilidade > Comum > Convênio > Convênios'

    click_link 'Criar Convênio'

    within_tab 'Aditivos' do
      click_button 'Adicionar Aditivo'

      fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'

      click_link 'Mais informações'
    end

    expect(page).to have_content 'Lei'
    expect(page).to have_content '1234'
  end

  scenario 'checking regulatory act model info at additivies tab in an existing agreement' do
    Agreement.make!(:apoio_ao_turismo)

    navigate 'Contabilidade > Comum > Convênio > Convênios'

    click_link 'Apoio ao turismo'

    within_tab 'Aditivos' do
      click_link 'Mais informações'
    end

    expect(page).to have_content 'Lei'
    expect(page).to have_content '1234'
  end

  scenario 'checking regulatory act modal info' do
    Agreement.make!(:apoio_ao_turismo_with_2_occurrences)

    navigate 'Contabilidade > Comum > Convênio > Convênios'

    click_link 'Apoio ao turismo'

    within_tab 'Principal' do
      click_link 'Mais informações'
    end

    expect(page).to have_content '1234'
    expect(page).to have_content '01/01/2012'
  end

  scenario 'editing an agreement should show date and kind of first occurrence' do
    Agreement.make!(:apoio_ao_turismo_with_2_occurrences)

    navigate 'Contabilidade > Comum > Convênio > Convênios'

    click_link 'Apoio ao turismo'

    within_tab 'Principal' do
      expect(page).to have_field 'Data da última ocorrência', :with => '15/04/2011'
      expect(page).to have_field 'Tipo da última ocorrência', :with => 'Em andamento'
    end
  end

  scenario 'checking bank_account modal info in a new agreement' do
    BankAccount.make!(:itau_tributos)

    navigate 'Contabilidade > Comum > Convênio > Convênios'

    click_link 'Criar Convênio'

    within_tab 'Conta Bancária' do
      click_button 'Adicionar Conta'

      fill_modal 'Conta bancária *', :with => 'Itaú Tributos', :field => 'Descrição'

      click_link 'Mais informações'
    end

    expect(page).to have_content 'Itaú Tributos'
    expect(page).to have_content '1111'
    expect(page).to have_content 'Ativo'
  end

  scenario 'checking creditor modal info in a new agreement' do
    Creditor.make!(:sobrinho)

    navigate 'Contabilidade > Comum > Convênio > Convênios'

    click_link 'Criar Convênio'

    within_tab 'Participantes' do
      click_button 'Adicionar Participante'

      fill_modal 'Credor', :with => 'Gabriel Sobrinho'

      click_link 'Mais informações'
    end

    expect(page).to have_content 'Gabriel Sobrinho'
    expect(page).to have_content '(33) 3333-3333'
    expect(page).to have_content 'Curitiba'
  end

  scenario 'checking creditor modal info in a existing agreement' do
    Agreement.make!(:apoio_ao_turismo)

    navigate 'Contabilidade > Comum > Convênio > Convênios'

    click_link 'Apoio ao turismo'

    within_tab 'Participantes' do
      click_link 'Mais informações'
    end

    expect(page).to have_content 'Gabriel Sobrinho'
    expect(page).to have_content '(33) 3333-3333'
    expect(page).to have_content 'Curitiba'
  end


  scenario 'checking bank_account modal info in a existing agreement' do
    Agreement.make!(:apoio_ao_turismo)

    navigate 'Contabilidade > Comum > Convênio > Convênios'

    click_link 'Apoio ao turismo'

    within_tab 'Conta Bancária' do
      click_link 'Mais informações'
    end

    expect(page).to have_content 'Itaú Tributos'
    expect(page).to have_content '1111'
    expect(page).to have_content 'Ativo'
  end

  scenario 'create a new agreement' do
    AgreementKind.make!(:contribuicao)
    RegulatoryAct.make!(:sopa)
    BankAccount.make!(:itau_tributos)
    Creditor.make!(:sobrinho)
    Creditor.make!(:wenderson_sa)

    navigate 'Contabilidade > Comum > Convênio > Convênios'

    click_link 'Criar Convênio'

    within_tab 'Principal' do
      expect(page).to_not have_field 'Tipo da última ocorrência'
      expect(page).to_not have_field 'Data da última ocorrência'

      fill_in 'Número e ano do convênio', :with => '59/2012'
      select 'Convênio repassado', :from => 'Categoria'
      fill_modal 'Tipo de convênio', :with => 'Contribuição', :field => 'Descrição'
      fill_in 'Valor', :with => '145.000,00'
      fill_in 'Valor da contrapartida', :with => '45.000,00'
      fill_in 'Número de parcelas', :with => '12'
      fill_in 'Objeto', :with => 'Apoio ao turismo'
      fill_in 'Processo administrativo', :with => '12758/2008'
      fill_in 'Data do processo', :with => '22/11/2012'
      fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'
      attach_file 'Arquivo', 'spec/fixtures/other_example_document.txt'
    end

    within_tab 'Conta Bancária' do
      click_button 'Adicionar Conta'

      fill_modal 'Conta bancária *', :with => 'Itaú Tributos', :field => 'Descrição'
      expect(page).to have_disabled_field 'Data inclusão'
      expect(page).to have_field 'Data inclusão', :with => I18n.l(Date.current)
      expect(page).to have_disabled_field 'Data de desativação'
      expect(page).to have_disabled_field 'Status'
    end

    within_tab 'Participantes' do
      click_button 'Adicionar Participante'

      fill_modal 'Credor', :with => 'Gabriel Sobrinho'

      fill_in 'Valor', :with => '190.000,00'
      select 'Concedente', :from => 'Tipo'
      select 'Estadual', :from => 'Esfera governamental'

      click_button 'Adicionar Participante'

      within '.nested-agreement-participant:nth-child(2)' do
        fill_modal 'Credor', :with => 'Wenderson Malheiros'

        fill_in 'Valor', :with => '190.000,00'
        select 'Convenente', :from => 'Tipo'
        select 'Federal', :from => 'Esfera governamental'
      end
    end

    within_tab 'Aditivos' do
      click_button 'Adicionar Aditivo'

      fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'
      select 'Outros', :from => 'Tipo'
      fill_in 'Valor', :with => '190.000,00'
      fill_in 'Descrição', :with => 'Termo de aditamento 002/2012'
    end

    within_tab 'Ocorrências' do
      click_button 'Adicionar Ocorrência'

      fill_in 'Data', :with => '15/04/2011'
      select 'Em andamento', :from => 'Tipo'
      fill_in 'Descrição', :with => 'Convênio Iniciado'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Convênio criado com sucesso.'

    click_link 'Apoio ao turismo'

    within_tab 'Principal' do
      expect(page).to have_field 'Número e ano do convênio', :with => '59/2012'
      expect(page).to have_select 'Categoria', :with => 'Convênio repassado'
      expect(page).to have_field 'Tipo de convênio', :with => 'Contribuição'
      expect(page).to have_field 'Valor', :with => '145.000,00'
      expect(page).to have_field 'Valor da contrapartida', :with => '45.000,00'
      expect(page).to have_field 'Número de parcelas', :with => '12'
      expect(page).to have_field 'Objeto', :with => 'Apoio ao turismo'
      expect(page).to have_field 'Processo administrativo', :with => '12758/2008'
      expect(page).to have_field 'Data do processo', :with => '22/11/2012'
      expect(page).to have_field 'Ato regulamentador', :with => 'Lei 1234'
      expect(page).to have_field 'Data da criação', :with => '01/01/2012'
      expect(page).to have_field 'Data da publicação', :with => '02/01/2012'
      expect(page).to have_field 'Data do término', :with => '09/01/2012'
      expect(page).to have_link 'other_example_document.txt'
    end

    within_tab 'Conta Bancária' do
      expect(page).to have_field 'Conta bancária *', :with => 'Itaú Tributos'
      expect(page).to have_disabled_field 'Data inclusão'
      expect(page).to have_field 'Data inclusão', :with => I18n.l(Date.current)
      expect(page).to have_disabled_field 'Data de desativação'
      expect(page).to have_disabled_field 'Status'
      expect(page).to have_field 'Status', :selected => 'Ativo'
    end

    within_tab 'Participantes' do
      expect(page).to have_field 'Credor', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Valor', :with => '190.000,00'
      expect(page).to have_select 'Tipo', :selected => 'Concedente'
      expect(page).to have_select 'Esfera governamental', :selected => 'Estadual'
    end

    within_tab 'Aditivos' do
      expect(page).to have_field 'Número/Ano', :with => '1/2012'
      expect(page).to have_field 'Ato regulamentador', :with => 'Lei 1234'
      expect(page).to have_select 'Tipo', :selected => 'Outros'
      expect(page).to have_field 'Valor', :with => '190.000,00'
      expect(page).to have_field 'Descrição', :with => 'Termo de aditamento 002/2012'
    end

    within_tab 'Ocorrências' do
      expect(page).to have_field 'Data', :with => '15/04/2011'
      expect(page).to have_select 'Tipo', :selected => 'Em andamento'
      expect(page).to have_field 'Descrição', :with => 'Convênio Iniciado'
    end
  end

  scenario 'when fill/clean regulatory_act should fill/clear related fields' do
    RegulatoryAct.make!(:sopa)

    navigate 'Contabilidade > Comum > Convênio > Convênios'

    click_link 'Criar Convênio'

    within_tab 'Principal' do
      fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'

      expect(page).to have_field 'Data da criação', :with => '01/01/2012'
      expect(page).to have_field 'Data da publicação', :with => '02/01/2012'
      expect(page).to have_field 'Data do término', :with => '09/01/2012'

      clear_modal 'Ato regulamentador'

      expect(page).to have_field 'Data da criação', :with => ''
      expect(page).to have_field 'Data da publicação', :with => ''
      expect(page).to have_field 'Data do término', :with => ''
    end
  end

  scenario 'update an existent agreement' do
    AgreementKind.make!(:auxilio)
    RegulatoryAct.make!(:emenda)
    Agreement.make!(:apoio_ao_turismo)
    BankAccount.make!(:santander_folha)
    Creditor.make!(:wenderson_sa)

    navigate 'Contabilidade > Comum > Convênio > Convênios'

    click_link 'Apoio ao turismo'

    within_tab 'Principal' do
      fill_in 'Número e ano do convênio', :with => '95/2011'
      select 'Convênio recebido', :from => 'Categoria'
      fill_modal 'Tipo de convênio', :with => 'Auxílio', :field => 'Descrição'
      fill_in 'Valor', :with => '245.000,00'
      fill_in 'Valor da contrapartida', :with => '145.000,00'
      fill_in 'Número de parcelas', :with => '6'
      fill_in 'Objeto', :with => 'Apoio ao fomento do turismo'
      fill_in 'Processo administrativo', :with => '85721/2007'
      fill_in 'Data do processo', :with => '13/11/2012'
      fill_modal 'Ato regulamentador', :with => '4567', :field => 'Número'
    end

    within_tab 'Conta Bancária' do
      click_button 'Remover Conta'

      click_button 'Adicionar Conta'

      fill_modal 'Conta bancária *', :with => 'Itaú Tributos', :field => 'Descrição'

      click_button 'Adicionar Conta'

      within '.nested-agreement-bank-account:nth-child(3)' do
        fill_modal 'Conta bancária *', :with => 'Santander - Folha de Pagamento', :field => 'Descrição'
      end
    end

    within_tab 'Participantes' do
      within '.nested-agreement-participant:nth-child(1)' do
        click_button 'Remover Participante'
      end

      click_button 'Remover Participante'

      click_button 'Adicionar Participante'

      fill_modal 'Credor', :with => 'Gabriel Sobrinho'

      fill_in 'Valor', :with => '390.000,00'
      select 'Concedente', :from => 'Tipo'
      select 'Estadual', :from => 'Esfera governamental'

      click_button 'Adicionar Participante'

      within '.nested-agreement-participant:nth-child(4)' do
        fill_modal 'Credor', :with => 'Wenderson Malheiros'

        fill_in 'Valor', :with => '390.000,00'
        select 'Convenente', :from => 'Tipo'
        select 'Federal', :from => 'Esfera governamental'
      end
    end

    within_tab 'Aditivos' do
      click_button 'Remover Aditivo'

      click_button 'Adicionar Aditivo'

      fill_modal 'Ato regulamentador', :with => '4567', :field => 'Número'
      select 'Prazo', :from => 'Tipo'
      fill_in 'Descrição', :with => 'Termo de aditamento'
      fill_in 'Valor', :with => '200,00'

      click_button 'Adicionar Aditivo'

      within '.nested-agreement-additive:nth-child(3)' do
        fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'
        select 'Outros', :from => 'Tipo'
        fill_in 'Descrição', :with => 'Terceiro termo de aditamento'
        fill_in 'Valor', :with => '210,00'
      end
    end

    within_tab 'Ocorrências' do
      expect(page).to have_content 'Descrição'
      expect(page).to have_content 'Data'

      click_button 'Remover'

      click_button 'Adicionar Ocorrência'

      fill_in 'Data', :with => '15/04/2011'
      select 'Em andamento', :from => 'Tipo'
      fill_in 'Descrição', :with => 'Convênio Iniciado'

      click_button 'Adicionar Ocorrência'

      within '.nested-agreement-occurrence:nth-child(3)' do
        fill_in 'Data', :with => '18/06/2012'
        select 'Paralisado', :from => 'Tipo'
        fill_in 'Descrição', :with => 'Falta prestação de contas'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Convênio editado com sucesso.'

    click_link 'Apoio ao fomento do turismo'

    within_tab 'Principal' do
      expect(page).to have_field 'Número e ano do convênio', :with => '95/2011'
      expect(page).to have_select 'Categoria', :with => 'Convênio recebido'
      expect(page).to have_field 'Tipo de convênio', :with => 'Auxílio'
      expect(page).to have_field 'Valor', :with => '245.000,00'
      expect(page).to have_field 'Valor da contrapartida', :with => '145.000,00'
      expect(page).to have_field 'Número de parcelas', :with => '6'
      expect(page).to have_field 'Objeto', :with => 'Apoio ao fomento do turismo'
      expect(page).to have_field 'Processo administrativo', :with => '85721/2007'
      expect(page).to have_field 'Data do processo', :with => '13/11/2012'
      expect(page).to have_field 'Ato regulamentador', :with => 'Emenda constitucional 4567'
      expect(page).to have_field 'Data da criação', :with => '01/01/2012'
      expect(page).to have_field 'Data da publicação', :with => '02/01/2012'
      expect(page).to have_field 'Data do término', :with => '09/01/2012'
    end

    within_tab 'Conta Bancária' do
      within '.nested-agreement-bank-account:nth-child(1)' do
        expect(page).to have_field 'Conta bancária *', :with => 'Itaú Tributos'
        expect(page).to have_disabled_field 'Data inclusão'
        expect(page).to have_field 'Data inclusão', :with => I18n.l(Date.current)
        expect(page).to have_disabled_field 'Data de desativação'
        expect(page).to have_field 'Data de desativação', :with => I18n.l(Date.current)
        expect(page).to have_disabled_field 'Status'
        expect(page).to have_select 'Status', :selected => 'Inativo'
      end

      within '.nested-agreement-bank-account:nth-child(2)' do
        expect(page).to have_field 'Conta bancária *', :with => 'Santander - Folha de Pagamento'
        expect(page).to have_disabled_field 'Data inclusão'
        expect(page).to have_field 'Data inclusão', :with => I18n.l(Date.current)
        expect(page).to have_disabled_field 'Data de desativação'
        expect(page).to have_disabled_field 'Status'
        expect(page).to have_select 'Status', :selected => 'Ativo'
      end
    end

    within_tab 'Participantes' do
      within '.nested-agreement-participant:nth-child(2)' do
        expect(page).to have_field 'Credor', :with => 'Wenderson Malheiros'
        expect(page).to have_field 'Valor', :with => '390.000,00'
        expect(page).to have_select 'Tipo', :selected => 'Convenente'
        expect(page).to have_select 'Esfera governamental', :selected => 'Federal'
      end

      within '.nested-agreement-participant:nth-child(1)' do
        expect(page).to have_field 'Credor', :with => 'Gabriel Sobrinho'
        expect(page).to have_field 'Valor', :with => '390.000,00'
        expect(page).to have_select 'Tipo', :selected => 'Concedente'
        expect(page).to have_select 'Esfera governamental', :selected => 'Estadual'
      end
    end

    within_tab 'Aditivos' do
      within '.nested-agreement-additive:nth-child(1)' do
        expect(page).to have_field 'Número/Ano', :with => '2/2011'
        expect(page).to have_field 'Ato regulamentador', :with => 'Emenda constitucional 4567'
        expect(page).to have_select 'Tipo', :selected => 'Prazo'
        expect(page).to have_field 'Descrição', :with => 'Termo de aditamento'
        expect(page).to have_field 'Valor', :with => '200,00'
      end

      within '.nested-agreement-additive:nth-child(2)' do
        expect(page).to have_field 'Número/Ano', :with => '3/2011'
        expect(page).to have_field 'Ato regulamentador', :with => 'Lei 1234'
        expect(page).to have_select 'Tipo', :selected => 'Outros'
        expect(page).to have_field 'Descrição', :with => 'Terceiro termo de aditamento'
        expect(page).to have_field 'Valor', :with => '210,00'
      end
    end

    within_tab 'Ocorrências' do
      within '.nested-agreement-occurrence:nth-child(1)' do
        expect(page).to have_field 'Data', :with => '18/06/2012'
        expect(page).to have_select 'Tipo', :selected => 'Paralisado'
        expect(page).to have_field 'Descrição', :with => 'Falta prestação de contas'
      end

      within '.nested-agreement-occurrence:nth-child(2)' do
        expect(page).to have_field 'Data', :with => '15/04/2011'
        expect(page).to have_select 'Tipo', :selected => 'Em andamento'
        expect(page).to have_field 'Descrição', :with => 'Convênio Iniciado'
      end
    end
  end

  scenario 'validating sum of value of participants whose kind equals granting' do
    Agreement.make!(:apoio_ao_turismo)
    Creditor.make!(:wenderson_sa)

    navigate 'Contabilidade > Comum > Convênio > Convênios'

    click_link 'Apoio ao turismo'

    within_tab 'Participantes' do
      click_button 'Adicionar Participante'

      fill_modal 'Credor', :with => 'Gabriel Sobrinho'

      fill_in 'Valor', :with => '10.000,00'
      select 'Concedente', :from => 'Tipo'
      select 'Estadual', :from => 'Esfera governamental'
    end

    click_button 'Salvar'

    within_tab 'Participantes' do
      expect(page).to have_content 'a soma do valor dos participantes concedentes deve ser igual a R$ 190.000,00'
    end
  end

  scenario 'validating sum of value of participants whose kind equals convenente' do
    Agreement.make!(:apoio_ao_turismo)
    Creditor.make!(:wenderson_sa)

    navigate 'Contabilidade > Comum > Convênio > Convênios'

    click_link 'Apoio ao turismo'

    within_tab 'Participantes' do
      click_button 'Adicionar Participante'

      within '.nested-agreement-participant:nth-child(3)' do
        fill_modal 'Credor', :with => 'Gabriel Sobrinho'

        fill_in 'Valor', :with => '10.000,00'
        select 'Convenente', :from => 'Tipo'
        select 'Estadual', :from => 'Esfera governamental'
      end
    end

    click_button 'Salvar'

    within_tab 'Participantes' do
      expect(page).to have_content 'a soma do valor dos participantes convenentes deve ser igual a R$ 190.000,00'
    end
  end

  scenario 'destroy an existent agreement' do
    Agreement.make!(:apoio_ao_turismo)

    navigate 'Contabilidade > Comum > Convênio > Convênios'

    click_link 'Apoio ao turismo'

    click_link 'Apagar'

    expect(page).to have_notice 'Convênio apagado com sucesso.'

    expect(page).to_not have_content 'Apoio ao turismo'
  end
end
