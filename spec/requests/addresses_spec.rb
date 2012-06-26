# encoding: utf-8
require 'spec_helper'

feature "Addresses" do
  background do
    sign_in
  end

  scenario "new address through prefecture" do
    Street.make!(:amazonas)
    Street.make!(:girassol)

    navigate_through  'Outros > Prefeitura'

    within_tab 'Endereço' do
      page.should have_disabled_field "Bairro"

      fill_modal 'Logradouro', :with => 'Amazonas'

      within_modal 'Bairro' do
        click_button 'Pesquisar'

        # 'Amazonas' is located in 'Portugal'
        # 'Girassol' is located in 'Centro' and 'São Francisco'
        page.should have_content 'Portugal'
        page.should_not have_content 'Girassol'

        click_record 'Portugal'
      end

      page.should have_field 'Cidade', :with => 'Porto Alegre'
      page.should have_field 'Estado', :with => 'Rio Grande do Sul'
    end
  end

  scenario "edit address through prefecture" do
    Prefecture.make!(:belo_horizonte)
    Street.make!(:amazonas)

    navigate_through  'Outros > Prefeitura'

    within_tab 'Endereço' do
      page.should have_field 'Cidade', :with => 'Curitiba'
      page.should have_field 'Estado', :with => 'Parana'

      page.should_not have_disabled_field "Bairro"

      fill_modal 'Logradouro', :with => 'Amazonas'

      find_field('Bairro').value.should be_empty
    end
  end
end
