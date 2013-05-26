# encoding: utf-8
require 'spec_helper'

feature "LicitationObjects" do
  background do
    sign_in
  end

  scenario 'create a new licitation_object' do
    Material.make!(:antivirus)

    navigate 'Comum > Auxiliar > Objetos de Licitação'

    click_link "Limpar Filtro"

    click_link 'Criar Objeto de Licitação'

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2012'
      fill_in 'Descrição', :with => 'Ponte'
    end

    within_tab 'Total acumulado' do
      within_fieldset 'Total acumulado de compras e serviços' do
        expect(page).to have_disabled_field  'Carta convite'
        expect(page).to have_disabled_field  'Tomada de preço'
        expect(page).to have_disabled_field  'Concorrência pública'

        expect(page).to have_field 'Carta convite', :with => '0,00'
        expect(page).to have_field 'Tomada de preço', :with => '0,00'
        expect(page).to have_field 'Concorrência pública', :with => '0,00'
      end

      within_fieldset 'Total acumulado de obras e engenharia' do
        expect(page).to have_disabled_field  'Carta convite'
        expect(page).to have_disabled_field  'Tomada de preço'
        expect(page).to have_disabled_field  'Concorrência pública'

        expect(page).to have_field 'Carta convite', :with => '0,00'
        expect(page).to have_field 'Tomada de preço', :with => '0,00'
        expect(page).to have_field 'Concorrência pública', :with => '0,00'
      end

      within_fieldset 'Total acumulado de modalidades especiais' do
        expect(page).to have_disabled_field  'Leilão'
        expect(page).to have_disabled_field  'Inexigibilidade'
        expect(page).to have_disabled_field  'Concurso'

        expect(page).to have_field 'Leilão', :with => '0,00'
        expect(page).to have_field 'Inexigibilidade', :with => '0,00'
        expect(page).to have_field 'Concurso', :with => '0,00'
      end
    end

    within_tab 'Materiais' do
      fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'

      expect(page).to have_content '01.01.00001'
      expect(page).to have_content 'Antivirus'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Objeto de Licitação criado com sucesso.'

    click_link "Limpar Filtro"

    click_link 'Ponte'

    within_tab 'Principal' do
      expect(page).to have_field 'Ano', :with => '2012'
      expect(page).to have_field 'Descrição', :with => 'Ponte'
    end

    within_tab 'Total acumulado' do
      within_fieldset 'Total acumulado de compras e serviços' do
        expect(page).to have_disabled_field  'Carta convite'
        expect(page).to have_disabled_field  'Tomada de preço'
        expect(page).to have_disabled_field  'Concorrência pública'

        expect(page).to have_field 'Carta convite', :with => '0,00'
        expect(page).to have_field 'Tomada de preço', :with => '0,00'
        expect(page).to have_field 'Concorrência pública', :with => '0,00'
      end

      within_fieldset 'Total acumulado de obras e engenharia' do
        expect(page).to have_disabled_field  'Carta convite'
        expect(page).to have_disabled_field  'Tomada de preço'
        expect(page).to have_disabled_field  'Concorrência pública'

        expect(page).to have_field 'Carta convite', :with => '0,00'
        expect(page).to have_field 'Tomada de preço', :with => '0,00'
        expect(page).to have_field 'Concorrência pública', :with => '0,00'
      end

      within_fieldset 'Total acumulado de modalidades especiais' do
        expect(page).to have_disabled_field  'Leilão'
        expect(page).to have_disabled_field  'Inexigibilidade'
        expect(page).to have_disabled_field  'Concurso'

        expect(page).to have_field 'Leilão', :with => '0,00'
        expect(page).to have_field 'Inexigibilidade', :with => '0,00'
        expect(page).to have_field 'Concurso', :with => '0,00'
      end
    end

    within_tab 'Materiais' do
      expect(page).to have_content 'Antivirus'
    end
  end

  scenario 'should remove material' do
    LicitationObject.make!(:viaduto)

    navigate 'Comum > Auxiliar > Objetos de Licitação'

    click_link "Limpar Filtro"

    click_link 'Viaduto'

    within_tab 'Materiais' do
      expect(page).to have_content 'Arame comum'
      click_button 'Remover Material'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Objeto de Licitação editado com sucesso.'

    click_link "Limpar Filtro"

    click_link 'Viaduto'

    within_tab 'Materiais' do
      expect(page).to_not have_content 'Arame comum'
    end
  end

  scenario 'update an existent licitation_object' do
    LicitationObject.make!(:ponte)
    Material.make!(:arame_comum)

    navigate 'Comum > Auxiliar > Objetos de Licitação'

    click_link "Limpar Filtro"

    click_link 'Ponte'

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2013'
      fill_in 'Descrição', :with => 'Viaduto'
    end

    within_tab 'Materiais' do
      fill_modal 'Material', :with => 'Arame comum', :field => 'Descrição'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Objeto de Licitação editado com sucesso.'

    click_link "Limpar Filtro"

    click_link 'Viaduto'

    within_tab 'Principal' do
      expect(page).to have_field 'Ano', :with => '2013'
      expect(page).to have_field 'Descrição', :with => 'Viaduto'
    end

    within_tab 'Materiais' do
      expect(page).to have_content 'Arame comum'
    end
  end

  scenario 'destroy an existent licitation_object' do
    LicitationObject.make!(:ponte)

    navigate 'Comum > Auxiliar > Objetos de Licitação'

    click_link "Limpar Filtro"

    click_link 'Ponte'

    click_link 'Apagar'

    expect(page).to have_notice 'Objeto de Licitação apagado com sucesso.'

    expect(page).to_not have_content 'Ponte'
    expect(page).to_not have_content '2012'
  end
end
