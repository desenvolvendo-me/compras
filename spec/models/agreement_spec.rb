require 'model_helper'
require 'app/uploaders/document_uploader'
require 'app/models/agreement'

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

  it { should validate_presence_of :code }
  it { should validate_presence_of :number }
  it { should validate_presence_of :year }
  it { should validate_presence_of :category }
  it { should validate_presence_of :agreement_kind }
  it { should validate_presence_of :value }
  it { should validate_presence_of :counterpart_value }
  it { should validate_presence_of :parcels_number }
  it { should validate_presence_of :description }
  it { should validate_presence_of :process_date }
  it { should validate_presence_of :process_year }
  it { should validate_presence_of :process_number }
  it { should validate_presence_of :regulatory_act }

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

  context '#number_year' do
    it 'should split to number and year' do
      subject.should_receive(:number=).with('10')
      subject.should_receive(:year=).with('2012')
      subject.number_year = "10/2012"
    end

    it 'should return joined' do
      subject.number = 10
      subject.year = 2012
      expect(subject.number_year).to eq '10/2012'
    end
  end

  context '#number_year_process' do
    it 'should split to number and year' do
      subject.should_receive(:process_number=).with('10')
      subject.should_receive(:process_year=).with('2012')
      subject.number_year_process = "10/2012"
    end

    it 'should return joined' do
      subject.process_number = 234
      subject.process_year = 2008
      expect(subject.number_year_process).to eq '234/2008'
    end
  end
end
