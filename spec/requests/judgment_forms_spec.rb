# encoding: utf-8
require 'spec_helper'

feature "JudgmentForms" do
  background do
    sign_in
  end

  scenario 'cannot create a new judgment_form' do
    navigate 'Processos de Compra > Auxiliar > Formas de Julgamento das Licitações'

    expect(page).to_not have_link 'Criar Forma de Julgamento de Licitação'
    expect(page).to_not have_link 'Filtrar Formas de Julgamento de Licitação'
  end

  scenario 'enable and disable judgment_forms through ajax' do
    judgment1 = JudgmentForm.make!(:global_com_menor_preco)
    judgment2 = JudgmentForm.make!(:por_item_com_melhor_tecnica)
    judgment3 = JudgmentForm.make!(:por_lote_com_melhor_tecnica)

    navigate 'Processos de Compra > Auxiliar > Formas de Julgamento das Licitações'

    within_records do
      uncheck "judgment_form_#{judgment1.id}"
      uncheck "judgment_form_#{judgment2.id}"
    end

    navigate 'Processos de Compra > Auxiliar > Formas de Julgamento das Licitações'

    within_records do
      expect(page).to_not have_checked_field "judgment_form_#{judgment1.id}"
      expect(page).to_not have_checked_field "judgment_form_#{judgment2.id}"
      expect(page).to have_checked_field "judgment_form_#{judgment3.id}"

      check "judgment_form_#{judgment2.id}"
    end

    within_records do
      expect(page).to_not have_checked_field "judgment_form_#{judgment1.id}"
      expect(page).to have_checked_field "judgment_form_#{judgment2.id}"
      expect(page).to have_checked_field "judgment_form_#{judgment3.id}"
    end
  end
end
