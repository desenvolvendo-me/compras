# encoding: utf-8
require 'spec_helper'

feature "LicitationObjects" do
  background do
    sign_in
  end

  scenario 'create a new licitation_object' do
    Material.make!(:antivirus)

    click_link 'Contabilidade'

    click_link 'Objetos de Licitação'

    click_link 'Criar Objeto de Licitação'

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2012'
      fill_in 'Descrição', :with => 'Ponte'
    end

    within_tab 'Total acumulado' do
      within_fieldset 'Total acumulado de compras e serviços' do
        page.should have_disabled_field  'Dispensa de licitação'
        page.should have_disabled_field  'Carta convite'
        page.should have_disabled_field  'Tomada de preço'
        page.should have_disabled_field  'Concorrência pública'

        page.should have_field 'Dispensa de licitação', :with => '0,00'
        page.should have_field 'Carta convite', :with => '0,00'
        page.should have_field 'Tomada de preço', :with => '0,00'
        page.should have_field 'Concorrência pública', :with => '0,00'
      end

      within_fieldset 'Total acumulado de obras e engenharia' do
        page.should have_disabled_field  'Dispensa de licitação'
        page.should have_disabled_field  'Carta convite'
        page.should have_disabled_field  'Tomada de preço'
        page.should have_disabled_field  'Concorrência pública'

        page.should have_field 'Dispensa de licitação', :with => '0,00'
        page.should have_field 'Carta convite', :with => '0,00'
        page.should have_field 'Tomada de preço', :with => '0,00'
        page.should have_field 'Concorrência pública', :with => '0,00'
      end

      within_fieldset 'Total acumulado de modalidades especiais' do
        page.should have_disabled_field  'Leilão'
        page.should have_disabled_field  'Inexigibilidade'
        page.should have_disabled_field  'Concurso'
        
        page.should have_field 'Leilão', :with => '0,00'
        page.should have_field 'Inexigibilidade', :with => '0,00'
        page.should have_field 'Concurso', :with => '0,00'
      end
    end

    within_tab 'Materiais' do
      fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'
    end

    click_button 'Criar Objeto de Licitação'

    page.should have_notice 'Objeto de Licitação criado com sucesso.'

    click_link 'Ponte'

    within_tab 'Principal' do
      page.should have_field 'Ano', :with => '2012'
      page.should have_field 'Descrição', :with => 'Ponte'
    end

    within_tab 'Total acumulado' do
      within_fieldset 'Total acumulado de compras e serviços' do
        page.should have_disabled_field  'Dispensa de licitação'
        page.should have_disabled_field  'Carta convite'
        page.should have_disabled_field  'Tomada de preço'
        page.should have_disabled_field  'Concorrência pública'

        page.should have_field 'Dispensa de licitação', :with => '0,00'
        page.should have_field 'Carta convite', :with => '0,00'
        page.should have_field 'Tomada de preço', :with => '0,00'
        page.should have_field 'Concorrência pública', :with => '0,00'
      end

      within_fieldset 'Total acumulado de obras e engenharia' do
        page.should have_disabled_field  'Dispensa de licitação'
        page.should have_disabled_field  'Carta convite'
        page.should have_disabled_field  'Tomada de preço'
        page.should have_disabled_field  'Concorrência pública'

        page.should have_field 'Dispensa de licitação', :with => '0,00'
        page.should have_field 'Carta convite', :with => '0,00'
        page.should have_field 'Tomada de preço', :with => '0,00'
        page.should have_field 'Concorrência pública', :with => '0,00'
      end

      within_fieldset 'Total acumulado de modalidades especiais' do
        page.should have_disabled_field  'Leilão'
        page.should have_disabled_field  'Inexigibilidade'
        page.should have_disabled_field  'Concurso'
        
        page.should have_field 'Leilão', :with => '0,00'
        page.should have_field 'Inexigibilidade', :with => '0,00'
        page.should have_field 'Concurso', :with => '0,00'
      end
    end

    within_tab 'Materiais' do
      page.should have_content 'Antivirus'
    end
  end

  scenario 'should remove material' do
    LicitationObject.make!(:viaduto)

    click_link 'Contabilidade'

    click_link 'Objetos de Licitação'

    click_link 'Viaduto'

    within_tab 'Materiais' do
      page.should have_content 'Arame comum'
      click_button 'Remover material'
    end

    click_button 'Atualizar Objeto de Licitação'

    page.should have_notice 'Objeto de Licitação editado com sucesso.'

    click_link 'Viaduto'

    within_tab 'Materiais' do
      page.should_not have_content 'Arame comum'
    end
  end

  scenario 'update an existent licitation_object' do
    LicitationObject.make!(:ponte)
    Material.make!(:arame_comum)

    click_link 'Contabilidade'

    click_link 'Objetos de Licitação'

    click_link 'Ponte'

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2013'
      fill_in 'Descrição', :with => 'Viaduto'
    end

    within_tab 'Materiais' do
      fill_modal 'Material', :with => 'Arame comum', :field => 'Descrição'
    end

    click_button 'Atualizar Objeto de Licitação'

    page.should have_notice 'Objeto de Licitação editado com sucesso.'

    click_link 'Viaduto'

    within_tab 'Principal' do
      page.should have_field 'Ano', :with => '2013'
      page.should have_field 'Descrição', :with => 'Viaduto'
    end

    within_tab 'Materiais' do
      page.should have_content 'Arame comum'
    end
  end

  scenario 'destroy an existent licitation_object' do
    LicitationObject.make!(:ponte)

    click_link 'Contabilidade'

    click_link 'Objetos de Licitação'

    click_link 'Ponte'

    click_link 'Apagar Ponte', :confirm => true

    page.should have_notice 'Objeto de Licitação apagado com sucesso.'

    page.should_not have_content 'Ponte'
    page.should_not have_content '2012'
  end

  scenario 'validate uniqueness of description and year together' do
    LicitationObject.make!(:ponte)

    click_link 'Contabilidade'

    click_link 'Objetos de Licitação'

    click_link 'Criar Objeto de Licitação'

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2012'
      fill_in 'Descrição', :with => 'Ponte'
    end

    click_button 'Criar Objeto de Licitação'

    within_tab 'Principal' do
      page.should have_content 'já existe para o ano informado'
    end
  end
end
