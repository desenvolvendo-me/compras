# encoding: utf-8
require 'model_helper'
require 'app/models/agreement_additive'

describe AgreementAdditive do
  it { should validate_presence_of :description }
  it { should validate_presence_of :kind }
  it { should validate_presence_of :regulatory_act }
  it { should validate_presence_of :value }

  it { should belong_to(:agreement) }
  it { should belong_to(:regulatory_act) }

  context 'when have agreement' do
    before do
      subject.stub(:agreement).and_return(agreement)
    end

    let :agreement do
      double('Agreement', :number_year => '1/2009')
    end

    it 'should delegate year to agreement' do
      expect(subject.year).to eq '2009'
    end
  end
end
