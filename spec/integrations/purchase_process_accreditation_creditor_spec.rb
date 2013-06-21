require 'spec_helper'

describe PurchaseProcessAccreditationCreditor do
  describe '.selected_creditors' do
    it 'should return only how has power of attorney' do
      purchase_process = LicitationProcess.make!(:pregao_presencial)
      accreditation = PurchaseProcessAccreditation.make!(:general_accreditation,
                                                         purchase_process_accreditation_creditors: [],
                                                         licitation_process: purchase_process)

      sobrinho = PurchaseProcessAccreditationCreditor.make!(:sobrinho_creditor,
                                                            purchase_process_accreditation: accreditation,
                                                            creditor: Creditor.make!(:sobrinho),
                                                            has_power_of_attorney: false)
      wenderson = PurchaseProcessAccreditationCreditor.make!(:wenderson_creditor,
                                                             purchase_process_accreditation: accreditation,
                                                             has_power_of_attorney: true)
      nohup = PurchaseProcessAccreditationCreditor.make!(:sobrinho_creditor,
                                                         purchase_process_accreditation: accreditation,
                                                         creditor: Creditor.make!(:nohup),
                                                         has_power_of_attorney: false)

      expect(described_class.selected_creditors).to include(wenderson, sobrinho)
      expect(described_class.selected_creditors).to_not include(nohup)
    end
  end

  describe '.by_lowest_proposal' do
    it 'should return the creditors by item ordered proposal ranking' do
      item = PurchaseProcessItem.make(:item_arame_farpado)

      purchase_process = LicitationProcess.make!(:pregao_presencial, items: [item])

      accreditation = PurchaseProcessAccreditation.make!(:general_accreditation,
                                                         purchase_process_accreditation_creditors: [],
                                                         licitation_process: purchase_process)

      sobrinho = PurchaseProcessAccreditationCreditor.make!(:sobrinho_creditor,
                                                            purchase_process_accreditation: accreditation,
                                                            has_power_of_attorney: false)

      wenderson = PurchaseProcessAccreditationCreditor.make!(:wenderson_creditor,
                                                             purchase_process_accreditation: accreditation,
                                                             has_power_of_attorney: true)

      nobe = PurchaseProcessAccreditationCreditor.make!(:wenderson_creditor,
                                                        purchase_process_accreditation: accreditation,
                                                        creditor: Creditor.make!(:nobe),
                                                        has_power_of_attorney: false)

      sobrinho_proposal = PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
                                                                licitation_process: purchase_process,
                                                                item: item,
                                                                creditor: sobrinho.creditor,
                                                                unit_price: 10.50)

      wenderson_proposal = PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
                                                                 licitation_process: purchase_process,
                                                                 item: item,
                                                                 creditor: wenderson.creditor,
                                                                 unit_price: 10.0)

      nobe_proposal = PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
                                                            licitation_process: purchase_process,
                                                            item: item,
                                                            creditor: nobe.creditor,
                                                            unit_price: 5.0)

      expect(described_class.by_lowest_proposal(item.id)).to eq [sobrinho, wenderson, nobe]
    end
  end

  describe '.by_lowest_proposal_outer' do
    it 'should return the creditors by item with and without proposal ordered by ranking' do
      item = PurchaseProcessItem.make(:item_arame_farpado)

      purchase_process = LicitationProcess.make!(:pregao_presencial, items: [item])

      accreditation = PurchaseProcessAccreditation.make!(:general_accreditation,
                                                         purchase_process_accreditation_creditors: [],
                                                         licitation_process: purchase_process)

      sobrinho = PurchaseProcessAccreditationCreditor.make!(:sobrinho_creditor,
                                                            purchase_process_accreditation: accreditation,
                                                            has_power_of_attorney: false)

      wenderson = PurchaseProcessAccreditationCreditor.make!(:wenderson_creditor,
                                                             purchase_process_accreditation: accreditation,
                                                             has_power_of_attorney: true)

      nobe = PurchaseProcessAccreditationCreditor.make!(:wenderson_creditor,
                                                        purchase_process_accreditation: accreditation,
                                                        creditor: Creditor.make!(:nobe),
                                                        has_power_of_attorney: false)

      wenderson_proposal = PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
                                                                 licitation_process: purchase_process,
                                                                 item: item,
                                                                 creditor: wenderson.creditor,
                                                                 unit_price: 10.0)

      nobe_proposal = PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
                                                            licitation_process: purchase_process,
                                                            item: item,
                                                            creditor: nobe.creditor,
                                                            unit_price: 5.0)

      expect(described_class.by_lowest_proposal_outer(item.id)).to eq [sobrinho, wenderson, nobe]
    end
  end

  describe '.by_lowest_proposal_on_lot' do
    it 'should return the creditors by licitation_process and lot ordered by ranking' do
      item = PurchaseProcessItem.make(:item_arame_farpado, lot: 50)
      item2 = PurchaseProcessItem.make(:item_arame, lot: 50)

      purchase_process = LicitationProcess.make!(:pregao_presencial,
        items: [item, item2],
        judgment_form: JudgmentForm.make!(:por_lote_com_menor_preco))

      accreditation = PurchaseProcessAccreditation.make!(:general_accreditation,
                                                         purchase_process_accreditation_creditors: [],
                                                         licitation_process: purchase_process)

      sobrinho = PurchaseProcessAccreditationCreditor.make!(:sobrinho_creditor,
                                                            purchase_process_accreditation: accreditation,
                                                            has_power_of_attorney: false)

      wenderson = PurchaseProcessAccreditationCreditor.make!(:wenderson_creditor,
                                                             purchase_process_accreditation: accreditation,
                                                             has_power_of_attorney: true)

      nobe = PurchaseProcessAccreditationCreditor.make!(:wenderson_creditor,
                                                        purchase_process_accreditation: accreditation,
                                                        creditor: Creditor.make!(:nobe),
                                                        has_power_of_attorney: false)

      sobrinho_proposal = PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
                                                                licitation_process: purchase_process,
                                                                item: nil,
                                                                lot: 50,
                                                                creditor: sobrinho.creditor,
                                                                unit_price: 10.50)

      wenderson_proposal = PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
                                                                 licitation_process: purchase_process,
                                                                 item: nil,
                                                                 lot: 50,
                                                                 creditor: wenderson.creditor,
                                                                 unit_price: 10.0)

      nobe_proposal = PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
                                                            licitation_process: purchase_process,
                                                            item: nil,
                                                            lot: 50,
                                                            creditor: nobe.creditor,
                                                            unit_price: 5.0)

      expect(described_class.by_lowest_proposal_on_lot(purchase_process.id, 50)).to eq [sobrinho, wenderson, nobe]
    end
  end

  describe '.by_lowest_proposal_outer_on_lot' do
    it 'should return the creditors by licitation_process and lot with and without proposal ordered by ranking' do
      item = PurchaseProcessItem.make(:item_arame_farpado, lot: 55)
      item2 = PurchaseProcessItem.make(:item_arame, lot: 55)

      purchase_process = LicitationProcess.make!(:pregao_presencial,
        items: [item, item2],
        judgment_form: JudgmentForm.make!(:por_lote_com_menor_preco))

      accreditation = PurchaseProcessAccreditation.make!(:general_accreditation,
                                                         purchase_process_accreditation_creditors: [],
                                                         licitation_process: purchase_process)

      sobrinho = PurchaseProcessAccreditationCreditor.make!(:sobrinho_creditor,
                                                            purchase_process_accreditation: accreditation,
                                                            has_power_of_attorney: false)

      wenderson = PurchaseProcessAccreditationCreditor.make!(:wenderson_creditor,
                                                             purchase_process_accreditation: accreditation,
                                                             has_power_of_attorney: true)

      nobe = PurchaseProcessAccreditationCreditor.make!(:wenderson_creditor,
                                                        purchase_process_accreditation: accreditation,
                                                        creditor: Creditor.make!(:nobe),
                                                        has_power_of_attorney: false)

      wenderson_proposal = PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
                                                                 licitation_process: purchase_process,
                                                                 item: nil,
                                                                 lot: 55,
                                                                 creditor: wenderson.creditor,
                                                                 unit_price: 20.0)

      nobe_proposal = PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
                                                            licitation_process: purchase_process,
                                                            item: nil,
                                                            lot: 55,
                                                            creditor: nobe.creditor,
                                                            unit_price: 5.0)

      expect(described_class.by_lowest_proposal_outer_on_lot(purchase_process.id, 55)).to eq [sobrinho, wenderson, nobe]
    end
  end
end
