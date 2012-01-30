# encoding: utf-8
require 'spec_helper'

feature "LegalNatures" do
  background do
    sign_in
  end


  def make_legal_natures!
    LegalNature.make!(:administracao_publica)
    LegalNature.make!(:executivo_federal)
  end
end
