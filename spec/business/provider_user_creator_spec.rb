#encoding: utf-8
require 'unit_helper'
require './app/business/provider_user_creator'

describe ProviderUserCreator do
  let :price_collection do
    double('Price Collection', :price_collection_proposals => price_collection_proposals)
  end

  let :price_collection_proposals do
    [
      double('Proposal 1', :provider => provider_1),
      double('Proposal 2', :provider => provider_2)
    ]
  end

  let :provider_1 do
    double('Provider 1', :id => 1, :name => 'João da Silva', :email => 'joao@silva.com', :login => 'joao.silva')
  end

  let :provider_2 do
    double('Provider 2', :id => 2, :name => 'Manoel Pereira', :email => 'manoel@pereira.com', :login => 'manoel.pereira')
  end

  let :user_storage do
    double('User Storage')
  end

  subject{ described_class.new(price_collection, 'Provider', user_storage) }

  context 'none of the users exists' do
    before do
      provider_1.stub_chain(:user, :present?).and_return false
      provider_2.stub_chain(:user, :present?).and_return false
    end

    it 'generates a user for each provider in price_collection' do
      user_storage.should_receive(:create!).with(:name => 'João da Silva', :email => 'joao@silva.com', :login => 'joao.silva', :authenticable_id => 1, :authenticable_type => 'Provider')
      user_storage.should_receive(:create!).with(:name => 'Manoel Pereira', :email => 'manoel@pereira.com', :login => 'manoel.pereira', :authenticable_id => 2, :authenticable_type => 'Provider')

      subject.generate
    end
  end

  context 'the provider_1 has a user' do
    before do
      provider_1.stub_chain(:user, :present?).and_return true
      provider_2.stub_chain(:user, :present?).and_return false
    end

    it 'generates a user for each provider in price_collection' do
      user_storage.should_receive(:create!).with(:name => 'Manoel Pereira', :email => 'manoel@pereira.com', :login => 'manoel.pereira', :authenticable_id => 2, :authenticable_type => 'Provider')

      subject.generate
    end
  end
end