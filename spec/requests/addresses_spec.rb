# encoding: utf-8
require 'spec_helper'

feature "Addresses" do
  background do
    sign_in
  end

  scenario "filter neighborhood through street" do
    Street.make!(:amazonas)
    Street.make!(:girassol)

    navigate 'Outros > Prefeitura'

    within_tab 'Endereço' do
      expect(page).to have_disabled_field "Bairro"

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
  end

  scenario "fetch city and state from neighborhood" do
    Street.make!(:amazonas)
    Street.make!(:girassol)

    navigate 'Outros > Prefeitura'

    within_tab 'Endereço' do
      expect(page).to have_disabled_field "Bairro"

      fill_modal 'Logradouro', :with => 'Amazonas'
      fill_modal 'Bairro', :with => 'Portugal'

      expect(page).to have_field 'Cidade', :with => 'Porto Alegre'
      expect(page).to have_field 'Estado', :with => 'Rio Grande do Sul'
    end
  end
end
