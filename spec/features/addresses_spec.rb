require 'spec_helper'

feature "Addresses" do
  background do
    sign_in
  end

  scenario "filter neighborhood through street" do
    Street.make!(:amazonas)
    Street.make!(:girassol)

    navigate 'Configurações > Parâmetros > Organização'

    expect(page).to have_field "Bairro", disabled: true

    fill_modal 'Logradouro', :with => 'Amazonas'

    within_modal 'Bairro' do
      click_button 'Pesquisar'

      # 'Amazonas' is located in 'Portugal'
      # 'Girassol' is located in 'Centro' and 'São Francisco'
      expect(page).to have_content 'Portugal'
      expect(page).to_not have_content 'Girassol'

      click_record 'Portugal'
    end
  end

  scenario "fetch city and state from neighborhood" do
    Street.make!(:amazonas)
    Street.make!(:girassol)

    navigate 'Configurações > Parâmetros > Organização'

    expect(page).to have_field "Bairro", disabled: true

    fill_modal 'Logradouro', :with => 'Amazonas'
    fill_modal 'Bairro', :with => 'Portugal'

    expect(page).to have_field 'Cidade', :with => 'Porto Alegre', disabled: true
    expect(page).to have_field 'Estado', :with => 'Rio Grande do Sul', disabled: true
  end
end
