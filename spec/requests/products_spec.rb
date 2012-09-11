# encoding: utf-8
require 'spec_helper'

feature 'Products' do
  background do
    sign_in
  end

  scenario 'create a new product' do
    navigate 'Contabilidade > Comum > Produtos'

    click_link 'Criar Produto'

    fill_in 'Especificação', :with => 'Papel A4'
    fill_in 'Observação', :with => 'Papel A4'

    click_button 'Salvar'

    expect(page).to have_notice 'Produto criado com sucesso.'

    within_records do
      page.find('a').click
    end

    expect(page).to have_field 'Especificação', :with => 'Papel A4'
    expect(page).to have_field 'Observação', :with => 'Papel A4'
  end

  scenario 'update an existing product' do
    Product.make!(:caneta)

    navigate 'Contabilidade > Comum > Produtos'

    within_records do
      page.find('a').click
    end

    fill_in 'Especificação', :with => 'Papel A4'
    fill_in 'Observação', :with => 'Papel A4'

    click_button 'Salvar'

    expect(page).to have_notice 'Produto editado com sucesso.'

    within_records do
      page.find('a').click
    end

    expect(page).to have_field 'Especificação', :with => 'Papel A4'
    expect(page).to have_field 'Observação', :with => 'Papel A4'
  end

  scenario 'destroy and existing product' do
    Product.make!(:caneta)

    navigate 'Contabilidade > Comum > Produtos'

    click_link 'Caneta'

    click_link 'Apagar'

    expect(page).to have_notice 'Produto apagado com sucesso.'

    expect(page).to_not have_link 'Caneta'
  end
end
