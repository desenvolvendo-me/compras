# encoding: utf-8
require 'spec_helper'

feature 'TargetAudiences' do
  background do
    sign_in
  end

  scenario 'create a new target_audience' do
    navigate 'Contabilidade > Comum > Públicos Alvo'

    click_link 'Criar Público Alvo'

    fill_in 'Especificação', :with => 'Alunos da rede estudantil'
    fill_in 'Observação', :with => 'Alunos da rede pública'

    click_button 'Salvar'

    page.should have_notice 'Público Alvo criado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Especificação', :with => 'Alunos da rede estudantil'
    page.should have_field 'Observação', :with => 'Alunos da rede pública'
  end

  scenario 'update an existing program_kind' do
    TargetAudience.make!(:professores_publicos)

    navigate 'Contabilidade > Comum > Públicos Alvo'

    within_records do
      page.find('a').click
    end

    fill_in 'Especificação', :with => 'Alunos da rede estudantil'
    fill_in 'Observação', :with => 'Alunos da rede pública'

    click_button 'Salvar'

    page.should have_notice 'Público Alvo editado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Especificação', :with => 'Alunos da rede estudantil'
    page.should have_field 'Observação', :with => 'Alunos da rede pública'
  end

  scenario 'destroy and existing program_kind' do
    TargetAudience.make!(:professores_publicos)

    navigate 'Contabilidade > Comum > Públicos Alvo'

    click_link 'Professores Públicos'

    click_link 'Apagar'

    page.should have_notice 'Público Alvo apagado com sucesso.'

    page.should_not have_link 'Professores Públicos'
  end
end
