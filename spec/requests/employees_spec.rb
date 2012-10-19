# encoding: utf-8
require 'spec_helper'

feature "Employees" do
  background do
    sign_in
  end

  scenario 'create a new employee' do
    Person.make!(:sobrinho)
    Position.make!(:gerente)

    navigate 'Cadastros Gerais > Pessoas > Funcionários'

    click_link 'Criar Funcionário'

    fill_modal 'Pessoa', :with => 'Gabriel Sobrinho'
    fill_modal 'Cargo', :with => 'Gerente'
    fill_in 'Matrícula', :with => '958473'

    click_button 'Salvar'

    expect(page).to have_notice 'Funcionário criado com sucesso.'

    within_records do
      click_link 'Gabriel Sobrinho'
    end

    expect(page).to have_field 'Pessoa', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Cargo', :with => 'Gerente'
    expect(page).to have_field 'Matrícula', :with => '958473'
  end

  scenario 'update an existent employee' do
    Person.make!(:wenderson)
    Employee.make!(:sobrinho)
    Position.make!(:supervisor)

    navigate 'Cadastros Gerais > Pessoas > Funcionários'

    within_records do
      click_link 'Gabriel Sobrinho'
    end

    fill_modal 'Pessoa', :with => 'Wenderson Malheiros'
    fill_modal 'Cargo', :with => 'Supervisor'
    fill_in 'Matrícula', :with => '123456'

    click_button 'Salvar'

    expect(page).to have_notice 'Funcionário editado com sucesso.'

    click_link 'Wenderson Malheiros'

    expect(page).to have_field 'Pessoa', :with => 'Wenderson Malheiros'
    expect(page).to have_field 'Cargo', :with => 'Supervisor'
    expect(page).to have_field 'Matrícula', :with => '123456'
  end

  scenario 'destroy an existent employee' do
    Employee.make!(:sobrinho)

    navigate 'Cadastros Gerais > Pessoas > Funcionários'

    within_records do
      click_link 'Gabriel Sobrinho'
    end

    click_link 'Apagar'

    expect(page).to have_notice 'Funcionário apagado com sucesso.'

    within_records do
      expect(page).to_not have_content 'Gabriel Sobrinho'
      expect(page).to_not have_content '958473'
    end
  end

  scenario 'should validate uniqueness of person' do
    Employee.make!(:sobrinho)

    navigate 'Cadastros Gerais > Pessoas > Funcionários'

    click_link 'Criar Funcionário'

    fill_modal 'Pessoa', :with => 'Gabriel Sobrinho'

    click_button 'Salvar'

    expect(page).to have_content "já está em uso"
  end

  scenario 'should validate uniqueness of registration' do
    Employee.make!(:sobrinho)

    navigate 'Cadastros Gerais > Pessoas > Funcionários'

    click_link 'Criar Funcionário'

    fill_in 'Matrícula', :with => '958473'

    click_button 'Salvar'

    expect(page).to have_content "já está em uso"
  end
end
