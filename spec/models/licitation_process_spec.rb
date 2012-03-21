# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_process'
require 'app/models/administrative_process'
require 'app/models/capability'
require 'app/models/period'
require 'app/models/payment_method'

describe LicitationProcess do
  it 'should return process/year as to_s' do
    subject.process = '1'
    subject.year = '2012'
    subject.to_s.should eq '1/2012'
  end

  it { should belong_to :administrative_process }
  it { should belong_to :capability }
  it { should belong_to :period }
  it { should belong_to :payment_method }


  it { should validate_presence_of  :year }
  it { should validate_presence_of :process_date }
  it { should validate_presence_of :administrative_process }
  it { should validate_presence_of :object_description }
  it { should validate_presence_of :capability }
  it { should validate_presence_of :expiration }
  it { should validate_presence_of :readjustment_index }
  it { should validate_presence_of :period }
  it { should validate_presence_of :payment_method }
  it { should validate_presence_of :envelope_delivery_date }
  it { should validate_presence_of :envelope_delivery_time }

  it "should not have envelope_delivery_date less than today" do
    subject.should_not allow_value(Date.yesterday).
      for(:envelope_delivery_date).with_message("deve ser em ou depois de #{I18n.l Date.current}")
  end

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('201').for(:year) }
  it { should_not allow_value('a201').for(:year) }
end
