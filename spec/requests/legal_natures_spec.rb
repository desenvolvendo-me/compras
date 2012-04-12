# encoding: utf-8
require 'spec_helper'

feature "LegalNatures" do
  background do
    sign_in
  end

  scenario 'list the legal natures' do
    LegalNature.make!(:administracao_publica)
    LegalNature.make!(:executivo_federal)

    click_link 'Cadastros Diversos'

    click_link 'Naturezas Jurídicas'

    within_records do
      page.should have_content 'Administração Pública'

      page.should have_content 'Orgão Público do Poder Executivo Federal'
    end
  end
end
