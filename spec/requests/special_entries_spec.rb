# encoding: utf-8
require 'spec_helper'

feature "SpecialEntries" do
  background do
    sign_in
  end

  scenario 'create a new special_entry' do
    navigate 'Cadastros Gerais > Pessoas > Inscrições Especiais'

    click_link 'Criar Inscrição Especial'

    fill_in 'Nome', :with => 'Tal'

    click_button 'Salvar'

    expect(page).to have_notice 'Inscrição Especial criado com sucesso.'

    click_link 'Tal'

    expect(page).to have_field 'Nome', :with => 'Tal'
  end

  scenario 'update an existent special_entry' do
    SpecialEntry.make!(:example)

    navigate 'Cadastros Gerais > Pessoas > Inscrições Especiais'

    click_link 'Tal'

    fill_in 'Nome', :with => 'Fulano'

    click_button 'Salvar'

    expect(page).to have_notice 'Inscrição Especial editado com sucesso.'

    click_link 'Fulano'

    expect(page).to have_field 'Nome', :with => 'Fulano'
  end

  scenario 'destroy an existent special_entry' do
    SpecialEntry.make!(:example)

    navigate 'Cadastros Gerais > Pessoas > Inscrições Especiais'

    click_link 'Tal'

    click_link 'Apagar'

    expect(page).to have_notice 'Inscrição Especial apagado com sucesso.'

    expect(page).to_not have_content 'Tal'
  end
end
