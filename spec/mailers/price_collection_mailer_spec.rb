# encoding: utf-8
require "spec_helper"

describe PriceCollectionMailer do
  describe '#price_collection_invite_new_creditor' do
    let(:price_collection) { double(:price_collection, :to_s => '1/2012')}

    let :user do
      stub_model(User, :id => 1, :email => 'gabriel.sobrinho@gmail.com', :confirmation_token => 'xyz123').tap do |user|
        user.stub(:name => 'Gabriel Sobrinho')
      end
    end

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

  describe '#invite_registrated_creditor', :type => :request do
    let(:price_collection) { PriceCollection.make!(:coleta_de_precos) }
    let(:creditor) { price_collection.price_collection_proposals.first.creditor }
    let(:customer) { double(:customer, :domain => 'example.com')}

    let :mail do
      described_class.invite_registered_creditor(creditor, price_collection, 'Belo Horizonte', customer)
    end

    it 'should render subject' do
      mail.subject.should eq 'Convite para o Registro de Preço 1/2012'
    end

    it 'should render creditor name' do
      mail.body.encoded.should include('Wenderson Malheiros')
    end

    it 'should render current prefecture' do
      mail.body.encoded.should include('Belo Horizonte')
    end

    it 'should render user confirmation link' do
      mail.body.encoded.should include('http://example.com/price_collection_proposals/1/edit')
    end
  end
end
