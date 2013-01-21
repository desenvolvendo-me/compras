# encoding: utf-8
require "spec_helper"

describe PriceCollectionMailer do
  let :user do
    stub_model(User, :id => 1, :email => 'gabriel.sobrinho@gmail.com', :confirmation_token => 'xyz123').tap do |user|
      user.stub(:name => 'Gabriel Sobrinho')
    end
  end

  let :price_collection do
    double(:to_s => '1/2012')
  end

  describe '#price_collection_invite_new_creditor' do
    let :mail do
      described_class.invite_new_creditor(user, price_collection)
    end

    it 'should render subject' do
      mail.subject.should eq 'Convite para o Registro de Preço 1/2012'
    end

    it 'should render receiver email' do
      mail.to.should include 'gabriel.sobrinho@gmail.com'
    end

    it 'should render creditor name' do
      mail.body.encoded.should include('Gabriel Sobrinho')
    end

    it 'should render price collection identifier' do
      mail.body.encoded.should include('1/2012')
    end

    it 'should render user confirmation link' do
      mail.body.encoded.should include('http://localhost/users/confirmation?confirmation_token=xyz123')
    end
  end
end
