# encoding: utf-8
require 'model_helper'
require 'app/models/agreement_occurrence'

describe AgreementOccurrence do
  it { should validate_presence_of :kind }
  it { should validate_presence_of :date }
  it { should validate_presence_of :description }

  it { should belong_to(:agreement) }

  describe '#active?' do
    it 'should be true when the kind is "in progress"' do
      subject.stub(:kind => 'in_progress')

      expect(subject.active?).to be true
    end

    it 'should be false when the kind is different of "in progress"' do
      subject.stub(:kind => 'other')

      expect(subject.active?).to be false
    end
  end
end
