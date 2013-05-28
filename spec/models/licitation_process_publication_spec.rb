# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_process'
require 'app/models/licitation_process_publication'

describe LicitationProcessPublication do
  it { should belong_to :licitation_process }

  it { should validate_presence_of :name }
  it { should validate_presence_of :publication_date }
  it { should validate_presence_of :publication_of }
  it { should validate_presence_of :circulation_type }

  it "should return name as to_s" do
    subject.name = 'Jornal'

    expect(subject.to_s).to eq 'Jornal'
  end

  describe "validation of publication date" do
    it "validates if publication date is prior to envelope opening" do
      licitation_process = double(:proposal_envelope_opening_date => Date.new(2012, 2, 1))
      licitation_process.stub(direct_purchase?: false)
      subject.stub(:licitation_process => licitation_process)
      subject.publication_date = Date.new(2012, 2, 2)
      subject.publication_of = PublicationOf::EDITAL

      subject.valid?

      expect(subject.errors[:publication_date]).to include "deve ser anterior à data de abertura dos envelopes"
    end

    it "only validates publication date of publications of editals when has licitation processes" do
      licitation_process = double(:proposal_envelope_opening_date => nil)
      licitation_process.stub(direct_purchase?: false)
      subject.stub(:licitation_process => licitation_process)
      subject.publication_date = Date.new(2012, 2, 2)
      subject.publication_of = PublicationOf::EDITAL

      subject.valid?

      expect(subject.errors[:publication_date]).to be_empty
    end

    it "only validates publication date of publications of editals" do
      licitation_process = double(:proposal_envelope_opening_date => Date.new(2012, 2, 1))
      licitation_process.stub(direct_purchase?: false)
      subject.stub(:licitation_process => licitation_process)
      subject.publication_date = Date.new(2012, 2, 2)

      subject.valid?

      expect(subject.errors[:publication_date]).to be_empty
    end
  end

  describe 'validate publication_of when edital' do
    let(:licitation_process) { double(:licitation_process, proposal_envelope_opening_date: nil) }

    before do
      subject.stub(licitation_process: licitation_process)
    end

    context 'when direct_purchase' do
      before do
        licitation_process.stub(direct_purchase?: true)
      end

      it { should_not allow_value(PublicationOf::EDITAL).for(:publication_of) }
    end

    context 'when not direct_purchase' do
      before do
        licitation_process.stub(direct_purchase?: false)
      end

      it { should allow_value(PublicationOf::EDITAL).for(:publication_of) }
    end
  end
end
