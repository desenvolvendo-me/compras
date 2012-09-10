# encoding: utf-8
require 'spec_helper'

feature "Districts" do
  background do
    sign_in
  end

  scenario 'create a new district' do
    City.make!(:belo_horizonte)

    navigate 'Outros > Distritos'

    click_link 'Criar Distrito'

    fill_in 'Nome', :with => 'Leste'
    fill_modal 'Cidade', :with => "Belo Horizonte"

    click_button 'Salvar'

    expect(page).to have_notice 'Distrito criado com sucesso.'

    click_link 'Leste'

    expect(page).to have_field 'Nome', :with => 'Leste'
    expect(page).to have_field 'Cidade', :with => 'Belo Horizonte'
  end

  scenario 'update a district' do
    District.make!(:sul)

    navigate 'Outros > Distritos'

    click_link 'Sul'

    fill_in 'Nome', :with => 'Oeste'

    click_button 'Salvar'

    expect(page).to have_notice 'Distrito editado com sucesso.'

    click_link 'Oeste'

    expect(page).to have_field 'Nome', :with => 'Oeste'
  end

  scenario 'destroy a district' do
    District.make!(:sul)

    navigate 'Outros > Distritos'

    click_link 'Sul'

    click_link 'Apagar'

    expect(page).to have_notice 'Distrito apagado com sucesso.'

    expect(page).not_to have_content 'Sul'
  end
end
