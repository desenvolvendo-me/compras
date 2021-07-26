require 'report_helper'
require 'app/reports/minute_purchase_process_report'

describe MinutePurchaseProcessReport do
  let :minute_purchase_process_searcher_repository do
    double(:minute_purchase_process_searcher_repository)
  end

  let(:licitation_process) { double('LicitationProcess', id: 1, creditors: [creditor_one, creditor_two],
    items: [item_one, item_two]) }
  let(:licitation_commission) { double('LicitationCommission', id: 1) }
  let(:judgment_commission_advice) { double('JudgmentCommissionAdvice', id: 1,
    licitation_commission: licitation_commission) }
  let(:individual_one) { double 'Person', id:1, name: "Rodrigo" }
  let(:individual_two) { double 'Person', id:2, name: "Jose" }
  let(:individual_three) { double 'Person', id:3, name: "Mateus" }
  let(:member_one) { double 'LicitationCommissionMember', id:1, individual_id: 1 }
  let(:member_two) { double 'LicitationCommissionMember', id:2, individual_id: 2 }
  let(:member_three) { double 'LicitationCommissionMember', id:3, individual_id: 3 }
  let(:bidder_one) { double('Bidder', id: 1, enabled: true) }
  let(:bidder_two) { double('Bidder', id: 2, enabled: false) }
  let(:bidders) { double('Bidder') }
  let(:item_one) { double('PurchaseProcessItem', id: 1) }
  let(:item_two) { double('PurchaseProcessItem', id: 2) }
  let(:creditor_one) { double('Creditor', id: 1, representatives: [individual_one, individual_two]) }
  let(:creditor_two) { double('Creditor', id: 2, representatives: [individual_two, individual_three]) }
  let(:proposal) { double('PurchaseProcessCreditorProposal', id: 1,
    unit_price: 100.00, creditor: creditor_one, licitation_process: licitation_process, ranking: 2) }
  let(:proposal_two) { double('PurchaseProcessCreditorProposal', id: 2,
    unit_price: 90.00, creditor: creditor_two, licitation_process: licitation_process, ranking: 1) }
  let(:proposals) { double('PurchaseProcessCreditorProposal') }
  let(:ratifications_item) { double('LicitationProcessRatificationItem', id: 1, ratificated: true) }
  let(:ratifications_items) { double('LicitationProcessRatificationItem') }
  let(:ratifications) { double('LicitationProcessRatification', id: 1, licitation_process_ratification_items: [ratifications_item]) }

  subject do
    described_class.new minute_purchase_process_searcher_repository, licitation_process_id: licitation_process.id
  end

  it 'queries the repository' do
    minute_purchase_process_searcher_repository.should_receive(:search).
                                                with(licitation_process: 1).
                                                and_return [licitation_process]

    subject.records
  end

  describe '#licitation_process' do
    it "return licitation_process" do
      minute_purchase_process_searcher_repository.should_receive(:search).
                                                  at_least(1).times.
                                                  with(licitation_process: 1).
                                                  and_return [licitation_process]

      expect(subject.licitation_process).to eq licitation_process
    end
  end

  context "should return all methods" do
    before do
      minute_purchase_process_searcher_repository.should_receive(:search).
                                                  at_least(2).times.
                                                  with(licitation_process: 1).
                                                  and_return [licitation_process]

      subject.licitation_process
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

    it 'return bidders_enabled' do
      licitation_process.stub(:bidders).and_return bidders
      bidders.should_receive(:where).and_return [bidder_one]

      expect(subject.bidders_enabled).to eq [bidder_one]
    end

    describe '#president' do
      it 'return nil if licitation_commission is nil' do
        licitation_process.stub(:judgment_commission_advice).and_return judgment_commission_advice
        judgment_commission_advice.stub(:licitation_commission).and_return nil

        expect(subject.president).to eq nil
      end

      it 'return to_s and upcase if licitation_commission is not nil' do
        licitation_process.stub(:judgment_commission_advice).and_return judgment_commission_advice
        judgment_commission_advice.stub(:licitation_commission).and_return licitation_commission
        licitation_commission.stub(:president).and_return 'Rodrigo'

        expect(subject.president).to eq "RODRIGO"
      end
    end

    context "when licitation_process is direct_purchase" do
      describe '#proposals' do
        it 'return item' do
          licitation_process.stub(:direct_purchase?).and_return true

          expect(subject.proposals).to eq [item_one, item_two]
        end
      end

      describe '#creditor_winner' do
        it 'return items' do
          licitation_process.stub(:direct_purchase?).and_return true

          expect(subject.proposals).to eq [item_one, item_two]
        end
      end
    end

    context "when licitation_process is not direct_purchase" do
      describe '#proposals' do
        it 'return proposals' do
          licitation_process.stub(:direct_purchase?).and_return false
          licitation_process.stub(:creditor_proposals).and_return [proposal, proposal_two]

          expect(subject.proposals).to eq [proposal, proposal_two]
        end
      end

      describe '#creditor_winner' do
        it 'return proposals' do
          licitation_process.stub(:direct_purchase?).and_return false
          licitation_process.stub(:creditor_proposals).and_return proposals
          proposals.stub(:winning_proposals).and_return [proposal_two]

          expect(subject.creditor_winner).to eq [proposal_two]
        end
      end
    end

    it 'return ratifications_items' do
      licitation_process.stub(:ratifications).and_return ratifications
      licitation_process.stub(:ratifications_items).and_return ratifications_items
      ratifications_items.stub(:by_ratificated).and_return [ratifications_item]

      expect(subject.ratifications_items).to eq [ratifications_item]
    end
  end

  describe '#representative' do
    it 'return nil if creditor_winner is empty' do
      subject.stub(:creditor_winner).and_return []

      expect(subject.representative).to eq nil
    end

    it 'return representative if creditor_winner is not empty' do
      subject.stub(:creditor_winner).and_return [proposal_two]

      expect(subject.representative).to eq creditor_two
    end
  end

  describe '#representative_creditor' do
    it 'return representative if creditor is company' do
      creditor_one.stub(:company?).and_return true
      expect(subject.representative_creditor creditor_one).to eq individual_one
    end
  end
end
