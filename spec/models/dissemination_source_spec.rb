# encoding: utf-8
require 'model_helper'
require 'app/models/dissemination_source'

describe DisseminationSource do
  it 'should return to_s method with description' do
    subject.description = 'Jornal Oficial do Município'
    subject.to_s.should eq 'Jornal Oficial do Município'
  end

  it { should belong_to :communication_source }

  it { should validate_presence_of :description }
  it { should validate_presence_of :communication_source }

  context "with regulatory_acts" do
    let :regulatory_acts do
      [ double('regulatory_act') ]
    end

    it "should not destroy if has association with regulatory_acts" do
      subject.stub(:regulatory_acts => regulatory_acts)

      subject.run_callbacks(:destroy)

      subject.errors[:base].should include "não pode ter relacionamento com ato regulamentador"
    end
  end

  it "should destroy if does not have relationship with regulatory_acts" do
    subject.run_callbacks(:destroy)

    subject.errors[:base].should_not include "não pode ter relacionamento com ato regulamentador"
  end
end
