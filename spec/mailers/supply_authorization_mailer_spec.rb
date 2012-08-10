# encoding: utf-8
require "spec_helper"

describe SupplyAuthorizationMailer do
  context 'authorization to creditor' do
    let :prefecture do
      double(:email => 'prefeitura@nobesistemas.com.br')
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

    it 'should render prefecture email' do
      mail.from.should include 'prefeitura@nobesistemas.com.br'
    end

    it 'should not render prefecture email' do
      prefecture.stub(:email => nil)

      mail.from.should be_nil
    end
  end
end
