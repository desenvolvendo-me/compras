# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_commission'

describe LicitationCommission do
  it { should validate_presence_of :commission_type }
  it { should validate_presence_of :nomination_date }
  it { should validate_presence_of :expiration_date }
  it { should validate_presence_of :exoneration_date }
  it { should validate_presence_of :regulatory_act }

  it { should belong_to :regulatory_act }

  it 'should return id as to_s method' do
    subject.id = 2

    subject.to_s.should eq '2'
  end
  
  it "should not have expiration_date less than nomination_date" do
    subject.nomination_date = Date.current

    subject.should_not allow_value(Date.yesterday).for(:expiration_date).
                                                  with_message("deve ser em ou depois de #{I18n.l(Date.current)}")
  end

  it "should not have exoneration_date less than nomination_date" do
    subject.nomination_date = Date.current

    subject.should_not allow_value(Date.yesterday).for(:exoneration_date).
                                                    with_message("deve ser em ou depois de #{I18n.l(Date.current)}")
  end

  it "should delegate publication_date to regulatory_act with prefix" do
    subject.stub(:regulatory_act).and_return stub(:publication_date => Date.new(2012, 2, 28))
    subject.regulatory_act_publication_date.should eq Date.new(2012, 2, 28)
  end
end