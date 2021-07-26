require "spec_helper"

describe PurchaseSolicitation do
  describe '#without_has_price_collection' do
    let(:price_collection) { PriceCollection.make!(:coleta_de_precos) }
    let(:purchase_solicitation_one) { PurchaseSolicitation.make!(:reparo, price_collections: [price_collection]) }
    let(:purchase_solicitation_two) { PurchaseSolicitation.make!(:reparo_liberado) }

    it 'return all purchase_solicitations without price_collections' do
      BudgetStructure.stub(:find)
      expect(PurchaseSolicitation.without_price_collection).to eq [purchase_solicitation_two]
    end
  end

  describe '#without_licitation_process' do
    let(:licitation_process) { LicitationProcess.make!(:pregao_presencial) }
    let(:purchase_solicitation_one) { PurchaseSolicitation.make!(:reparo, licitation_processes: [licitation_process]) }
    let(:purchase_solicitation_two) { PurchaseSolicitation.make!(:reparo_liberado) }

    it 'return all purchase_solicitations without licitation_processes' do
      BudgetStructure.stub(:find)
      expect(PurchaseSolicitation.without_purchase_process).to eq [purchase_solicitation_two]
    end
  end
end
