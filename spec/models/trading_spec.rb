#encoding: utf-8
require 'model_helper'
require 'app/models/trading_item'
require 'app/models/trading'
require 'app/models/trading_configuration'

describe Trading do

  subject do
    Trading.new(:code => 1, :year => 2012)
  end

  it { should belong_to :entity }
  it { should belong_to :licitation_commission }
  it { should belong_to :licitation_process }
  it { should belong_to :licitating_unit }

  it { should have_many(:trading_items).dependent(:destroy) }
  it { should have_many(:bidders).through(:licitation_process) }

  it { should validate_presence_of :licitation_process }
  it { should validate_presence_of :year }

  describe "#to_s" do
    it "returns the code and year of the trading formatted as 1/2012" do
      expect(subject.to_s).to eq "1/2012"
    end
  end

  describe "default values" do
    it "should percentage_limit_to_participate_in_bids be 0" do
      expect(subject.percentage_limit_to_participate_in_bids).to eq 0
    end
  end

  describe "validations" do
    it "validates if the licitation modality is of 'trading' type" do
      licitation_process = double(:presence_trading? => false,
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
                                  :presence_trading? => true)
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
end
