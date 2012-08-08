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
end
