# encoding: utf-8
require 'spec_helper'

feature "RegulatoryActTypes" do
  background do
    sign_in
  end

  scenario 'create a new regulatory_act_type, update and destroy an existing' do
    navigate 'Comum > Legislação > Ato Regulamentador > Tipos de Ato Regulamentador'

    click_link 'Criar Tipo de Ato Regulamentador'

    expect(page).to_not have_disabled_field 'Descrição' 

    fill_in 'Descrição', :with => 'Lei'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo de Ato Regulamentador criado com sucesso.'

    click_link 'Lei'

    expect(page).to have_field 'Descrição', :with => 'Lei'

    fill_in 'Descrição', :with => 'Outra Lei'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo de Ato Regulamentador editado com sucesso.'

    click_link 'Outra Lei'

    expect(page).to have_field 'Descrição', :with => 'Outra Lei'

    click_link 'Apagar'

    expect(page).to have_notice 'Tipo de Ato Regulamentador apagado com sucesso.'

    expect(page).to_not have_content 'Outra Lei'
  end

  scenario 'cannot change imported regulatory_act_type' do
    RegulatoryActType.make!(:lei, imported: true)

    navigate 'Comum > Legislação > Ato Regulamentador > Tipos de Ato Regulamentador'

    click_link 'Lei'

    expect(page).to have_disabled_field 'Descrição'
    expect(page).to have_field 'Descrição', :with => 'Lei'

    expect(page).to_not have_button 'Salvar'
    expect(page).to_not have_link 'Apagar'
  end

  scenario 'index with columns at the index' do
    RegulatoryActType.make!(:lei)

    navigate 'Comum > Legislação > Ato Regulamentador > Tipos de Ato Regulamentador'

    within_records do
      expect(page).to have_content 'Descrição'

      within 'tbody tr' do
        expect(page).to have_content 'Lei'
      end
    end
  end
end
