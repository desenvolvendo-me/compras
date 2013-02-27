#encoding: utf-8
require 'model_helper'
require 'app/models/trading_item'
require 'app/models/trading'
require 'app/models/trading_configuration'
require 'app/models/trading_closing'

describe Trading do

  subject do
    Trading.new(:code => 1, :year => 2012)
  end

  it { should belong_to :entity }
  it { should belong_to :licitation_commission }
  it { should belong_to :licitation_process }
  it { should belong_to :licitating_unit }

  it { should have_many(:items).dependent(:destroy) }
  it { should have_many(:closings).dependent(:destroy) }
  it { should have_many(:bidders).through(:licitation_process) }

  it { should validate_presence_of :licitation_process }
  it { should validate_presence_of :year }

  describe 'delegates' do
    it { should delegate(:auctioneer).to(:licitation_commission).allowing_nil(true) }
    it { should delegate(:support_team).to(:licitation_commission).allowing_nil(true) }
    it { should delegate(:licitation_commission_members).to(:licitation_commission).allowing_nil(true) }
    it { should delegate(:summarized_object).to(:licitation_process).allowing_nil(true) }
    it { should delegate(:items).to(:licitation_process).allowing_nil(true).prefix(true) }
  end

  describe "#to_s" do
    it "returns the code and year of the trading formatted as 1/2012" do
      expect(subject.to_s).to eq "1/2012"
    end
  end

  describe "#code_and_year" do
    it "returns the code and year of the trading formatted as 1/2012" do
      expect(subject.code_and_year).to eq "1/2012"
    end
  end

  describe "default values" do
    it "should percentage_limit_to_participate_in_bids be 0" do
      expect(subject.percentage_limit_to_participate_in_bids).to eq 0
    end
  end

  describe "validations" do
    it "validates if the licitation modality is of 'trading' type" do
      licitation_process = double(:trading? => false,
                                  :edital_published? => true)
      subject.stub(:licitation_process => licitation_process)

      subject.valid?

      expect(subject.errors[:licitation_process]).to include "deve ser do tipo Pregão presencial"
    end

    context "licitation commission validations" do
      let(:licitation_commission) do
        double(:expired? => false,
               :trading? => true,
               :exonerated? => false,
               :present? => true)
      end

      before do
        subject.stub(:licitation_commission => licitation_commission)
      end

      it "validates if the licitation commission is of 'trading' type" do
        licitation_commission.stub(:trading? => false)
        subject.valid?

        expect(subject.errors[:licitation_commission]).to include "deve ser do tipo Pregão presencial"
      end

      it "validates if the licitation commission is not expired" do
        licitation_commission.stub(:expired? => true)
        subject.valid?

        expect(subject.errors[:licitation_commission]).to include "não pode estar expirada"
      end

      it "validates if the licitation commission is not exonerated" do
        licitation_commission.stub(:exonerated? => true)
        subject.valid?

        expect(subject.errors[:licitation_commission]).to include "não pode estar exonerada"
      end
    end

    it "validates if associated licitation process has a published edital" do
      licitation_process = double(:edital_published? => false,
                                  :trading? => true)
      subject.stub(:licitation_process => licitation_process)

      subject.valid?

      expect(subject.errors[:licitation_process]).to include "deve ter edital publicado"
    end
  end

  describe 'before_save' do
    it 'should clear dates, protocol when is not invited' do
      subject.run_callbacks(:create)

      expect(subject.percentage_limit_to_participate_in_bids).to eq TradingConfiguration.percentage_limit_to_participate_in_bids
    end

    it 'should clear dates, protocol when is not invited' do
      last_trading_configuration_instance = TradingConfiguration.new
      last_trading_configuration_instance.stub(:percentage_limit_to_participate_in_bids).and_return(8.8)

      TradingConfiguration.stub(:last).and_return(last_trading_configuration_instance)
      subject.run_callbacks(:create)

      expect(subject.percentage_limit_to_participate_in_bids).to eq 8.8
    end
  end

  describe '#current_closing' do
    let(:first_closing) { double(:first_closing) }
    let(:last_closing) { double(:last_closing) }

    it 'should return the last closing ordering desc' do
      subject.stub(:closings => [last_closing, first_closing])
      expect(subject.current_closing).to eq last_closing
    end

    it 'should return nil when there is no closing' do
      subject.stub(:closings => [])
      expect(subject.current_closing).to eq nil
    end
  end

  describe '#allowing_closing?' do
    let(:items) { double(:items) }

    before do
      subject.stub(:items => items)
    end

    context 'when all items are closed' do
      before do
        items.stub(:not_closed => [])
      end

      it { expect(subject).to be_allow_closing }
    end

    context 'when not all items are closed' do
      before do
        items.stub(:not_closed => ['not_closed'])
      end

      it { expect(subject).to_not be_allow_closing }
    end
  end
end
