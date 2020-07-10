require 'spec_helper'

feature "Employees" do
  background do
    sign_in
  end

  scenario 'create, update and destroy a new employee' do
    Person.make!(:sobrinho)

    navigate 'Configurações > Usuários > Funcionários'

    click_link 'Criar Funcionário'

    fill_modal 'Pessoa', :with => 'Gabriel Sobrinho'

    expect(page).to have_field 'E-mail', :with => 'gabriel.sobrinho@gmail.com', disabled: true
    expect(page).to have_field 'Telefone', :with => '(33) 3333-3333', disabled: true

    fill_modal 'Cargo', :with => 'Gerente'
    fill_in 'Matrícula', :with => '958473'
    expect(page).to have_field 'Telefone', :with => '(33) 3333-3333', disabled: true

    click_button 'Salvar'

    expect(page).to have_notice 'Funcionário criado com sucesso.'

    within_records do
      click_link 'Gabriel Sobrinho'
    end

    expect(page).to have_field 'Pessoa', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Cargo', :with => 'Gerente'
    expect(page).to have_field 'Matrícula', :with => '958473'

    expect(page).to have_field 'E-mail', :with => 'gabriel.sobrinho@gmail.com', disabled: true
    expect(page).to have_field 'Telefone', :with => '(33) 3333-3333', disabled: true

    fill_in 'Matrícula', :with => '123456'

    click_button 'Salvar'

    expect(page).to have_notice 'Funcionário editado com sucesso.'

    click_link 'Gabriel Sobrinho'

    expect(page).to have_field 'Pessoa', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Cargo', :with => 'Gerente'
    expect(page).to have_field 'Matrícula', :with => '123456'

    expect(page).to have_field 'E-mail', :with => 'gabriel.sobrinho@gmail.com', disabled: true
    expect(page).to have_field 'Telefone', :with => '(33) 3333-3333', disabled: true

    click_link 'Apagar'

    expect(page).to have_notice 'Funcionário apagado com sucesso.'

    within_records do
      expect(page).to_not have_content 'Gabriel Sobrinho'
      expect(page).to_not have_content '123456'
    end
  end

  scenario 'index with columns at the index' do
    Employee.make!(:sobrinho)

    navigate 'Configurações > Usuários > Funcionários'

    within_records do
      expect(page).to have_content 'Pessoa'
      expect(page).to have_content 'Cargo'
      expect(page).to have_content 'Matrícula'

      within 'tbody tr' do
        expect(page).to have_content 'Sobrinho'
        expect(page).to have_content 'Gerente'
        expect(page).to have_content '958473'
      end
    end
  end

  scenario 'Employee without email persisted in individual' do
    Employee.make!(:sobrinho, individual: Person.make!(:sobrinho_without_email).personable)

    navigate 'Configurações > Usuários > Funcionários'

    click_link 'Gabriel Sobrinho'

    expect(page).to have_field 'E-mail', :with => 'gabriel.sobrinho@gmail.com'
    expect(page).to have_field 'Telefone', :with => '(33) 3333-3333', disabled: true
  end

  scenario 'Employee with email persisted in individual' do
    Employee.make!(:sobrinho)

    navigate 'Configurações > Usuários > Funcionários'

    click_link 'Gabriel Sobrinho'

    expect(page).to have_field 'E-mail', :with => 'gabriel.sobrinho@gmail.com', disabled: true
    expect(page).to have_field 'Telefone', :with => '(33) 3333-3333', disabled: true
  end
end
