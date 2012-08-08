# encoding: utf-8
require 'spec_helper'

feature "LegalNatures" do
  background do
    sign_in
  end

  scenario 'list the legal natures' do
    LegalNature.make!(:administracao_publica)
    LegalNature.make!(:executivo_federal)

    navigate 'Compras e Licitações > Cadastros Gerais > Naturezas Jurídicas'

    within_records do
      expect(page).to have_content '100'
      expect(page).to have_content 'Administração Pública'

      expect(page).to have_content '1015'
      expect(page).to have_content 'Orgão Público do Poder Executivo Federal'
    end
  end
end
