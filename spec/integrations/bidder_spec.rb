# encoding: UTF-8
require 'spec_helper'

describe Bidder do
  context 'uniqueness validations' do
    before { LicitationProcess.make!(:processo_licitatorio_computador) }

    it { should validate_uniqueness_of(:creditor_id).scoped_to(:licitation_process_id) }
  end

  describe '.benefited' do
    it 'should return only bidders benefited' do
      licitante = Bidder.make!(:licitante)
      licitante_sobrinho = Bidder.make!(:licitante_sobrinho)
      licitante_com_proposta_3 = Bidder.make!(:licitante_com_proposta_3)
      me_pregao = Bidder.make(:me_pregao)

      expect(Bidder.benefited).to eq [licitante_com_proposta_3]
    end
  end
end
