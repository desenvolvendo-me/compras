# encoding: utf-8
require 'spec_helper'

feature 'TargetAudiences' do
  background do
    sign_in
  end

  scenario 'create a new target_audience' do
    navigate 'Comum > Públicos Alvo'

    click_link 'Criar Público Alvo'

    fill_in 'Especificação', :with => 'Alunos da rede estudantil'
    fill_in 'Observação', :with => 'Alunos da rede pública'

    click_button 'Salvar'

    expect(page).to have_notice 'Público Alvo criado com sucesso.'

    within_records do
      page.find('a').click
    end

    expect(page).to have_field 'Especificação', :with => 'Alunos da rede estudantil'
    expect(page).to have_field 'Observação', :with => 'Alunos da rede pública'
  end

  scenario 'update an existing program_kind' do
    TargetAudience.make!(:professores_publicos)

    navigate 'Comum > Públicos Alvo'

    within_records do
      page.find('a').click
    end

    fill_in 'Especificação', :with => 'Alunos da rede estudantil'
    fill_in 'Observação', :with => 'Alunos da rede pública'

    click_button 'Salvar'

    expect(page).to have_notice 'Público Alvo editado com sucesso.'

    within_records do
      page.find('a').click
    end

    expect(page).to have_field 'Especificação', :with => 'Alunos da rede estudantil'
    expect(page).to have_field 'Observação', :with => 'Alunos da rede pública'
  end

  scenario 'destroy and existing program_kind' do
    TargetAudience.make!(:professores_publicos)

    navigate 'Comum > Públicos Alvo'

    click_link 'Professores Públicos'

    click_link 'Apagar'

    expect(page).to have_notice 'Público Alvo apagado com sucesso.'

    expect(page).to_not have_link 'Professores Públicos'
  end
end
