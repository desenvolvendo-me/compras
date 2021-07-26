require 'unit_helper'
require 'app/business/judgment_form_filter'

describe JudgmentFormFilter do
  describe '#by_modality' do
    subject do
      described_class.new(judgment_form_repository)
    end

    let(:judgment_form_repository) { double(:judgment_form_repository) }

    let(:lowest_price) do
      double(:lowest_price,
             :lowest_price? => true,
             :best_technique? => false,
             :technical_and_price? => false,
             :higher_discount_on_item? => false,
             :higher_discount_on_lot? => false,
             :higher_discount_on_table? => false,
             :best_auction_or_offer? => false,
             :global? => false)
    end

    let(:best_technique) do
      double(:best_technique,
             :lowest_price? => false,
             :best_technique? => true,
             :technical_and_price? => false,
             :higher_discount_on_item? => false,
             :higher_discount_on_lot? => false,
             :higher_discount_on_table? => false,
             :best_auction_or_offer? => false,
             :global? => true)
    end

    let(:technical_and_price) do
      double(:technical_and_price,
             :lowest_price? => false,
             :best_technique? => false,
             :technical_and_price? => true,
             :higher_discount_on_item? => false,
             :higher_discount_on_lot? => false,
             :higher_discount_on_table? => false,
             :best_auction_or_offer? => false,
             :global? => true)
    end

    let(:higher_discount_on_item) do
      double(:higher_discount_on_item,
             :lowest_price? => false,
             :best_technique? => false,
             :technical_and_price? => false,
             :higher_discount_on_item? => true,
             :higher_discount_on_lot? => false,
             :higher_discount_on_table? => false,
             :best_auction_or_offer? => false,
             :global? => true)
    end

    let(:higher_discount_on_lot) do
      double(:higher_discount_on_lot,
             :lowest_price? => false,
             :best_technique? => false,
             :technical_and_price? => false,
             :higher_discount_on_item? => false,
             :higher_discount_on_lot? => true,
             :higher_discount_on_table? => false,
             :best_auction_or_offer? => false,
             :global? => true)
    end

    let(:higher_discount_on_table) do
      double(:higher_discount_on_table,
             :lowest_price? => false,
             :best_technique? => false,
             :technical_and_price? => false,
             :higher_discount_on_item? => false,
             :higher_discount_on_lot? => false,
             :higher_discount_on_table? => true,
             :best_auction_or_offer? => false,
             :global? => true)
    end

    let(:best_auction_or_offer) do
      double(:best_auction_or_offer,
             :lowest_price? => false,
             :best_technique? => false,
             :technical_and_price? => false,
             :higher_discount_on_item? => false,
             :higher_discount_on_lot? => false,
             :higher_discount_on_table? => false,
             :best_auction_or_offer? => true,
             :global? => true)
    end

    let(:judgment_form_repository_enabled) { double(:judgment_form_repository_enabled) }

    it 'should return the hash with all judgment forms grouped by modality' do
      judgment_form_repository.should_receive(:enabled).any_number_of_times.and_return(judgment_form_repository_enabled)
      judgment_form_repository_enabled.should_receive(:order).any_number_of_times.and_return([
        lowest_price, best_technique, technical_and_price,higher_discount_on_item,
        higher_discount_on_lot, higher_discount_on_table, best_auction_or_offer])

      expect(subject.by_modality).to eq({
        :with_price_registration => {
          :concurrence => [lowest_price, higher_discount_on_table],
          :taken_price => [lowest_price, best_technique, technical_and_price, best_auction_or_offer],
          :invitation => [lowest_price],
          :trading => [lowest_price, higher_discount_on_table],
          :auction => [best_auction_or_offer],
          :competition => [best_technique]
        },

        :without_price_registration => {
          :concurrence => [lowest_price, best_technique, technical_and_price, best_auction_or_offer],
          :taken_price => [lowest_price, best_technique, technical_and_price, best_auction_or_offer],
          :invitation => [lowest_price],
          :trading => [lowest_price],
          :auction => [best_auction_or_offer],
          :competition => [best_technique]
        }
      })
    end
  end
end
