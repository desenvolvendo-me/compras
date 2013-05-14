require 'spec_helper'

describe LicitationProcessClassification do
  let :bidder_inactive do
    Bidder.make!(:licitante, :enabled => false)
  end

  let :bidder_without_status do
    Bidder.make!(:licitante_com_proposta_1, :enabled => nil)
  end

  let :bidder_active do
    Bidder.make!(:licitante_com_proposta_2, :enabled => true)
  end

  let :antivirus do
    PurchaseProcessItem.make!(:item)
  end

  let :arame do
    PurchaseProcessItem.make!(:item_arame)
  end

  let :allocations do
    PurchaseProcessBudgetAllocation.make!(:alocacao_com_2_itens,
      :items => [antivirus, arame])
  end

  let :licitation_process do
    LicitationProcess.make!(:apuracao_por_itens,
                            :bidders => [bidder_active, bidder_inactive, bidder_without_status])
  end

  let :item do
    licitation_process.items.first
  end

  describe '.for_active_bidders' do
    let :classification_active do
      LicitationProcessClassification.create!(
        :bidder => bidder_active)
    end

    let :classification_inactive do
      LicitationProcessClassification.create!(
        :bidder => bidder_inactive)
    end

    let :classification_without_status do
      LicitationProcessClassification.create!(
        :bidder => bidder_without_status)
    end

    it 'should filter only with status and not inactive' do
      expect(described_class.for_active_bidders).to eq [classification_active]
    end
  end

  describe '.for_item' do
    let :classification_active do
      LicitationProcessClassification.create!(
        :bidder => bidder_active, :classifiable => antivirus)
    end

    let :classification_inactive do
      LicitationProcessClassification.create!(
        :bidder => bidder_inactive, :classifiable => antivirus)
    end

    let :classification_without_status do
      LicitationProcessClassification.create!(:bidder => bidder_without_status,
                                              :classifiable => arame)
    end

    it 'should returns only classifications for the specific item' do
      expect(described_class.for_item(antivirus.id)).to include(classification_active, classification_inactive)
    end

    it 'should not returns classifications for another items' do
      expect(described_class.for_item(antivirus.id)).to_not include(classification_without_status)
    end
  end
end
