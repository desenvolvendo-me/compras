require 'model_helper'
require 'app/uploaders/document_uploader'
require 'app/models/agreement_occurrence'
require 'app/models/agreement'
require 'app/models/agreement_bank_account'
require 'app/models/agreement_additive'
require 'app/models/tce_capability_agreement'

describe Agreement do
  it 'should return description as to_s' do
    subject.description = 'Apoio ao fomento do turismo'
    expect(subject.to_s).to eq 'Apoio ao fomento do turismo'
  end

  it { should belong_to :agreement_kind }
  it { should belong_to :regulatory_act }

  it { should have_many(:agreement_bank_accounts).dependent(:destroy) }
  it { should have_many(:tce_specification_capabilities).dependent(:restrict).through(:tce_capability_agreements) }
  it { should have_many(:tce_capability_agreements).dependent(:restrict) }
  it { should have_many(:agreement_occurrences).dependent(:destroy) }
  it { should have_many(:agreement_additives).dependent(:destroy).order(:number) }

  it { should validate_presence_of :number_year }
  it { should validate_presence_of :category }
  it { should validate_presence_of :agreement_kind }
  it { should validate_presence_of :value }
  it { should validate_presence_of :counterpart_value }
  it { should validate_presence_of :parcels_number }
  it { should validate_presence_of :description }
  it { should validate_presence_of :process_date }
  it { should validate_presence_of :number_year_process }
  it { should validate_presence_of :regulatory_act }

  it { should allow_value('111/2012').for(:number_year) }
  it { should_not allow_value('111').for(:number_year) }
  it { should_not allow_value('1a1/2012').for(:number_year) }

  it { should allow_value('111/2012').for(:number_year_process) }
  it { should_not allow_value('111').for(:number_year_process) }
  it { should_not allow_value('1a1/2012').for(:number_year_process) }

  context 'delegate to regulatory_act' do
    before do
      subject.stub(:regulatory_act).and_return(regulatory_act)
    end

    let :regulatory_act do
      double('RegulatoryAct',
             :creation_date => Date.new(2012, 12, 29),
             :publication_date => Date.new(2012, 12, 30),
             :end_date => Date.new(2012, 12, 31)
            )
    end

    it "creation_date" do
      expect(subject.creation_date).to eq Date.new(2012, 12, 29)
    end

    it "publication_date" do
      expect(subject.publication_date).to eq Date.new(2012, 12, 30)
    end

    it "end_date" do
      expect(subject.end_date).to eq Date.new(2012, 12, 31)
    end
  end

  context 'last additive number' do
    before do
      subject.stub(:agreement_additives).and_return(additives)
    end

    context 'when dont have additives' do
      let :additives do
        []
      end

      it 'should return last additive number' do
        expect(subject.last_additive_number).to eq 0
      end
    end

    context 'when have one additive' do
      let :additives do
        [ double('Additive', :number => 2, :persisted? => true) ]
      end

      it 'should return last additive number' do
        expect(subject.last_additive_number).to eq 2
      end
    end
  end
end
