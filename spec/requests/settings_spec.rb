# encoding: utf-8
require 'spec_helper'

feature "Settings" do
  background do
    sign_in
  end

  scenario 'update a setting' do
    Setting.make!(:default_city)

    navigate_through 'Outros > Configurações'

    click_link 'Cidade padrão'

    page.should have_field 'Chave', :with => 'Cidade padrão'

    fill_in 'Valor', :with => '1'

    click_button 'Salvar'

    page.should have_notice 'Configuração editada com sucesso.'

    click_link 'Cidade padrão'

    page.should have_field 'Valor', :with => '1'
  end
end
