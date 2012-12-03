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
      licitation_process = double(:envelope_opening_date => Date.new(2012, 2, 1))
      subject.stub(:licitation_process => licitation_process)
      subject.publication_date = Date.new(2012, 2, 2)
      subject.publication_of = PublicationOf::EDITAL

      subject.valid?

      expect(subject.errors[:publication_date]).to include "deve ser anterior à data de abertura dos envelopes"
    end

    it "only validates publication date of publications of editals" do
      licitation_process = double(:envelope_opening_date => Date.new(2012, 2, 1))
      subject.stub(:licitation_process => licitation_process)
      subject.publication_date = Date.new(2012, 2, 2)

      subject.valid?

      expect(subject.errors[:publication_date]).to be_empty
    end
  end
end
