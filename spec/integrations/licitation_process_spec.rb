# encoding: UTF-8
require 'spec_helper'

describe LicitationProcess do
  it 'auto increment process by year' do
    licitation_2012 = LicitationProcess.make(:processo_licitatorio)
    licitation_2012.save!
    expect(licitation_2012.process).to eq 1

    licitation_2013 = LicitationProcess.make(:processo_licitatorio_computador)
    licitation_2013.save!
    expect(licitation_2013.process).to eq 1

    licitation_2013_2 = LicitationProcess.make(:processo_licitatorio_canetas)
    licitation_2013_2.save!
    expect(licitation_2013_2.process).to eq 2
  end
end
