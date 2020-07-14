require 'spec_helper'

feature "Banks" do
  background do
    sign_in
  end

  scenario 'create, update and destroy a new bank' do
    navigate 'Cadastro > Cadastrais > Bancos > Bancos'

    click_link 'Criar Banco'

    fill_in 'Nome', :with => 'Banco do Brasil'
    fill_in 'Código', :with => '1'
    fill_in 'Sigla', :with => 'BB'

    click_button 'Salvar'

    expect(page).to have_notice 'Banco criado com sucesso.'

    click_link 'Banco do Brasil'

    expect(page).to have_field 'Nome', :with => 'Banco do Brasil'
    expect(page).to have_field 'Código', :with => '1'
    expect(page).to have_field 'Sigla', :with => 'BB'

    fill_in 'Nome', :with => 'Santander 1'
    fill_in 'Código', :with => '33'
    fill_in 'Sigla', :with => 'ST'

    click_button 'Salvar'

    expect(page).to have_notice 'Banco editado com sucesso.'

    click_link 'Santander 1'

    expect(page).to have_field 'Nome', :with => 'Santander 1'
    expect(page).to have_field 'Código', :with => '33'
    expect(page).to have_field 'Sigla', :with => 'ST'

    click_link 'Apagar'

    expect(page).to have_notice 'Banco apagado com sucesso.'

    expect(page).to_not have_content 'Santander 1'
  end

  scenario 'index with columns at the index' do
    navigate 'Cadastro > Cadastrais > Bancos > Bancos'

    within_records do
      expect(page).to have_content 'Nome'
      expect(page).to have_content 'Código'
      expect(page).to have_content 'Sigla'

      within 'tbody tr:nth-last-child(1)' do
        expect(page).to have_content 'Santander'
        expect(page).to have_content '33'
        expect(page).to have_content 'ST'
      end
    end
  end
end
