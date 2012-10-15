# encoding: utf-8
require 'spec_helper'

feature "PaymentMethods" do
  background do
    sign_in
  end

  scenario 'create a new payment_method' do
    navigate 'Cadastros Gerais > Formas de Pagamento'

    click_link 'Criar Forma de Pagamento'

    fill_in 'Descrição', :with => 'Dinheiro'

    click_button 'Salvar'

    expect(page).to have_notice 'Forma de Pagamento criada com sucesso.'

    click_link 'Dinheiro'

    expect(page).to have_field 'Descrição', :with => 'Dinheiro'
  end

  scenario 'update an existent payment_method' do
    PaymentMethod.make!(:dinheiro)

    navigate 'Cadastros Gerais > Formas de Pagamento'

    click_link 'Dinheiro'

    fill_in 'Descrição', :with => 'Cheque'

    click_button 'Salvar'

    expect(page).to have_notice 'Forma de Pagamento editada com sucesso.'

    click_link 'Cheque'

    expect(page).to have_field 'Descrição', :with => 'Cheque'
  end

  scenario 'destroy an existent payment_method' do
    PaymentMethod.make!(:dinheiro)

    navigate 'Cadastros Gerais > Formas de Pagamento'

    click_link 'Dinheiro'

    click_link 'Apagar'

    expect(page).to have_notice 'Forma de Pagamento apagada com sucesso.'

    expect(page).to_not have_content 'Dinheiro'
  end

  scenario 'validate presence of description' do
    PaymentMethod.make!(:dinheiro)

    navigate 'Cadastros Gerais > Formas de Pagamento'

    click_link 'Criar Forma de Pagamento'

    fill_in 'Descrição', :with => 'Dinheiro'

    click_button 'Salvar'

    expect(page).to have_content 'já está em uso'
  end
end
