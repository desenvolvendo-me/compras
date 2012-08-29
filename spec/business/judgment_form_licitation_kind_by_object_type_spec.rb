require 'unit_helper'
require 'app/business/judgment_form_licitation_kind_by_object_type'

describe JudgmentFormLicitationKindByObjectType do
  subject do
    described_class.new(licitation_kind, object_type)
  end

  let :licitation_kind do
    double(:licitation_kind)
  end

  let :object_type do
    double(:object_type)
  end

  context 'with object_type and licitation_kind' do
    before do
      object_type.should_receive(:value_for).with(:DISPOSALS_OF_ASSETS).
                                             at_least(:once).
                                             and_return(:disposals_of_assets)
      object_type.should_receive(:value_for).with(:CONCESSIONS_AND_PERMITS).
                                             at_least(:once).
                                             and_return(:concessions_and_permits)
      object_type.should_receive(:value_for).with(:CALL_NOTICE).
                                             at_least(:once).
                                             and_return(:call_notice)
      object_type.should_receive(:value_for).
                  with(:CONSTRUCTION_AND_ENGINEERING_SERVICES).
                  at_least(:once).
                  and_return(:construction_and_engineering_services)

      object_type.should_receive(:value_for).with(:PURCHASE_AND_SERVICES).
                                             at_least(:once).
                                             and_return(:purchase_and_services)

      licitation_kind.should_receive(:value_for).with(:BEST_AUCTION_OR_OFFER).
                                                 at_least(:once).
                                                 and_return(:best_auction_or_offer)
      licitation_kind.should_receive(:value_for).with(:BEST_TECHNIQUE).
                                                 at_least(:once).
                                                 and_return(:best_technique)
      licitation_kind.should_receive(:value_for).with(:LOWEST_PRICE).
                                                 at_least(:once).
                                                 and_return(:lowest_price)
    end

    it 'it should group licitation kinds by administrative_process_object_type' do
      expect(subject.licitation_kind_groups).to eq ({
        :disposals_of_assets => [
          :best_auction_or_offer
        ],
        :concessions_and_permits => [
          :best_auction_or_offer
        ],
        :call_notice => [
          :best_technique
        ],
        :construction_and_engineering_services => [
          :lowest_price, :best_technique
        ],
        :purchase_and_services => [
          :lowest_price, :best_technique
        ]
      })
    end

    it 'should verify licitation_kind when object_type is disposals_of_assets' do
      expect(subject.valid_licitation_kind?(:disposals_of_assets, :best_auction_or_offer)).to be_true
      expect(subject.valid_licitation_kind?(:disposals_of_assets, :best_technique)).not_to be_true
      expect(subject.valid_licitation_kind?(:disposals_of_assets, :lowest_price)).not_to be_true
    end

    it 'should verify licitation_kind when object_type is concessions_and_permits' do
      expect(subject.valid_licitation_kind?(:concessions_and_permits, :best_auction_or_offer)).to be_true
      expect(subject.valid_licitation_kind?(:concessions_and_permits, :best_technique)).not_to be_true
      expect(subject.valid_licitation_kind?(:concessions_and_permits, :lowest_price)).not_to be_true
    end

    it 'should verify licitation_kind when object_type is call_notice' do
      expect(subject.valid_licitation_kind?(:call_notice, :best_auction_or_offer)).not_to be_true
      expect(subject.valid_licitation_kind?(:call_notice, :best_technique)).to be_true
      expect(subject.valid_licitation_kind?(:call_notice, :lowest_price)).not_to be_true
    end

    it 'should verify licitation_kind when object_type is construction_and_engineering_services' do
      expect(subject.valid_licitation_kind?(:construction_and_engineering_services, :best_auction_or_offer)).not_to be_true
      expect(subject.valid_licitation_kind?(:construction_and_engineering_services, :best_technique)).to be_true
      expect(subject.valid_licitation_kind?(:construction_and_engineering_services, :lowest_price)).to be_true
    end

    it 'should verify licitation_kind when object_type is purchase_and_services' do
      expect(subject.valid_licitation_kind?(:purchase_and_services, :best_auction_or_offer)).not_to be_true
      expect(subject.valid_licitation_kind?(:purchase_and_services, :best_technique)).to be_true
      expect(subject.valid_licitation_kind?(:purchase_and_services, :lowest_price)).to be_true
    end
  end
end
