# encoding: utf-8
require 'spec_helper'

feature "RegularizationOrAdministrativeSanctionReasons" do
  background do
    sign_in
  end

  scenario 'create a new regularization_or_administrative_sanction_reason' do
    navigate 'Comum > Pessoas > Auxiliar > Motivos de Sanções Administrativas ou Regularizações'

    click_link 'Criar Motivo de Sanção Administrativa ou Regularização'

    fill_in 'Descrição', :with => 'Advertência por desistência parcial da proposta devidamente justificada'
    select 'Regularização', :from => 'Tipo'

    click_button 'Salvar'

    expect(page).to have_notice 'Motivo de Sanção Administrativa ou Regularização criado com sucesso.'

    click_link 'Advertência por desistência parcial da proposta devidamente justificada'

    expect(page).to have_field 'Descrição', :with => 'Advertência por desistência parcial da proposta devidamente justificada'
    expect(page).to have_select 'Tipo', :selected => 'Regularização'
  end

  scenario 'update an existent regularization_or_administrative_sanction_reason' do
    RegularizationOrAdministrativeSanctionReason.make!(:sancao_administrativa)

    navigate 'Comum > Pessoas > Auxiliar > Motivos de Sanções Administrativas ou Regularizações'

    click_link 'Advertência por desistência parcial da proposta devidamente justificada'

    fill_in 'Descrição', :with => 'Ativação do registro cadastral'
    select 'Sanção administrativa', :from => 'Tipo'

    click_button 'Salvar'

    expect(page).to have_notice 'Motivo de Sanção Administrativa ou Regularização editado com sucesso.'

    click_link 'Ativação do registro cadastral'

    expect(page).to have_field 'Descrição', :with => 'Ativação do registro cadastral'
    expect(page).to have_select 'Tipo', :selected => 'Sanção administrativa'
  end

  scenario 'destroy an existent regularization_or_administrative_sanction_reason' do
    RegularizationOrAdministrativeSanctionReason.make!(:sancao_administrativa)

    navigate 'Comum > Pessoas > Auxiliar > Motivos de Sanções Administrativas ou Regularizações'

    click_link 'Advertência por desistência parcial da proposta devidamente justificada'

    click_link 'Apagar'

    expect(page).to have_notice 'Motivo de Sanção Administrativa ou Regularização apagado com sucesso.'

    expect(page).to_not have_content 'Advertência por desistência parcial da proposta devidamente justificada'
  end
end
