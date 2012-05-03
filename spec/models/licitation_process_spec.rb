# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_process'
require 'app/models/administrative_process'
require 'app/models/capability'
require 'app/models/period'
require 'app/models/payment_method'
require 'app/models/licitation_process_publication'
require 'app/models/licitation_process_bidder'
require 'app/models/licitation_process_impugnment'
require 'app/models/licitation_process_appeal'
require 'app/models/budget_allocation'
require 'app/models/accreditation'
require 'app/models/pledge'
require 'app/models/judgment_commission_advice'
require 'app/models/provider'
require 'app/models/licitation_notice'

describe LicitationProcess do
  it 'should return process/year as to_s' do
    subject.process = '1'
    subject.year = '2012'
    subject.to_s.should eq '1/2012'
  end

  it { should belong_to :administrative_process }
  it { should belong_to :capability }
  it { should belong_to :period }
  it { should belong_to :payment_method }
  it { should have_and_belong_to_many(:document_types) }
  it { should have_many(:licitation_notices).dependent(:destroy) }
  it { should have_many(:licitation_process_publications).dependent(:destroy).order(:id) }
  it { should have_many(:licitation_process_bidders).dependent(:destroy).order(:id) }
  it { should have_many(:licitation_process_impugnments).dependent(:restrict).order(:id) }
  it { should have_many(:licitation_process_appeals).dependent(:restrict) }
  it { should have_one(:accreditation).dependent(:destroy) }
  it { should have_many(:pledges).dependent(:restrict) }
  it { should have_many(:judgment_commission_advices).dependent(:restrict) }
  it { should have_many(:providers).dependent(:restrict).through(:licitation_process_bidders) }

  it { should validate_presence_of :year }
  it { should validate_presence_of :process_date }
  it { should validate_presence_of :administrative_process }
  it { should validate_presence_of :object_description }
  it { should validate_presence_of :capability }
  it { should validate_presence_of :expiration }
  it { should validate_presence_of :readjustment_index }
  it { should validate_presence_of :period }
  it { should validate_presence_of :payment_method }
  it { should validate_presence_of :envelope_delivery_date }
  it { should validate_presence_of :envelope_delivery_time }
  it { should validate_presence_of :envelope_opening_date }
  it { should validate_presence_of :envelope_opening_time }
  it { should validate_presence_of :pledge_type }
  it { should validate_presence_of :type_of_calculation }

  context 'new_envelope_opening_date is not equal to new_envelope_delivery_date' do
    before do
      subject.stub(:new_envelope_opening_date_equal_new_envelope_delivery_date?).and_return(false)
    end

    it { should allow_value("11:11").for(:envelope_delivery_time) }
    it { should_not allow_value("44:11").for(:envelope_delivery_time) }
    it { should allow_value("11:11").for(:envelope_opening_time) }
    it { should_not allow_value("44:11").for(:envelope_opening_time) }
  end

  it "should not have envelope_delivery_date less than today" do
    subject.should_not allow_value(Date.yesterday).
      for(:envelope_delivery_date).with_message("deve ser em ou depois de #{I18n.l Date.current}")
  end

  it "should not have envelope_opening_date less than delivery date" do
    subject.envelope_delivery_date = Date.tomorrow

    subject.should_not allow_value(Date.current).
      for(:envelope_opening_date).with_message("deve ser em ou depois de #{I18n.l Date.tomorrow}")
  end

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('201').for(:year) }
  it { should_not allow_value('a201').for(:year) }

  it 'should validate that selected administrative process is available' do
    subject.errors.messages[:administrative_process].should be_nil

    administrative_process = double('administrative process',
                                    :administrative_process_budget_allocations => [],
                                    :licitation_process => 1)

    subject.stub(:administrative_process).and_return(administrative_process)
    subject.stub(:administrative_process_licitation_process).and_return(true)

    subject.valid?

    subject.errors.messages[:administrative_process].should include 'já está em uso'
  end

  describe '#next_process' do
    context 'when do not has a licitation process with the same year' do
      before do
        subject.stub(:last_by_self_year).and_return(nil)
      end

      it 'should be 1' do
        subject.next_process.should eq 1
      end
    end

    context 'when the process of last licitation process is 4' do
      before do
        subject.stub(:last_by_self_year).and_return(last_by_self_year)
      end

      let :last_by_self_year do
        double(:last_by_self_year, :process => 4)
      end

      it 'should be 5' do
        subject.next_process.should eq 5
      end
    end
  end

  describe '#next_licitation_number' do
    context 'when do not has a licitation process with the same year and modality' do
      before do
        subject.stub(:last_by_self_year_and_modality).and_return(nil)
      end

      it 'should be 1' do
        subject.next_licitation_number.should eq 1
      end
    end

    context 'when the licitation_number of last licitation process is 4' do
      before do
        subject.stub(:last_by_self_year_and_modality).and_return(last_by_self_year_and_modality)
      end

      let :last_by_self_year_and_modality do
        double(:last_by_self_year_and_modality, :licitation_number => 4)
      end

      it 'should be 5' do
        subject.next_licitation_number.should eq 5
      end
    end
  end

  it 'should not have process_date less than administrative_process_date' do
    subject.stub(:administrative_process_date).and_return(Date.new(2012, 4, 25))

    subject.should_not allow_value(Date.new(2012, 4, 24)).for(:process_date).
                                                         with_message("deve ser em ou depois de 25/04/2012")
  end

   it 'should have process_date equal or greater than administrative_process_date' do
    subject.stub(:administrative_process_date).and_return(Date.new(2012, 4, 25))

    subject.should allow_value(Date.new(2012, 4, 25)).for(:process_date)
  end

  it 'should tell if it can have invitation bidders' do
    subject.stub(:envelope_opening_date).and_return(Date.tomorrow)

    subject.can_have_bidders?.should eq false

    subject.stub(:envelope_opening_date).and_return(Date.current)

    subject.can_have_bidders?.should eq true

    subject.stub(:envelope_opening_date).and_return(Date.yesterday)

    subject.can_have_bidders?.should eq true
   end

  it 'should return the advice number correctly' do
    subject.stub(:judgment_commission_advices).and_return([1, 2, 3])

    subject.advice_number.should eq 3
  end

  describe 'publication' do
    context 'when has not publication' do
      it 'should can be updated' do
        subject.can_update?.should eq true
      end
    end

    context 'when publication_of is any of [extension, edital, edital_rectification]' do
      let :publication  do
        double :publication
      end

      it 'should can update when publication_of is extension' do
        publication.should_receive(:id).and_return(1)
        publication.should_receive(:extension?).and_return(true)
        subject.stub(:licitation_process_publications => [ publication ])
        subject.can_update?.should eq true
      end

      it 'should can update when publication_of is edital' do
        publication.should_receive(:id).and_return(1)
        publication.should_receive(:extension?).and_return(false)
        publication.should_receive(:edital?).and_return(true)
        subject.stub(:licitation_process_publications => [ publication ])
        subject.can_update?.should eq true
      end

      it 'should can update when publication_of is edital_rectification' do
        publication.should_receive(:id).and_return(1)
        publication.should_receive(:extension?).and_return(false)
        publication.should_receive(:edital?).and_return(false)
        publication.should_receive(:edital_rectification?).and_return(true)
        subject.stub(:licitation_process_publications => [ publication ])
        subject.can_update?.should eq true
      end
    end

    context 'when publication_of is not any of [extension, edital, edital_rectification]' do
      let(:publication) do
        double(:publication)
      end

      it 'should can not update' do
        publication.should_receive(:id).and_return(1)
        publication.should_receive(:extension?).and_return(false)
        publication.should_receive(:edital?).and_return(false)
        publication.should_receive(:edital_rectification?).and_return(false)
        subject.stub(:licitation_process_publications => [ publication ])
        subject.can_update?.should eq false
      end
    end
  end
end
