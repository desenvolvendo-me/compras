# encoding: utf-8
require 'spec_helper'

feature "Prefecture" do
  background do
    sign_in
  end

  scenario 'create a new prefecture' do
    Street.make!(:bento_goncalves)

    click_link 'Cadastros Diversos'

    click_link 'Prefeitura'

    within_tab 'Prefeitura' do
      fill_in 'Nome', :with => 'Prefeitura Municipal de Porto Alegre'
      fill_in 'CNPJ', :with => '39.067.716/0001-41'

      fill_in 'Telefone', :with => '(56) 2345-9876'
      fill_in 'Fax', :with => '(56) 1234-5432'
      fill_in 'E-mail', :with => 'curitiba@curitiba.com.br'
      fill_in 'Prefeito', :with => 'Prefeito de Porto Alegre'
    end

    within_tab 'Endereço' do
      fill_modal 'Logradouro', :with => 'Bento Gonçalves'
      fill_modal 'Bairro', :with => 'Portugal'
      fill_in 'CEP', :with => '33400-500'
    end

    click_button 'Salvar'

    page.should have_notice 'Prefeitura criada com sucesso.'

    within_tab 'Prefeitura' do
      page.should have_field 'Nome', :with => 'Prefeitura Municipal de Porto Alegre'
      page.should have_field 'CNPJ', :with => '39.067.716/0001-41'

      page.should have_field 'Telefone', :with => '(56) 2345-9876'
      page.should have_field 'Fax', :with => '(56) 1234-5432'
      page.should have_field 'E-mail', :with => 'curitiba@curitiba.com.br'
      page.should have_field 'Prefeito', :with => 'Prefeito de Porto Alegre'
    end

    within_tab 'Endereço' do
      page.should have_field 'Logradouro', :with => 'Rua Bento Gonçalves'
      page.should have_field 'Bairro', :with => 'Portugal'
      page.should have_field 'CEP', :with => '33400-500'
    end
  end

  scenario 'update an existent prefecture' do
    Street.make!(:bento_goncalves)
    Prefecture.make!(:belo_horizonte)

    click_link 'Cadastros Diversos'

    click_link 'Prefeitura'

    within_tab 'Prefeitura' do
      fill_in 'Nome', :with => 'Prefeitura Municipal de Porto Alegre'
      fill_in 'CNPJ', :with => '39.067.716/0001-41'

      fill_in 'Telefone', :with => '(56) 2345-9876'
      fill_in 'Fax', :with => '(56) 1234-5432'
      fill_in 'E-mail', :with => 'curitiba@curitiba.com.br'
      fill_in 'Prefeito', :with => 'Prefeito de Porto Alegre'

      attach_file 'Logo', "#{Rails.root}/spec/fixtures/example_of_image.gif"
    end

    within_tab 'Endereço' do
      fill_modal 'Logradouro', :with => 'Bento Gonçalves'
      fill_modal 'Bairro', :with => 'Portugal'
      fill_in 'CEP', :with => '33400-500'
    end

    click_button 'Salvar'

    page.should have_notice 'Prefeitura editada com sucesso.'

    within_tab 'Prefeitura' do
      page.should have_field 'Nome', :with => 'Prefeitura Municipal de Porto Alegre'

      # this is randomly failing on CI
      Capybara.using_wait_time 30 do
        page.should have_field 'CNPJ', :with => '39.067.716/0001-41'
      end

      page.should have_field 'Telefone', :with => '(56) 2345-9876'
      page.should have_field 'Fax', :with => '(56) 1234-5432'
      page.should have_field 'E-mail', :with => 'curitiba@curitiba.com.br'
      page.should have_field 'Prefeito', :with => 'Prefeito de Porto Alegre'
    end

    within_tab 'Endereço' do
      page.should have_field 'Logradouro', :with => 'Rua Bento Gonçalves'
      page.should have_field 'Bairro', :with => 'Portugal'
      page.should have_field 'CEP', :with => '33400-500'
    end
  end
end
