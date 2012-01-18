# encoding: utf-8
require 'spec_helper'

feature "WorkingHours" do
  background do
    sign_in
  end

  scenario 'create a new working hour without interval' do
    click_link 'Parâmetros para Cálculos'

    click_link 'Horários de Funcionamento das Atividades Econômicas'

    click_link 'Criar Horário de Funcionamento de Atividade Econômica'

    fill_in 'Nome', :with => 'Extraordinário'
    fill_mask 'Horário inicial', :with => '09:00'
    fill_mask 'Fim do expediente', :with => '09:00'

    click_button 'Criar Horário de Funcionamento de Atividade Econômica'

    page.should have_notice 'Horário de Funcionamento de Atividade Econômica criado com sucesso.'

    click_link 'Extraordinário'

    page.should have_field 'Nome', :with => 'Extraordinário'
    page.should have_field 'Horário inicial', :with => '09:00'
    page.should have_field 'Fim do expediente', :with => '09:00'
  end

  scenario 'create a new working_hour' do
    click_link 'Parâmetros para Cálculos'

    click_link 'Horários de Funcionamento das Atividades Econômicas'

    click_link 'Criar Horário de Funcionamento de Atividade Econômica'

    fill_in 'Nome', :with => 'Extraordinário'
    fill_mask 'Horário inicial', :with => '09:00'
    fill_mask 'Início do intervalo', :with => '09:00'
    fill_mask 'Fim do intervalo', :with => '09:00'
    fill_mask 'Fim do expediente', :with => '09:00'

    click_button 'Criar Horário de Funcionamento de Atividade Econômica'

    page.should have_notice 'Horário de Funcionamento de Atividade Econômica criado com sucesso.'

    click_link 'Extraordinário'

    page.should have_field 'Nome', :with => 'Extraordinário'
    page.should have_field 'Horário inicial', :with => '09:00'
    page.should have_field 'Início do intervalo', :with => '09:00'
    page.should have_field 'Fim do intervalo', :with => '09:00'
    page.should have_field 'Fim do expediente', :with => '09:00'
  end

  scenario 'update an existent working_hour' do
    WorkingHour.make!(:normal)

    click_link 'Parâmetros para Cálculos'

    click_link 'Horários de Funcionamento das Atividades Econômicas'

    click_link 'Normal'

    fill_in 'Nome', :with => 'Atípico'

    click_button 'Atualizar Horário de Funcionamento de Atividade Econômica'

    page.should have_notice 'Horário de Funcionamento de Atividade Econômica editado com sucesso.'

    click_link 'Atípico'

    page.should have_field 'Nome', :with => 'Atípico'
  end

  scenario 'destroy an existent working_hour' do
    WorkingHour.make!(:facultativo)

    click_link 'Parâmetros para Cálculos'

    click_link 'Horários de Funcionamento das Atividades Econômicas'

    click_link 'Facultativo'

    click_link 'Apagar Facultativo', :confirm => true

    page.should have_notice 'Horário de Funcionamento de Atividade Econômica apagado com sucesso.'

    page.should_not have_content 'Facultativo'
  end
end
