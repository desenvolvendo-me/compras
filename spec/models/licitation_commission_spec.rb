# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_commission'

describe LicitationCommission do
  it { should validate_presence_of :commission_type }
  it { should validate_presence_of :nomination_date }
  it { should validate_presence_of :expiration_date }
  it { should validate_presence_of :exoneration_date }

  it 'should return id as to_s method' do
    subject.id = 2

    subject.to_s.should eq '2'
  end
  
  it "should not have expiration_date less than nomination_date" do
    subject.nomination_date = Date.current
    subject.expiration_date = subject.nomination_date - 1.day

    subject.should_not be_valid
    subject.errors[:expiration_date].should include("deve ser em ou depois de #{I18n.l subject.nomination_date}")
  end
  
  it "should not have exoneration_date less than nomination_date" do
    subject.nomination_date = Date.current
    subject.exoneration_date = subject.nomination_date - 1.day

    subject.should_not be_valid
    subject.errors[:exoneration_date].should include("deve ser em ou depois de #{I18n.l subject.nomination_date}")
  end
end
