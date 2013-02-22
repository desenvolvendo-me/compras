require 'unit_helper'
require 'enumerate_it'
require 'active_support/time'
require 'app/enumerations/modality'
require 'app/business/licitation_process_envelope_opening_date'
require 'app/business/days_counter'

describe LicitationProcessEnvelopeOpeningDate do
  let(:licitation_process) do
    double(:licitation_process,
      :envelope_opening_date => Date.today, :last_publication_date => Date.today,
      :administrative_process_modality => :competition, :execution_type => :integral,
      :judgment_form_licitation_kind => :best_technique)
  end

  let(:days_counter) { double :days_counter }
  let(:errors) { double :errors }

  subject do
    described_class.new(licitation_process)
  end

  describe "modality validations" do
    before do
      DaysCounter.stub(:new).and_return days_counter
    end

    describe "competition" do
      before do
        licitation_process.stub(:administrative_process_modality).and_return :competition
      end

      it "is valid when the days difference is greater 45 days" do
        subject.should_receive(:respond_to?).with("competition_validation", true).and_return true
        days_counter.stub(:count).and_return 46
        expect(subject.valid?).to be true
      end

      it "is not valid when the days difference is lesser or equal than 45 days" do
        subject.should_receive(:respond_to?).with("competition_validation", true).and_return true
        days_counter.stub(:count).and_return 45
        licitation_process.stub_chain(:errors, :add)
        expect(subject.valid?).to be false
      end
    end

    describe "concurrence" do
      before do
        licitation_process.stub(:administrative_process_modality).and_return :concurrence
      end

      context "integral execution type" do
        before do
          licitation_process.stub(:execution_type).and_return "integral"
        end

        it "is valid when licitation kind is best technique and days difference is greater than 45 days" do
          licitation_process.stub(:judgment_form_licitation_kind).and_return "best_technique"
          subject.should_receive(:respond_to?).with("concurrence_validation", true).and_return true
          days_counter.stub(:count).and_return 46
          expect(subject.valid?).to be true
        end

        it "is not valid when licitation kind is best technique and days difference is lesser or equal than 45 days" do
          licitation_process.stub(:judgment_form_licitation_kind).and_return "best_technique"
          subject.should_receive(:respond_to?).with("concurrence_validation", true).and_return true
          days_counter.stub(:count).and_return 45
          licitation_process.stub_chain(:errors, :add)
          expect(subject.valid?).to be false
        end
      end

      context "execution type is not integral" do
        before do
          licitation_process.stub(:execution_type).and_return double(:integral, :integral? => false)
        end

        it "is valid when licitation kind is best technique and days difference is greater than 30 days" do
          licitation_process.stub(:judgment_form_licitation_kind).and_return "best_technique"
          subject.should_receive(:respond_to?).with("concurrence_validation", true).and_return true
          days_counter.stub(:count).and_return 31
          expect(subject.valid?).to be true
        end

        it "is not valid when licitation kind is best technique and days difference is lesser or equal than 30 days" do
          licitation_process.stub(:judgment_form_licitation_kind).and_return double(:best_technique, :best_technique? => true)
          subject.should_receive(:respond_to?).with("concurrence_validation", true).and_return true
          days_counter.stub(:count).and_return 30
          licitation_process.stub_chain(:errors, :add)
          expect(subject.valid?).to be false
        end
      end
    end

    describe "taken price" do
      before do
        licitation_process.stub(:administrative_process_modality).and_return :taken_price
      end

      context "licitation kind is best technique" do
        before  do
          licitation_process.stub(:judgment_form_licitation_kind).and_return "best_technique"
        end

        it "is valid when days difference is greater than 30 days" do
          subject.should_receive(:respond_to?).with("taken_price_validation", true).and_return true
          days_counter.stub(:count).and_return 31
          expect(subject.valid?).to be true
        end

        it "is not valid when days difference is lesser or equal than 30 days" do
          subject.should_receive(:respond_to?).with("taken_price_validation", true).and_return true
          days_counter.stub(:count).and_return 30
          licitation_process.stub_chain(:errors, :add)
          expect(subject.valid?).to be false
        end
      end

      context "licitation kind isn't best technique nor technical and price" do
        before  do
          licitation_process.stub(:judgment_form_licitation_kind).and_return double(:kind, :best_technique? => false, :technical_and_price? => false)
        end

        it "is valid when days difference is greater than 15 days" do
          subject.should_receive(:respond_to?).with("taken_price_validation", true).and_return true
          days_counter.stub(:count).and_return 16
          expect(subject.valid?).to be true
        end

        it "is not valid when days difference is lesser or equal than 15 days" do
          subject.should_receive(:respond_to?).with("taken_price_validation", true).and_return true
          days_counter.stub(:count).and_return 15
          licitation_process.stub_chain(:errors, :add)
          expect(subject.valid?).to be false
        end
      end
    end

    describe "auction" do
      before do
        licitation_process.stub(:administrative_process_modality).and_return :auction
      end

      it "is valid when working days difference is greater than 15 days" do
        subject.should_receive(:respond_to?).with("auction_validation", true).and_return true
        days_counter.stub(:count).and_return 16
        expect(subject.valid?).to be true
      end

      it "is not valid when working days difference is lesser or equal than 15 days" do
        days_counter.stub(:count).and_return 15
        subject.should_receive(:respond_to?).with("auction_validation", true).and_return true
        licitation_process.stub_chain(:errors, :add)
        expect(subject.valid?).to be false
      end
    end

    describe "trading" do
      before do
        licitation_process.stub(:administrative_process_modality).and_return :trading
      end

      it "is valid when working days difference is greater than 8 days" do
        subject.should_receive(:respond_to?).with("trading_validation", true).and_return true
        days_counter.stub(:count).and_return 9
        expect(subject.valid?).to be true
      end

      it "is not valid when working days difference is lesser or equal than 8 days" do
        days_counter.stub(:count).and_return 8
        subject.should_receive(:respond_to?).with("trading_validation", true).and_return true
        licitation_process.stub_chain(:errors, :add)
        expect(subject.valid?).to be false
      end
    end

    describe "invitation" do
      before do
        licitation_process.stub(:administrative_process_modality).and_return :invitation
      end

      it "is valid when working days difference is greater than 5 days" do
        subject.should_receive(:respond_to?).with("invitation_validation", true).and_return true
        days_counter.stub(:count).and_return 6
        expect(subject.valid?).to be true
      end

      it "is not valid when working days difference is lesser or equal than 5 days" do
        subject.should_receive(:respond_to?).with("invitation_validation", true).and_return true
        days_counter.stub(:count).and_return 5
        licitation_process.stub_chain(:errors, :add)
        expect(subject.valid?).to be false
      end
    end
  end
end
