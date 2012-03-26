# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_process_invited_bidder'
require 'app/models/licitation_process'
require 'app/models/provider'

describe LicitationProcessInvitedBidder do
  it { should belong_to :licitation_process }
  it { should belong_to :provider }

  it { should validate_presence_of :provider_id }
  it { should validate_presence_of :protocol }

  it "should not have protocol_date less than today" do
    subject.should_not allow_value(Date.yesterday).
      for(:protocol_date).with_message("deve ser em ou depois de #{I18n.l Date.current}")
  end

  it "should not have receipt_date less than protocol date" do
    subject.protocol_date = Date.current + 5.days

    subject.should_not allow_value(Date.current + 4.days).
      for(:receipt_date).with_message("deve ser em ou depois de #{I18n.l (Date.current + 5.days)}")
  end

  it "should validate presence of dates when it is not auto convocation" do
    subject.auto_convocation = true

    subject.valid?

    subject.errors.messages[:protocol_date].should be_nil
    subject.errors.messages[:receipt_date].should be_nil
  end

  it "should not validate presence of dates when it is auto convocation" do
    subject.auto_convocation = false

    subject.valid?

    subject.errors.messages[:protocol_date].should include "não pode ficar em branco"
    subject.errors.messages[:receipt_date].should include "não pode ficar em branco"
  end
end
