# encoding: utf-8
require 'spec_helper'

feature "Agreements" do
  background do
    sign_in
  end

  scenario 'create a new agreement' do
    AgreementKind.make!(:contribuicao)
    RegulatoryAct.make!(:sopa)

    navigate 'Contabilidade > Comum > Convênio > Convênios'

    click_link 'Criar Convênio'

    within_tab 'Principal' do
      fill_in 'Código', :with => '134'
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

    click_button 'Salvar'

    expect(page).to have_notice 'Convênio criado com sucesso.'

    click_link 'Apoio ao turismo'

    within_tab 'Principal' do
      expect(page).to have_field 'Código', :with => '134'
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
      expect(page).to have_link 'other_example_document.txt'
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

    navigate 'Contabilidade > Comum > Convênio > Convênios'

    click_link 'Apoio ao turismo'

    within_tab 'Principal' do
      fill_in 'Código', :with => '321'
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

    click_button 'Salvar'

    expect(page).to have_notice 'Convênio editado com sucesso.'

    click_link 'Apoio ao fomento do turismo'

    within_tab 'Principal' do
      expect(page).to have_field 'Código', :with => '321'
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
    end
  end

  scenario 'destroy an existent agreement' do
    Agreement.make!(:apoio_ao_turismo)

    navigate 'Contabilidade > Comum > Convênio > Convênios'

    click_link 'Apoio ao turismo'

    click_link 'Apagar', :confirm => true

    expect(page).to have_notice 'Convênio apagado com sucesso.'

    expect(page).to_not have_content 'Apoio ao turismo'
  end
end
