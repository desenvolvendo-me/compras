require 'spec_helper'

describe RealignmentPrice do
  describe 'validates uniqueness' do
    before { RealignmentPrice.make!(:realinhamento) }

    it { should validate_uniqueness_of(:purchase_process_id).scoped_to([:creditor_id, :lot]) }
  end

  describe '.purchase_process_id' do
    it 'should filter by purchase_process_id' do
      processo_licitatorio_canetas = LicitationProcess.make!(:processo_licitatorio_canetas)
      apuracao_por_lote = LicitationProcess.make!(:apuracao_por_lote)

      realinhamento1 = RealignmentPrice.make!(:realinhamento,
       purchase_process: apuracao_por_lote)

      realinhamento2 = RealignmentPrice.make!(:realinhamento,
       purchase_process: processo_licitatorio_canetas)

      expect(described_class.purchase_process_id(apuracao_por_lote.id)).to eq [realinhamento1]
    end
  end

  describe '.creditor_id' do
    it 'should filter by creditor_id' do
      processo_licitatorio_canetas = LicitationProcess.make!(:processo_licitatorio_canetas)
      apuracao_por_lote = LicitationProcess.make!(:apuracao_por_lote)
      sobrinho = Creditor.make!(:sobrinho)
      wenderson = Creditor.make!(:wenderson_sa)

      realinhamento1 = RealignmentPrice.make!(:realinhamento,
       purchase_process: apuracao_por_lote,
       creditor: sobrinho)

      realinhamento2 = RealignmentPrice.make!(:realinhamento,
       purchase_process: processo_licitatorio_canetas,
       creditor: wenderson)

      expect(described_class.creditor_id(wenderson.id)).to eq [realinhamento2]
    end
  end

  describe '.lot' do
    it 'should filter by lot' do
      processo_licitatorio_canetas = LicitationProcess.make!(:processo_licitatorio_canetas)
      apuracao_por_lote = LicitationProcess.make!(:apuracao_por_lote)

      realinhamento1 = RealignmentPrice.make!(:realinhamento,
       purchase_process: apuracao_por_lote,
       lot: 10)

      realinhamento2 = RealignmentPrice.make!(:realinhamento,
       purchase_process: processo_licitatorio_canetas,
       lot: 15)

      expect(described_class.lot(10)).to eq [realinhamento1]
    end
  end
end
