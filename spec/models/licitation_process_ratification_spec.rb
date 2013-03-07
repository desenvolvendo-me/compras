# encoding: utf-8
require 'model_helper'
require 'lib/signable'
require 'app/models/licitation_process_ratification'
require 'app/models/licitation_process_ratification_item'

describe LicitationProcessRatification do
  it 'should return sequence as to_s' do
    subject.stub(:sequence => 1, :licitation_process => '1/2012')
    expect(subject.to_s).to eq '1 - Processo de Compra 1/2012'
  end

  it { should belong_to :licitation_process }

  it { should have_many(:licitation_process_ratification_items).dependent(:destroy) }
  it { should have_many(:bidder_proposals) }

  it { should validate_presence_of :licitation_process }
  it { should validate_presence_of :ratification_date }
  it { should validate_presence_of :adjudication_date }
  it { should validate_presence_of :bidder }

  it { should delegate(:process).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:modality_humanize).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:description).to(:licitation_process).allowing_nil(true).prefix(true) }

  context 'bidder should belongs to licitation process' do
    let :bidder_with_licitation_process do
      double(:licitation_process => licitation_process)
    end

    let :bidder_with_new_licitation_process do
      double(:licitation_process => double)
    end

    let :licitation_process do
      double(:to_s => '1/2012')
    end

    before do
      subject.stub(:licitation_process => licitation_process)
    end

    it 'should be valid' do
      subject.stub(:bidder => bidder_with_licitation_process)

      subject.valid?

      expect(subject.errors[:bidder]).to be_empty
    end

    it 'should be invalid' do
      subject.stub(:bidder => bidder_with_new_licitation_process)

      subject.valid?

      expect(subject.errors[:bidder]).to include "deve pertencer ao processo licitatório 1/2012"
    end
  end
end
