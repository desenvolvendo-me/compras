# encoding: utf-8
require 'spec_helper'

feature "Prefecture" do
  background do
    sign_in
  end

  scenario 'create a new prefecture, update and destroy an existing' do
    Street.make!(:bento_goncalves)

    navigate 'Geral > Parâmetros > Organização'

    fill_in 'Nome', :with => 'Prefeitura Municipal de Porto Alegre'
    fill_in 'CNPJ', :with => '39.067.716/0001-41'
    fill_in 'Telefone', :with => '(56) 2345-9876'
    fill_in 'Fax', :with => '(56) 1234-5432'
    fill_in 'E-mail', :with => 'curitiba@curitiba.com.br'
    fill_in 'Responsável', :with => 'Prefeito de Porto Alegre'
    fill_modal 'Logradouro', :with => 'Bento Gonçalves'
    fill_modal 'Bairro', :with => 'Portugal'
    fill_in 'CEP', :with => '33400-500'
    check 'Permitir inserir processos passados?'

    click_button 'Salvar'

    expect(page).to have_notice 'Organização criada com sucesso.'

    expect(page).to have_field 'Nome', :with => 'Prefeitura Municipal de Porto Alegre'
    expect(page).to have_field 'CNPJ', :with => '39.067.716/0001-41'
    expect(page).to have_field 'Telefone', :with => '(56) 2345-9876'
    expect(page).to have_field 'Fax', :with => '(56) 1234-5432'
    expect(page).to have_field 'E-mail', :with => 'curitiba@curitiba.com.br'
    expect(page).to have_field 'Responsável', :with => 'Prefeito de Porto Alegre'
    expect(page).to have_field 'Logradouro', :with => 'Rua Bento Gonçalves'
    expect(page).to have_field 'Bairro', :with => 'Portugal'
    expect(page).to have_field 'CEP', :with => '33400-500'
    expect(page).to have_checked_field 'Permitir inserir processos passados?'


    fill_in 'Nome', :with => 'Prefeitura Municipal de Toledo'
    fill_in 'Telefone', :with => '(45) 3378-1785'
    fill_in 'Fax', :with => '(45) 3378-1785'
    fill_in 'E-mail', :with => 'toledo@toledo.com.br'
    fill_in 'Responsável', :with => 'Prefeito de Toledo'
    attach_file 'Logo', "#{Rails.root}/spec/fixtures/example_of_image.gif"
    check 'Permitir inserir processos passados?'

    click_button 'Salvar'

    expect(page).to have_notice 'Organização editada com sucesso.'
    expect(page).to have_field 'Nome', :with => 'Prefeitura Municipal de Toledo'

    # this is randomly failing on CI
    Capybara.using_wait_time 30 do
      expect(page).to have_field 'CNPJ', :with => '39.067.716/0001-41'
    end

    expect(page).to have_field 'Nome', :with => 'Prefeitura Municipal de Toledo'
    expect(page).to have_field 'Telefone', :with => '(45) 3378-1785'
    expect(page).to have_field 'Fax', :with => '(45) 3378-1785'
    expect(page).to have_field 'E-mail', :with => 'toledo@toledo.com.br'
    expect(page).to have_field 'Responsável', :with => 'Prefeito de Toledo'
    expect(page).to have_checked_field 'Permitir inserir processos passados?'

    uncheck 'Permitir inserir processos passados?'

    click_button 'Salvar'

    expect(page).to have_notice 'Organização editada com sucesso.'
    expect(page).to_not have_checked_field 'Permitir inserir processos passados?'
  end
end
