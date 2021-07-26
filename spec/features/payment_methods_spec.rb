require 'spec_helper'

feature "PaymentMethods" do
  background do
    sign_in
  end

  scenario 'create a new payment_method, update and destroy an existing' do
    navigate 'Cadastro > Formas de Pagamento'

    click_link 'Criar Forma de Pagamento'

    fill_in 'Descrição', :with => 'Dinheiro'

    click_button 'Salvar'

    expect(page).to have_notice 'Forma de Pagamento criada com sucesso.'

    click_link 'Dinheiro'

    expect(page).to have_field 'Descrição', :with => 'Dinheiro'

    fill_in 'Descrição', :with => 'Cheque'

    click_button 'Salvar'

    expect(page).to have_notice 'Forma de Pagamento editada com sucesso.'

    click_link 'Cheque'

    expect(page).to have_field 'Descrição', :with => 'Cheque'

    click_link 'Apagar'

    expect(page).to have_notice 'Forma de Pagamento apagada com sucesso.'

    expect(page).to_not have_content 'Cheque'
  end

  scenario 'index with columns at the index' do
    PaymentMethod.make!(:dinheiro)

    navigate 'Cadastro > Formas de Pagamento'

    within_records do
      expect(page).to have_content 'Descrição'

      within 'tbody tr' do
        expect(page).to have_content ''
      end
    end
  end
end
