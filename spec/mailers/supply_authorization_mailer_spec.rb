# encoding: utf-8
require "spec_helper"

describe SupplyAuthorizationMailer do
  context 'authorization to creditor' do
    let :prefecture do
      double
    end

    let :mail do
      SupplyAuthorizationMailer.authorization_to_creditor(direct_purchase, prefecture)
    end

    let :direct_purchase do
      double(:creditor_person_email => 'wenderson.malheiros@gmail.com', :creditor => 'Wenderson Malheiros', :supply_authorization => nil)
    end

    it 'should render subject' do
      mail.subject.should eq 'Autorização de Fornecimento'
    end

    it 'should render receiver email' do
      mail.to.should include 'wenderson.malheiros@gmail.com'
    end

    it 'should render creditor name' do
      mail.body.encoded.should match('Wenderson Malheiros')
    end
  end
end
