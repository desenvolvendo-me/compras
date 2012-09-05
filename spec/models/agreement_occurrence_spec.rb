# encoding: utf-8
require 'model_helper'
require 'app/models/agreement_occurrence'

describe AgreementOccurrence do
  it { should validate_presence_of :kind }
  it { should validate_presence_of :date }
  it { should validate_presence_of :description }

  it { should belong_to(:agreement) }

  describe '#inactive?' do
    it 'should return true if kind is in inactive kinds list' do
      subject.stub(:kind => 'other')

      expect(subject.inactive?).to be true
    end

    it 'should return true if kind is in inactive kinds list' do
      subject.stub(:kind => 'paralyzed')

      expect(subject.inactive?).to be true
    end

    it 'should return false if kind is not in inactive kinds list' do
      subject.stub(:kind => 'in_progress')

      expect(subject.inactive?).to be false
    end
  end
end
