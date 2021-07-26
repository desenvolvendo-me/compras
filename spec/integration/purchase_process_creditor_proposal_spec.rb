require 'spec_helper'

describe PurchaseProcessCreditorProposal do
  let(:bidder_nohup) do
    Bidder.make!(:licitante_sobrinho, enabled: true, habilitation_date: Date.current,
      creditor: Creditor.make!(:nohup))
  end

  let(:bidder_ibm) do
    Bidder.make!(:licitante, enabled: true, habilitation_date: Date.current,
      creditor: Creditor.make!(:ibm))
  end

  let(:licitation_process) do
    LicitationProcess.make!(:pregao_presencial,
      purchase_process_accreditation: PurchaseProcessAccreditation.make(:general_accreditation),
      judgment_form: JudgmentForm.make!(:por_item_com_melhor_tecnica),
      bidders: [bidder_nohup, bidder_ibm])
  end

  let :direct_purchase do
    LicitationProcess.make!(:compra_direta, bidders: [bidder_nohup, bidder_ibm])
  end

  let(:proposta_arame_ibm) do
    PurchaseProcessCreditorProposal.make!(:proposta_arame,
      licitation_process: licitation_process, creditor: bidder_ibm.creditor,
      unit_price: 100.00)
  end

  let(:proposta_arame_nohup) do
    PurchaseProcessCreditorProposal.make!(:proposta_arame,
      licitation_process: licitation_process, creditor: bidder_nohup.creditor,
      unit_price: 105.00)
  end

  let(:proposta_arame_nohup_direct_purchase) do
    PurchaseProcessCreditorProposal.make!(:proposta_arame,
      licitation_process: direct_purchase, creditor: bidder_nohup.creditor,
      unit_price: 105.00)
  end

  describe '.best_proposal_for' do
    let(:bidder_sobrinho) do
      Bidder.make!(:licitante_sobrinho, enabled: true, habilitation_date: Date.current)
    end

    let(:bidder_wenderson) do
      Bidder.make!(:licitante, enabled: true, habilitation_date: Date.current)
    end

    let(:licitation_process) do
      LicitationProcess.make!(:pregao_presencial,
        purchase_process_accreditation: PurchaseProcessAccreditation.make(:general_accreditation),
        judgment_form: JudgmentForm.make!(:por_item_com_melhor_tecnica),
        bidders: [bidder_sobrinho, bidder_wenderson])
    end

    let(:proposta_arame_wenderson) do
      PurchaseProcessCreditorProposal.make!(:proposta_arame,
        licitation_process: licitation_process, creditor: bidder_wenderson.creditor)
    end

    let(:proposta_arame_sobrinho) do
      PurchaseProcessCreditorProposal.make!(:proposta_arame,
        licitation_process: licitation_process, creditor: bidder_sobrinho.creditor,
        unit_price: 3.99)
    end

    before do
      proposta_arame_wenderson.reload
      proposta_arame_sobrinho.reload
    end

    it 'returns the best proposal for the passed proposal' do
      best_proposal = PurchaseProcessCreditorProposal.best_proposal_for(proposta_arame_sobrinho)
      expect(best_proposal).to eq proposta_arame_wenderson

      best_proposal = PurchaseProcessCreditorProposal.best_proposal_for(proposta_arame_wenderson)
      expect(best_proposal).to eq proposta_arame_wenderson
    end
  end

  describe '#cheaper_brothers' do
    let(:current_proposal) {
      PurchaseProcessCreditorProposal.make! :proposta_arame_farpado, unit_price: 5.00,
      item: PurchaseProcessItem.make!(:item_arame_farpado)
    }

    let(:cheaper_proposal) {
      PurchaseProcessCreditorProposal.make! :proposta_arame, unit_price: 4.00,
      item: PurchaseProcessItem.make!(:item_arame_farpado)
    }

    it 'returns the cheaper proposals with the same item or lot' do
      expect(current_proposal.cheaper_brothers).to include cheaper_proposal
    end
  end

  describe '#same_price_brothers' do
    let(:current_proposal) {
      PurchaseProcessCreditorProposal.make! :proposta_arame_farpado, unit_price: 5.00,
      item: PurchaseProcessItem.make!(:item_arame_farpado)
    }

    let(:same_price_proposal) {
      PurchaseProcessCreditorProposal.make! :proposta_arame, unit_price: 5.00,
      item: PurchaseProcessItem.make!(:item_arame_farpado)
    }

    it 'returns all the proposals with the same price and item, or lot, of the passed proposal' do
      expect(current_proposal.same_price_brothers).to include(same_price_proposal, current_proposal)
    end
  end

  describe '#unit_price_equal' do
    it 'return proposals with equals unit_price' do
      expect(PurchaseProcessCreditorProposal.unit_price_equal(105.00)).to include(proposta_arame_nohup)
      expect(PurchaseProcessCreditorProposal.unit_price_equal(105.00)).to_not include(proposta_arame_ibm)
    end
  end

  describe '#unit_price_greater_than' do
    it 'return proposals with unit_price greater_than 102.00' do
      expect(PurchaseProcessCreditorProposal.unit_price_greater_than(102.00)).to include(proposta_arame_nohup)
      expect(PurchaseProcessCreditorProposal.unit_price_greater_than(102.00)).to_not include(proposta_arame_ibm)
    end
  end

  describe '#benefited_unit_price' do
    context 'proposal creditor is not benefited' do
      it 'returns the current proposal unit price' do
        expect(bidder_ibm.creditor.benefited).to be_false
        expect(proposta_arame_ibm.benefited_unit_price).to eql 100.00
      end
    end

    context 'proposal creditor is benefited' do
      context 'proposal unit price is, at most, 10% of best proposal price' do
        before do
          proposta_arame_nohup.update_attribute(:unit_price, 105.00)
          proposta_arame_ibm.update_attribute(:unit_price, 100.00)
        end

        it 'returns the best proposal unit price to make a tie' do
          expect(bidder_nohup.creditor.benefited).to be_true
          expect(proposta_arame_nohup.benefited_unit_price).to eql 100.00
        end
      end

      context 'when proposal unit price is higher than 10% of best proposal price' do
        before do
          proposta_arame_nohup.update_attribute(:unit_price, 115.00)
          proposta_arame_ibm.update_attribute(:unit_price, 100.00)
        end

        it 'returns the current proposal unit price' do
          expect(bidder_nohup.creditor.benefited).to be_true
          expect(proposta_arame_nohup.benefited_unit_price).to eql 115.00
        end
      end
    end
  end

  describe '#type_of_purchase_licitation' do
    it 'should return all proposals by licitation' do
      expect(PurchaseProcessCreditorProposal.type_of_purchase_licitation).to include(proposta_arame_nohup, proposta_arame_ibm)
      expect(PurchaseProcessCreditorProposal.type_of_purchase_licitation).to_not include(proposta_arame_nohup_direct_purchase)
    end
  end
end
