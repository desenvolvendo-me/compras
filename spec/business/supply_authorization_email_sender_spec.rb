require 'unit_helper'
require 'active_support/core_ext/module/delegation'
require 'app/business/supply_authorization_email_sender'

describe SupplyAuthorizationEmailSender do
  subject do
    SupplyAuthorizationEmailSender.new(
      supply_authorization,
      context,
      supply_authorization_mailer
    )
  end

  let :supply_authorization do
    double(:supply_authorization, :direct_purchase => direct_purchase)
  end

  let :direct_purchase do
    double(:direct_purchase)
  end

  let :context do
    double(:context, :current_prefecture => 'Modelo')
  end

  let :supply_authorization_mailer do
    double(:supply_authorization_mailer)
  end

  it 'should delegates direct_purchase to supply_authorization' do
    supply_authorization.should_receive(:direct_purchase).
                         and_return(direct_purchase)

    subject.direct_purchase
  end

  it 'should delegates render_to_pdf to context' do
    context.should_receive(:render_to_pdf)

    subject.render_to_pdf
  end

  it 'should delegates current_prefecture to context' do
    context.should_receive(:current_prefecture)

    subject.current_prefecture
  end

  it 'should send authorization by email' do
    supply_authorization.stub(:annulled?).and_return(false)

    supply_authorization.should_receive(:present?).and_return(true)

    context.
      should_receive(:render_to_pdf).
      with("direct_purchases/supply_authorizations", :locals => { :resource => supply_authorization }).
      and_return('pdf')

    supply_authorization_mailer.should_receive(:deliver)

    supply_authorization_mailer.
      should_receive(:authorization_to_creditor).
      with(direct_purchase, 'Modelo', 'pdf').
      and_return(supply_authorization_mailer)

    subject.deliver
  end

it 'should send annulment by email' do
    supply_authorization.stub(:annulled?).and_return(true)

    supply_authorization.should_receive(:present?).and_return(true)

    context.
      should_receive(:render_to_pdf).
      with("direct_purchases/supply_authorizations", :locals => { :resource => supply_authorization }).
      and_return('pdf')

    supply_authorization_mailer.should_receive(:deliver)

    supply_authorization_mailer.
      should_receive(:annulment_to_creditor).
      with(direct_purchase, 'Modelo', 'pdf').
      and_return(supply_authorization_mailer)

    subject.deliver
  end

  it 'should not send email when supply_authorization is not present' do
    supply_authorization.stub(:annulled?).and_return(true)

    supply_authorization.should_receive(:present?).and_return(false)

    supply_authorization_mailer.should_not_receive(:deliver)

    subject.deliver
  end
end
