require 'model_helper'
require 'app/models/subpledge_expiration'

describe SubpledgeExpiration do
  it 'should return number as to_s' do
    subject.number = '1'
    subject.to_s.should eq '1'
  end

  it { should belong_to :subpledge }

  it { should validate_presence_of :expiration_date }
  it { should validate_presence_of :value }

  it 'should not have expiration_date less than today' do
    subject.should_not allow_value(Date.yesterday).
      for(:expiration_date).with_message("deve ser em ou depois de #{I18n.l Date.current}")
  end
end
