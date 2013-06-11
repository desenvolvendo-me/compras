require 'report_helper'
require 'enumerate_it'
require 'app/business/trading_item_winner'
require 'app/reports/minute_purchase_process_trading_report'

describe MinutePurchaseProcessTradingReport do
  let :minute_purchase_process_trading_searcher_repository do
    double(:minute_purchase_process_trading_searcher_repository)
  end

  let(:licitation_process) { double('LicitationProcess', id: 1) }
  let(:licitation_commission) { double('LicitationCommission', id: 1) }
  let(:judgment_commission_advice) { double('JudgmentCommissionAdvice', id: 1, licitation_commission: licitation_commission) }
  let(:individual_one) { double 'Person', id:1, name: "Rodrigo" }
  let(:individual_two) { double 'Person', id:2, name: "Jose" }
  let(:individual_three) { double 'Person', id:3, name: "Mateus" }
  let(:member_one) { double 'LicitationCommissionMember', id:1, individual_id: 1, role: 'auctioneer' }
  let(:member_two) { double 'LicitationCommissionMember', id:2, individual_id: 2 }
  let(:member_three) { double 'LicitationCommissionMember', id:3, individual_id: 3 }
  let(:licitation_commission_members) { [member_one, member_two, member_three] }
  let(:auctioneers) { [member_one] }
  let(:creditor_one) { double('Creditor', id: 1, representatives: [individual_one, individual_two]) }
  let(:creditor_two) { double('Creditor', id: 2, representatives: [individual_two, individual_three]) }
  let(:creditors) { [creditor_one, creditor_two] }
  let(:proposal) { double('PurchaseProcessCreditorProposal', id: 1,
    unit_price: 100.00, creditor: creditor_one, licitation_process: licitation_process, ranking: 2) }
  let(:proposal_two) { double('PurchaseProcessCreditorProposal', id: 2,
    unit_price: 90.00, creditor: creditor_two, licitation_process: licitation_process, ranking: 1) }
  let(:proposals) { [proposal, proposal_two] }
  let(:trading_item_one) { double('PurchaseProcessTradingItem', id: 1) }
  let(:trading_item_two) { double('PurchaseProcessTradingItem', id: 2) }
  let(:trading) { double('PurchaseProcessTrading', id: 1, items: [trading_item_one, trading_item_two]) }
  let(:trading_item_bid) { double('PurchaseProcessTradingItemBid', id:1, item: trading_item_one) }
  let(:trading_item_bid_two) { double('PurchaseProcessTradingItemBid', id:2, item: trading_item_two) }
  let(:trading_item_winner) { double('TradingItemWinner') }

  subject do
    described_class.new minute_purchase_process_trading_searcher_repository, licitation_process_id: licitation_process.id
  end

  it 'queries the repository' do
    minute_purchase_process_trading_searcher_repository.should_receive(:search).
                                                        with(licitation_process: 1).
                                                        and_return minute_purchase_process_trading_searcher_repository

    subject.records
  end

  describe '#licitation_process' do
    it "return licitation_process" do
      minute_purchase_process_trading_searcher_repository.should_receive(:search).
                                                          at_least(2).times.
                                                          with(licitation_process: 1).
                                                          and_return minute_purchase_process_trading_searcher_repository

      subject.records.should_receive(:first).and_return licitation_process
      expect(subject.licitation_process).to eq licitation_process
    end
  end

  context "should return all methods" do
    before do
      minute_purchase_process_trading_searcher_repository.should_receive(:search).
                                                          at_least(2).times.
                                                          with(licitation_process: 1).
                                                          and_return minute_purchase_process_trading_searcher_repository

      subject.records.should_receive(:first).at_least(1).times.and_return licitation_process
    end


    describe '#issuance_date' do
      it 'return nil if judgment_commission_advice_issuance_date is nil' do
        licitation_process.stub(:judgment_commission_advice_issuance_date).and_return nil

        expect(subject.issuance_date).to eq nil
      end

      it 'return issuance_date if judgment_commission_advice_issuance_date is not nil ' do
        licitation_process.stub(:judgment_commission_advice_issuance_date).and_return Date.today

        expect(subject.issuance_date).to eq I18n.l Date.today
      end
    end

    describe '#proposal_envelope_opening_date' do
      it 'return nil if proposal_envelope_opening_date is nil' do
        licitation_process.stub(:proposal_envelope_opening_date).and_return nil

        expect(subject.proposal_envelope_opening_date).to eq nil
      end

      it 'return I18n to proposal_envelope_opening_date if proposal_envelope_opening_date is not nil' do
        licitation_process.stub(:proposal_envelope_opening_date).and_return Date.today

        expect(subject.proposal_envelope_opening_date).to eq I18n.l Date.today
      end
    end

    describe '#proposal_envelope_opening_time' do

      it 'return nil if proposal_envelope_opening_time is nil' do
        licitation_process.stub(:proposal_envelope_opening_time).and_return nil

        expect(subject.proposal_envelope_opening_time).to eq nil
      end

      it 'return 11:00 if proposal_envelope_opening_time is not nil' do
        licitation_process.stub(:proposal_envelope_opening_time).and_return Time.now

        expect(subject.proposal_envelope_opening_time).to eq I18n.l Time.now, format: :hour
      end
    end

    describe '#licitation_commission' do
      it 'return nil if judgment_commission_advice is nil' do
        licitation_process.stub(:judgment_commission_advice).and_return nil

        expect(subject.licitation_commission).to eq nil
      end

      it 'return licitation_commission if judgment_commission_advice is not nil' do
        licitation_process.stub(:judgment_commission_advice).and_return judgment_commission_advice

        expect(subject.licitation_commission).to eq licitation_commission
      end
    end

    describe '#judgment_commission_advice' do
      it 'return judgment_commission_advice' do
        licitation_process.stub(:judgment_commission_advice).and_return judgment_commission_advice

        expect(subject.judgment_commission_advice).to eq judgment_commission_advice
      end
    end

    context 'when licitation_commission_members is empty' do
      describe '#member' do
        it 'return nil' do
          licitation_process.stub(:judgment_commission_advice).and_return judgment_commission_advice
          judgment_commission_advice.stub(:licitation_commission).and_return licitation_commission
          licitation_commission.stub(:licitation_commission_members).and_return []

          expect(subject.member).to eq nil
        end
      end
    end

    it 'return creditors' do
      licitation_process.stub(:creditors).and_return creditors

      expect(subject.creditor_accreditations).to eq creditors
    end

    it 'return proposals' do
      licitation_process.stub(:creditor_proposals).and_return proposals

      expect(subject.proposals).to eq proposals
    end

    it 'return trading_items' do
      licitation_process.stub(:trading_items).and_return [trading_item_one, trading_item_two]

      expect(subject.trading_items).to eq [trading_item_one, trading_item_two]
    end

    describe '#bids' do
      it 'return array empty if trading_item_bids is nil' do
        licitation_process.stub(:trading_item_bids).and_return nil

        expect(subject.bids).to eq []
      end

      it 'return trading_item_bids if trading_item_bids is not nil' do
        licitation_process.stub(:trading_item_bids).and_return [trading_item_bid, trading_item_bid_two]

        expect(subject.bids).to eq [trading_item_bid, trading_item_bid_two]
      end
    end

    describe '#auctioneer' do
      it 'return nil if auctioneer is empty' do
        licitation_process.stub(:judgment_commission_advice).and_return judgment_commission_advice
        judgment_commission_advice.stub(:licitation_commission).and_return licitation_commission
        licitation_commission.stub(:auctioneer).and_return []

        expect(subject.auctioneer).to eq nil
      end

      it 'return auctioneer if auctioneer is not empty' do
        licitation_process.stub(:judgment_commission_advice).and_return judgment_commission_advice
        judgment_commission_advice.stub(:licitation_commission).and_return licitation_commission
        licitation_commission.should_receive(:auctioneer).at_least(2).times.and_return auctioneers
        member_one.should_receive(:individual).and_return individual_one
        individual_one.stub(:to_s).and_return 'Rodrigo'

        expect(subject.auctioneer).to eq "RODRIGO"
      end
    end
  end

  it 'return creditor_winner' do
    TradingItemWinner.should_receive(:new).with(trading_item_bid).and_return trading_item_winner
    trading_item_winner.stub(:creditor).and_return creditor_one

    expect(subject.creditor_winner(trading_item_bid)).to eq creditor_one
  end

  it 'return amount_winner' do
    TradingItemWinner.should_receive(:new).with(trading_item_bid).and_return trading_item_winner
    trading_item_winner.stub(:amount).and_return "100.00"

    expect(subject.amount_winner(trading_item_bid)).to eq "100.00"
  end
end
