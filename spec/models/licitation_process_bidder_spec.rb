# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_process_bidder'
require 'app/models/licitation_process_bidder_proposal'
require 'app/models/licitation_process_bidder_document'
require 'app/models/licitation_process'
require 'app/models/creditor'
require 'app/models/licitation_process_bidder'
require 'app/models/accredited_representative'

describe LicitationProcessBidder do

  describe 'default values' do
    it 'uses false as default for invited' do
      subject.invited.should be false
    end
  end

  it { should belong_to :licitation_process }
  it { should belong_to :creditor }

  it { should have_many(:documents).dependent(:destroy).order(:id) }
  it { should have_many(:document_types).through(:documents) }
  it { should have_many(:accredited_representatives).dependent(:destroy) }
  it { should have_many(:people).through(:accredited_representatives) }

  it { should validate_presence_of :creditor }

  context "licitation kind" do
    before do
      subject.stub(:administrative_process => administrative_process)
    end

    let :administrative_process do
      double('administrative_process')
    end

    it "should validate technical_score when licitation kind is best_technique" do
      administrative_process.stub(:judgment_form_best_technique?).and_return(true)
      should validate_presence_of(:technical_score)
    end

    it "should validate technical_score when licitation kind is technical_and_price" do
      administrative_process.stub(:judgment_form_best_technique?).and_return(false)
      administrative_process.stub(:judgment_form_technical_and_price?).and_return(true)
      should validate_presence_of(:technical_score)
    end

    it "should not validate technical_score when licitation kind is not best_technique or technical_and_price" do
      administrative_process.stub(:judgment_form_best_technique?).and_return(false)
      administrative_process.stub(:judgment_form_technical_and_price?).and_return(false)
      should_not validate_presence_of(:technical_score)
    end
  end

  context 'validate protocol_date related with today' do
    before do
      subject.invited = true
    end

    it { should allow_value(Date.current).for(:protocol_date) }

    it { should allow_value(Date.tomorrow).for(:protocol_date) }

    it 'should not allow date after today' do
      subject.should_not allow_value(Date.yesterday).for(:protocol_date).
        with_message("deve ser hoje ou depois de hoje (#{I18n.l(Date.current)})")
    end
  end

  context 'validate receipt_date related with protocol_date' do
    let :protocol_date do
      Date.current + 10.days
    end

    before do
      subject.stub(:protocol_date).and_return(protocol_date)
      subject.invited = true
    end

    it 'should allow receipt_date date after protocol_date' do
      subject.should allow_value(Date.current + 15.days).for(:receipt_date)
    end

    it 'should allow receipt_date date equals to protocol_date' do
      subject.should allow_value(protocol_date).for(:receipt_date)
    end

    it 'should not allow receipt_date date before protocol_date' do
      subject.should_not allow_value(Date.current).for(:receipt_date).
                                                    with_message("deve ser igual ou posterior a data do protocolo (#{I18n.l protocol_date})")
    end
  end

  it "should validate presence of dates, protocol when it is not invite" do
    subject.invited = false

    subject.valid?

    subject.errors.messages[:protocol].should be_nil
    subject.errors.messages[:protocol_date].should be_nil
    subject.errors.messages[:receipt_date].should be_nil
  end

  it "should not validate presence of dates, protocol when it is invite" do
    subject.invited = true

    subject.valid?

    subject.errors.messages[:protocol].should include "não pode ficar em branco"
    subject.errors.messages[:protocol_date].should include "não pode ficar em branco"
    subject.errors.messages[:receipt_date].should include "não pode ficar em branco"
  end

  it 'should return licitation process  - id as to_s method' do
    subject.stub(:creditor => double(:to_s => 'Fulano'))

    subject.to_s.should eq 'Fulano'
  end

  describe 'before_save' do
    it 'should clear dates, protocol when is not invited' do
      subject.invited = false
      subject.protocol = 1234
      subject.protocol_date = Date.new(2012, 1, 1)
      subject.receipt_date = Date.new(2012, 1, 1)

      subject.run_callbacks(:save)

      subject.invited = false
      subject.protocol.should be nil
      subject.protocol_date.should be nil
      subject.receipt_date.should be nil
    end

    describe "proposal" do
      let :proposal do
        double :proposal
      end

      it "should proposal situation be nil on create" do
        proposal.stub(:situation).with(SituationOfProposal::CANCELED)
        subject.stub(:proposals => [ proposal ])
        proposal.should_receive(:classification=)
        proposal.should_receive(:unit_price=)
        proposal.should_receive(:unit_price)
        proposal.should_receive(:situation=).with(nil)

        subject.run_callbacks(:save)
      end

      it "should proposal classificaton be nil on create" do
        proposal.stub(:classification).with(9)
        subject.stub(:proposals => [ proposal ])
        proposal.should_receive(:situation=)
        proposal.should_receive(:unit_price=)
        proposal.should_receive(:unit_price)
        proposal.should_receive(:classification=).with(nil)

        subject.run_callbacks(:save)
      end

      it "should proposal unit_price be 0 if was nil on create" do
        proposal.stub(:unit_price)
        subject.stub(:proposals => [ proposal ])
        proposal.should_receive(:situation=)
        proposal.should_receive(:classification=)
        proposal.should_receive(:unit_price=).with(0)

        subject.run_callbacks(:save)
      end

      it "should not change proposal unit_price if has value on create" do
        proposal.stub(:unit_price => 99)
        subject.stub(:proposals => [ proposal ])
        proposal.should_receive(:situation=)
        proposal.should_receive(:classification=)
        proposal.should_not_receive(:unit_price=).with(0)

        subject.run_callbacks(:save)
      end
    end
  end

  it "should can update proposals when all licitation process lots are filled" do
    subject.stub_chain(:licitation_process, :filled_lots?).and_return(true)
    subject.should be_can_update_proposals
  end

  it "should can update proposals when has not any lots" do
    subject.stub_chain(:licitation_process, :filled_lots?).and_return(false)
    subject.stub(:licitation_process_lots).and_return( Array.new )
    subject.should be_can_update_proposals
  end

  context "with licitation_process" do
    before do
      subject.stub(:licitation_process => licitation_process)
    end

    let :licitation_process do
      double('licitation_process', :administrative_process => nil)
    end

    it "should not allow changes if licitation_process does not allow_bidders" do
      licitation_process.stub(:allow_bidders?).and_return(false)

      subject.valid?
      subject.errors[:licitation_process].should include "deve ser a data da abertura do envelope do processo licitatório"
    end

    it "shuld allow changes if licitation_process allow bidders" do
      licitation_process.stub(:allow_bidders?).and_return(true)

      subject.valid?
      subject.errors[:licitation_process].should_not include "deve ser a data da abertura do envelope do processo licitatório"
    end
  end
end
