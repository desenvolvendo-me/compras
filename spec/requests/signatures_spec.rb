# encoding: utf-8
require 'spec_helper'

feature "Signatures" do
  background do
    sign_in
  end

  scenario 'create a new signature' do
    Person.make!(:sobrinho)
    Position.make!(:gerente)

    navigate_through 'Outros > Assinaturas'

    click_link 'Criar Assinatura'

    fill_modal 'Pessoa', :with => 'Gabriel Sobrinho'
    fill_modal 'Cargo', :with => 'Gerente'

    click_button 'Salvar'

    page.should have_notice 'Assinatura criado com sucesso.'

    click_link 'Gabriel Sobrinho'

    page.should have_field 'Pessoa', :with => 'Gabriel Sobrinho'
    page.should have_field 'Cargo', :with => 'Gerente'
  end

  scenario 'update an existent signature' do
    Signature.make!(:gerente_sobrinho)
    Person.make!(:wenderson)
    Position.make!(:supervisor)

    navigate_through 'Outros > Assinaturas'

    click_link 'Gabriel Sobrinho'

    fill_modal 'Pessoa', :with => 'Wenderson Malheiros'
    fill_modal 'Cargo', :with => 'Supervisor'

    click_button 'Salvar'

    page.should have_notice 'Assinatura editado com sucesso.'

    click_link 'Wenderson Malheiros'

    page.should have_field 'Pessoa', :with => 'Wenderson Malheiros'
    page.should have_field 'Cargo', :with => 'Supervisor'
  end

  scenario 'destroy an existent signature' do
    Signature.make!(:gerente_sobrinho)

    navigate_through 'Outros > Assinaturas'

    click_link 'Gabriel Sobrinho'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Assinatura apagado com sucesso.'

    page.should_not have_content 'Gabriel Sobrinho'
    page.should_not have_content 'Gerente'
  end
end
