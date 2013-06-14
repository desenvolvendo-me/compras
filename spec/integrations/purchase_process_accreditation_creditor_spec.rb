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
    it 'should return the creditors ordered by power of attorney and proposal unit price' do
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
                                                        has_power_of_attorney: true)

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

      expect(described_class.by_lowest_proposal(item.id)).to eq [wenderson, nobe, sobrinho]
    end
  end
end
