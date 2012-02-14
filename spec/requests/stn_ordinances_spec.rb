# encoding: utf-8
require 'spec_helper'

feature "StnOrdinances" do
  background do
    sign_in
  end

  scenario 'create a new stn_ordinance' do
    click_link 'Cadastros Diversos'

    click_link 'Portarias do STN'

    click_link 'Criar Portaria do STN'

    fill_in 'Descrição', :with => 'Portaria Geral'

    click_button 'Criar Portaria do STN'

    page.should have_notice 'Portaria do STN criada com sucesso.'

    click_link 'Portaria Geral'

    page.should have_field 'Descrição', :with => 'Portaria Geral'
  end

  scenario 'update an existent stn_ordinance' do
    StnOrdinance.make!(:geral)

    click_link 'Cadastros Diversos'

    click_link 'Portarias do STN'

    click_link 'Portaria Geral'

    fill_in 'Descrição', :with => 'Portarial Alternativa'

    click_button 'Atualizar Portaria do STN'

    page.should have_notice 'Portaria do STN editada com sucesso.'

    click_link 'Portarial Alternativa'

    page.should have_field 'Descrição', :with => 'Portarial Alternativa'
  end

  scenario 'destroy an existent stn_ordinance' do
    StnOrdinance.make!(:geral)
    click_link 'Cadastros Diversos'

    click_link 'Portarias do STN'

    click_link 'Portaria Geral'

    click_link 'Apagar Portaria Geral', :confirm => true

    page.should have_notice 'Portaria do STN apagada com sucesso.'

    page.should_not have_content 'description'
  end

  scenario 'validates uniqueness of description' do
    StnOrdinance.make!(:geral)

    click_link 'Cadastros Diversos'

    click_link 'Portarias do STN'

    click_link 'Criar Portaria do STN'

    fill_in 'Descrição', :with => 'Portaria Geral'

    click_button 'Criar Portaria do STN'

    page.should have_content 'já está em uso'
  end
end
