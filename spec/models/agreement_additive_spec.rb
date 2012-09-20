# encoding: utf-8
require 'model_helper'
require 'app/models/agreement_additive'

describe AgreementAdditive do
  it { should validate_presence_of :description }
  it { should validate_presence_of :kind }
  it { should validate_presence_of :regulatory_act }

  it { should belong_to(:agreement) }
  it { should belong_to(:regulatory_act) }

  context 'when have agreement' do
    before do
      subject.stub(:agreement).and_return(agreement)
    end

    let :agreement do
      double('Agreement', :year => '2009')
    end

    it 'should delegate year to agreement' do
      expect(subject.year).to eq '2009'
    end
  end

  describe 'validating value' do
    it 'should be required when the kind is value' do
      subject.stub(:kind_value?).and_return true

      expect(subject).to validate_presence_of :value
    end

    it 'should not be required when the kind is not value' do
      subject.stub(:kind_value?).and_return false

      expect(subject).not_to validate_presence_of :value
    end
  end
end
