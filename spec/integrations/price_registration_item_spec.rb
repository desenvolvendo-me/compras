# encoding: utf-8
require 'spec_helper'

describe PriceRegistrationItem do
  context '#winning_bid' do

    def classify_process(licitation_process)
      LicitationProcessClassificationGenerator.new(licitation_process).generate!

      LicitationProcessClassificationBiddersVerifier.new(licitation_process).verify!

      LicitationProcessClassificationSituationGenerator.new(licitation_process).generate!
    end

    it 'returns the winning bid of the licitation process if type of calculation is "lowest_global_price' do
      licitation_process = LicitationProcess.make!(:apuracao_global)
      price_registration = PriceRegistration.make!(:registro_de_precos,
                                                   :licitation_process => licitation_process)
      classify_process(licitation_process)

      expect(price_registration.items.first.winning_bid).to eq licitation_process.winning_bid
    end
    
    it 'returns the winning_bid of the administrative process item if calculation is "lowest_item_by_price"' do
      licitation_process = LicitationProcess.make!(:apuracao_por_itens)
      item = PriceRegistrationItem.make(:antivirus,
                                        :administrative_process_budget_allocation_item => licitation_process.items.first)
      price_registration = PriceRegistration.make!(:registro_de_precos,
                                                   :licitation_process => licitation_process,
                                                   :items => [item])

      classify_process(licitation_process)

      expect(price_registration.items.first.winning_bid).to eq licitation_process.items.first.winning_bid
    end

    it 'returns the winning bid of the item lot if calculation is "lowest_price_by_lot"' do
      licitation_process = LicitationProcess.make!(:apuracao_por_lote)
      lote = LicitationProcessLot.make!(:lote,
                                        :licitation_process => licitation_process,
                                        :administrative_process_budget_allocation_items => [licitation_process.items.first])

      item = PriceRegistrationItem.make(:antivirus,
                                        :administrative_process_budget_allocation_item => licitation_process.items.first)
      price_registration = PriceRegistration.make!(:registro_de_precos,
                                                   :licitation_process  => licitation_process,
                                                   :items => [item])

      classify_process(licitation_process)

      expect(price_registration.items.first.winning_bid).to eq lote.winning_bid
    end
  end
end
