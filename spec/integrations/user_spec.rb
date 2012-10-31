# encoding: utf-8
require 'spec_helper'

describe User do
  it 'validate uniqueness of authenticable_id scoped to authenticable_type' do
    user = User.make!(:wenderson)

    subject.authenticable_type = user.authenticable_type
    subject.authenticable_id = user.authenticable_id

    subject.valid?

    expect(subject.errors[:authenticable_id]).to include 'já está em uso'
  end

  context 'devise confirmation email' do
    it 'should not send if user is creditor' do
      subject.stub(:valid?).and_return(true)

      subject.authenticable_type = 'Creditor'
      subject.should_not_receive(:send_devise_notification)

      subject.save
    end

    it 'should send if user is employee' do
      subject.stub(:valid?).and_return(true)

      subject.authenticable_type = 'Employee'
      subject.should_receive(:send_devise_notification).with(:confirmation_instructions)

      subject.save
    end

    it 'should send if user is provider' do
      subject.stub(:valid?).and_return(true)

      subject.authenticable_type = 'Provider'
      subject.should_receive(:send_devise_notification).with(:confirmation_instructions)

      subject.save
    end
  end
end