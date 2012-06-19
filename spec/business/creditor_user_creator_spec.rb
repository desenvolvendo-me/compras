#encoding: utf-8
require 'unit_helper'
require './app/business/creditor_user_creator'

describe CreditorUserCreator do
  let :price_collection do
    double('Price Collection', :price_collection_proposals => price_collection_proposals)
  end

  let :price_collection_proposals do
    [
      double('Proposal 1', :creditor => creditor_1),
      double('Proposal 2', :creditor => creditor_2)
    ]
  end

  let :creditor_1 do
    double('Creditor 1', :id => 1, :name => 'João da Silva', :email => 'joao@silva.com', :login => 'joao.silva')
  end

  let :creditor_2 do
    double('Creditor 2', :id => 2, :name => 'Manoel Pereira', :email => 'manoel@pereira.com', :login => 'manoel.pereira')
  end

  let :user_storage do
    double('User Storage')
  end

  subject{ described_class.new(price_collection, 'Creditor', user_storage) }

  context 'none of the users exists' do
    before do
      creditor_1.stub_chain(:user, :present?).and_return false
      creditor_2.stub_chain(:user, :present?).and_return false
    end

    it 'generates a user for each creditor in price_collection' do
      user_storage.should_receive(:create!).with(:name => 'João da Silva', :email => 'joao@silva.com', :login => 'joao.silva', :authenticable_id => 1, :authenticable_type => 'Creditor')
      user_storage.should_receive(:create!).with(:name => 'Manoel Pereira', :email => 'manoel@pereira.com', :login => 'manoel.pereira', :authenticable_id => 2, :authenticable_type => 'Creditor')

      subject.generate
    end
  end

  context 'the creditor_1 has a user' do
    before do
      creditor_1.stub_chain(:user, :present?).and_return true
      creditor_2.stub_chain(:user, :present?).and_return false
    end

    it 'generates a user for each creditor in price_collection' do
      user_storage.should_receive(:create!).with(:name => 'Manoel Pereira', :email => 'manoel@pereira.com', :login => 'manoel.pereira', :authenticable_id => 2, :authenticable_type => 'Creditor')

      subject.generate
    end
  end
end
