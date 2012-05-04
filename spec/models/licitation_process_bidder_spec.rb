# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_process_bidder'
require 'app/models/licitation_process_bidder_document'
require 'app/models/licitation_process'
require 'app/models/provider'

describe LicitationProcessBidder do
  it { should belong_to :licitation_process }
  it { should belong_to :provider }

  it { should have_many(:documents).dependent(:destroy).order(:id) }
  it { should have_many(:document_types).through(:documents) }

  it { should validate_presence_of :provider }

  it "should not have protocol_date less than today" do
    subject.invited = true
    subject.should_not allow_value(Date.yesterday).
      for(:protocol_date).with_message("deve ser em ou depois de #{I18n.l Date.current}")
  end

  it "should not have receipt_date less than protocol date" do
    subject.invited = true
    subject.protocol_date = Date.current + 5.days

    subject.should_not allow_value(Date.current + 4.days).
      for(:receipt_date).with_message("deve ser em ou depois de #{I18n.l (Date.current + 5.days)}")
  end

  it "should validate presence of dates, protocol when it is not invite" do
    subject.invited = false

    subject.valid?

    subject.errors.messages[:protocol].should be_nil
    subject.errors.messages[:protocol_date].should be_nil
    subject.errors.messages[:receipt_date].should be_nil
  end

  it "should not validate presence of dates, protocol when it is invite" do
    subject.invited = true

    subject.valid?

    subject.errors.messages[:protocol].should include "não pode ficar em branco"
    subject.errors.messages[:protocol_date].should include "não pode ficar em branco"
    subject.errors.messages[:receipt_date].should include "não pode ficar em branco"
  end

  it 'should return licitation process  - id as to_s method' do
    subject.stub(:licitation_process).and_return(double(:to_s => '1/2012'))
    subject.id = 5

    subject.to_s.should eq '1/2012 - 5'
  end

  describe 'before_save' do
    it 'should clear dates, protocol when is not invited' do
      subject.invited = false
      subject.protocol = 1234
      subject.protocol_date = Date.new(2012, 1, 1)
      subject.receipt_date = Date.new(2012, 1, 1)

      subject.run_callbacks(:save)

      subject.invited = false
      subject.protocol.should be nil
      subject.protocol_date.should be nil
      subject.receipt_date.should be nil
    end
  end
end
