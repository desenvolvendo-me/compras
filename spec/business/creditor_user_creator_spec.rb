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

  let :creditor_1_info do
    { :name => 'João da Silva', :email => 'joao@silva.com', :login => 'joao.silva' }
  end

  let :creditor_2_info do
    { :name => 'Manoel Pereira', :email => 'manoel@pereira.com', :login => 'manoel.pereira' }
  end

  let :creditor_1 do
    double('Creditor 1', creditor_1_info.merge(:id => 1))
  end

  let :creditor_2 do
    double('Creditor 2', creditor_2_info.merge(:id => 2))
  end

  let :user_1 do
    double('User 1')
  end

  let :user_2 do
    double('User 2')
  end

  let :user_repository do
    double('User Storage')
  end

  let :mailer do
    double('Creditor User Creator Mailer')
  end

  subject{ described_class.new(price_collection, 'Creditor', user_repository, mailer) }

  context 'none of the users exists' do
    before do
      creditor_1.stub(:user?).and_return false
      creditor_2.stub(:user?).and_return false
    end

    it 'generates a user for each creditor in price_collection' do
      mailer.as_null_object

      user_repository.should_receive(:create!).with(creditor_1_info.merge(:authenticable_id => 1, :authenticable_type => 'Creditor'))
      user_repository.should_receive(:create!).with(creditor_2_info.merge(:authenticable_id => 2, :authenticable_type => 'Creditor'))

      subject.generate
    end

    it 'sends an email for each generated user' do
      user_repository.stub(:create!).and_return(user_1, user_2)

      mailer.should_receive(:price_collection_invite).with(user_1, price_collection).and_return(stub(:deliver => true))
      mailer.should_receive(:price_collection_invite).with(user_2, price_collection).and_return(stub(:deliver => true))

      subject.generate
    end
  end

  context 'the creditor_1 has a user' do
    before do
      creditor_1.stub(:user?).and_return true
      creditor_2.stub(:user?).and_return false
    end

    it 'generates a user for each creditor in price_collection' do
      mailer.as_null_object

      user_repository.should_not_receive(:create!).with(creditor_1_info.merge(:authenticable_id => 1, :authenticable_type => 'Creditor'))
      user_repository.should_receive(:create!).with(creditor_2_info.merge(:authenticable_id => 2, :authenticable_type => 'Creditor'))

      subject.generate
    end

    it 'sends an email for generated user only' do
      user_repository.stub(:create!).with(creditor_2_info.merge(:authenticable_id => 2, :authenticable_type => 'Creditor')).and_return(user_2)

      mailer.should_not_receive(:price_collection_invite).with(user_1, price_collection)
      mailer.should_receive(:price_collection_invite).with(user_2, price_collection).and_return(stub(:deliver => true))

      subject.generate
    end
  end
end
