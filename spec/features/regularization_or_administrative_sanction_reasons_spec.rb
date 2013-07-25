# encoding: utf-8
require 'spec_helper'

feature "RegularizationOrAdministrativeSanctionReasons" do
  background do
    sign_in
  end

  scenario 'create a new regularization_or_administrative_sanction_reason, update and destroy an existing' do
    navigate 'Comum > Pessoas > Auxiliar > Motivos de Sanções Administrativas ou Regularizações'

    click_link 'Criar Motivo de Sanção Administrativa ou Regularização'

    fill_in 'Descrição', :with => 'Advertência por desistência parcial da proposta devidamente justificada'
    select 'Regularização', :from => 'Tipo'

    click_button 'Salvar'

    expect(page).to have_notice 'Motivo de Sanção Administrativa ou Regularização criado com sucesso.'

    click_link 'Advertência por desistência parcial da proposta devidamente justificada'

    expect(page).to have_field 'Descrição', :with => 'Advertência por desistência parcial da proposta devidamente justificada'
    expect(page).to have_select 'Tipo', :selected => 'Regularização'

    fill_in 'Descrição', :with => 'Ativação do registro cadastral'
    select 'Sanção administrativa', :from => 'Tipo'

    click_button 'Salvar'

    expect(page).to have_notice 'Motivo de Sanção Administrativa ou Regularização editado com sucesso.'

    click_link 'Ativação do registro cadastral'

    expect(page).to have_field 'Descrição', :with => 'Ativação do registro cadastral'
    expect(page).to have_select 'Tipo', :selected => 'Sanção administrativa'

    click_link 'Apagar'

    expect(page).to have_notice 'Motivo de Sanção Administrativa ou Regularização apagado com sucesso.'

    expect(page).to_not have_content 'Ativação do registro cadastral'
  end

  scenario 'index with columns at the index' do
    RegularizationOrAdministrativeSanctionReason.make!(:sancao_administrativa)

    navigate 'Comum > Pessoas > Auxiliar > Motivos de Sanções Administrativas ou Regularizações'

    within_records do
      expect(page).to have_content 'Descrição'
      expect(page).to have_content 'Tipo'

      within 'tbody tr' do
        expect(page).to have_content 'Advertência por desistência parcial da proposta devidamente justificada'
        expect(page).to have_content 'Sanção administrativa'
      end
    end
  end
end
