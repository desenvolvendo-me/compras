# encoding: utf-8
require 'spec_helper'

feature "FoundedDebtContracts" do
  background do
    sign_in
  end

  scenario 'create a new founded_debt_contract' do
    Entity.make!(:detran)

    click_link 'Contabilidade'

    click_link 'Contratos de Dívida Fundada'

    click_link 'Criar Contrato de Dívida Fundada'

    fill_in 'Exercício', :with => '2012'
    fill_modal 'Entidade', :with => 'Detran'
    fill_in 'Número do contrato', :with => '101'
    fill_in 'Número do processo', :with => '10'
    fill_in 'Data da assinatura', :with => '23/02/2012'
    fill_in 'Data do término', :with => '23/02/2013'
    fill_in 'Descrição', :with => 'Contrato sobre'

    click_button 'Criar Contrato de Dívida Fundada'

    page.should have_notice 'Contrato de Dívida Fundada criado com sucesso.'

    click_link '101'

    page.should have_field 'Exercício', :with => '2012'
    page.should have_field 'Entidade', :with => 'Detran'
    page.should have_field 'Número do contrato', :with => '101'
    page.should have_field 'Número do processo', :with => '10'
    page.should have_field 'Data da assinatura', :with => '23/02/2012'
    page.should have_field 'Data do término', :with => '23/02/2013'
    page.should have_field 'Descrição', :with => 'Contrato sobre'
  end

  scenario 'update an existent founded_debt_contract' do
    FoundedDebtContract.make!(:contrato_detran)
    Entity.make!(:secretaria_de_educacao)

    click_link 'Contabilidade'

    click_link 'Contratos de Dívida Fundada'

    click_link '101'

    fill_in 'Exercício', :with => '2011'
    fill_modal 'Entidade', :with => 'Secretaria de Educação'
    fill_in 'Número do contrato', :with => '100'
    fill_in 'Número do processo', :with => '200'
    fill_in 'Data da assinatura', :with => '21/02/2012'
    fill_in 'Data do término', :with => '21/02/2013'
    fill_in 'Descrição', :with => 'Outro contrato sobre compra de material'

    click_button 'Atualizar Contrato de Dívida Fundada'

    page.should have_notice 'Contrato de Dívida Fundada editado com sucesso.'

    click_link '100'

    page.should have_field 'Exercício', :with => '2011'
    page.should have_field 'Entidade', :with => 'Secretaria de Educação'
    page.should have_field 'Número do contrato', :with => '100'
    page.should have_field 'Número do processo', :with => '200'
    page.should have_field 'Data da assinatura', :with => '21/02/2012'
    page.should have_field 'Data do término', :with => '21/02/2013'
    page.should have_field 'Descrição', :with => 'Outro contrato sobre compra de material'
  end

  scenario 'destroy an existent founded_debt_contract' do
    founded_debt_contract = FoundedDebtContract.make!(:contrato_detran)

    click_link 'Contabilidade'

    click_link 'Contratos de Dívida Fundada'

    click_link '101'

    click_link "Apagar #{founded_debt_contract.id}/2012", :confirm => true

    page.should have_notice 'Contrato de Dívida Fundada apagado com sucesso.'

    page.should_not have_field 'Exercício', :with => '2012'
    page.should_not have_field 'Entidade', :with => 'Detran'
    page.should_not have_field 'Número do contrato', :with => '101'
    page.should_not have_field 'Número do processo', :with => '10'
    page.should_not have_field 'Data da assinatura', :with => '23/02/2012'
    page.should_not have_field 'Data do término', :with => '23/02/2013'
  end
end
