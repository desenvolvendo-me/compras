require 'unit_helper'
require 'enumerate_it'
require 'app/enumerations/authenticable_type'
require 'app/business/creditor_user_creator'

describe CreditorUserCreator do
  let :price_collection do
    double('Price Collection', :price_collection_proposals => price_collection_proposals)
  end

  let(:proposal1) { double('Proposal 1', :creditor => creditor_1) }
  let(:proposal2) { double('Proposal 2', :creditor => creditor_2) }

  let :price_collection_proposals do
    double(:price_collection_proposals, not_invited: [proposal1, proposal2])
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

  let(:context) do
    double(:context, :current_prefecture => 'Prefeitura', :current_customer => 'Customer')
  end

  subject do
    described_class.new(price_collection, context, :user_repository => user_repository,
                        :mailer => mailer)
  end

  context 'none of the users exists' do
    let(:creditor_params) do
      {
        'fresh-0' => {
          creditor_id: "1",
          _destroy: "false",
          email: "joao@silva.com"
        },

        'fresh-1' => {
          creditor_id: "2",
          _destroy: "false",
          email: "manoel@pereira.com"
        }
      }
    end

    before do
      creditor_1.stub(:user?).and_return false
      creditor_2.stub(:user?).and_return false
    end

    context 'when users have no errors' do
      it 'generates a user for each creditor in price_collection' do
        mailer.as_null_object

        subject.stub(creditor_params: creditor_params)

        creditor_1_info.merge!(:authenticable_id => 1,
                               :authenticable_type => AuthenticableType::CREDITOR)
        creditor_2_info.merge!(:authenticable_id => 2,
                               :authenticable_type => AuthenticableType::CREDITOR)

        user_repository.should_receive(:create).with(creditor_1_info).and_return(user_1)
        user_repository.should_receive(:create).with(creditor_2_info).and_return(user_2)

        user_1.should_receive(:persisted?).and_return(true)
        user_2.should_receive(:persisted?).and_return(true)

        mailer.should_receive(:invite_new_creditor).
               with(user_1, price_collection).
               and_return(double(:deliver => true))
        mailer.should_receive(:invite_new_creditor).
               with(user_2, price_collection).
               and_return(double(:deliver => true))

        proposal1.should_receive(:update_column).with(:email_invitation, true)
        proposal2.should_receive(:update_column).with(:email_invitation, true)

        expect(subject.generate).to be_true
      end
    end

    context 'when users have errors' do
      it 'should add an error to price_collection and return false' do
        mailer.as_null_object
        errors = double(:errors)

        subject.stub(creditor_params: creditor_params)

        creditor_1_info.merge!(:authenticable_id => 1,
                               :authenticable_type => AuthenticableType::CREDITOR)
        creditor_2_info.merge!(:authenticable_id => 2,
                               :authenticable_type => AuthenticableType::CREDITOR)

        user_repository.should_receive(:create).with(creditor_1_info).and_return(user_1)

        user_1.should_receive(:persisted?).and_return(false)

        mailer.should_not_receive(:invite_new_creditor)

        user_1.should_receive(:errors).and_return(['error'])

        price_collection.should_receive(:errors).and_return(errors)
        errors.should_receive(:add).with(:email, 'error')

        expect(subject.generate).to be_false
      end
    end
  end

  context 'the creditor_1 has a user' do
    let(:creditor_params) do
      {
        'fresh-0' => {
          creditor_id: "1",
          _destroy: "false",
          email: "joao@silva.com"
        },

        'fresh-1' => {
          creditor_id: "2",
          _destroy: "false",
          email: "manoel@pereira.com"
        }
      }
    end

    before do
      creditor_1.stub(:user?).and_return true
      creditor_1.stub(:user).and_return(user_1)
      creditor_2.stub(:user?).and_return false
    end

    it 'generates a user for each creditor in price_collection' do
      mailer.as_null_object

      subject.stub(creditor_params: creditor_params)

      creditor_1_info.merge!(:authenticable_id => 1,
                             :authenticable_type => AuthenticableType::CREDITOR)
      creditor_2_info.merge!(:authenticable_id => 2,
                             :authenticable_type => AuthenticableType::CREDITOR)

      user_repository.should_not_receive(:create).with(creditor_1_info)
      user_repository.should_receive(:create).with(creditor_2_info).and_return(user_2)

      user_2.should_receive(:persisted?).and_return(true)

      proposal1.should_receive(:update_column).with(:email_invitation, true)
      proposal2.should_receive(:update_column).with(:email_invitation, true)

      subject.generate
    end

    it 'send a email for users already registrated' do
      creditor_2_info.merge!(:authenticable_id => 2,
                             :authenticable_type => AuthenticableType::CREDITOR)

      subject.stub(creditor_params: creditor_params)

      user_repository.stub(:create).with(creditor_2_info).and_return(user_2)
      user_2.should_receive(:persisted?).and_return(true)

      mailer.should_receive(:invite_registered_creditor).
             with(creditor_1, price_collection, 'Prefeitura', 'Customer').and_return(double(:deliver => true))

      mailer.should_receive(:invite_new_creditor).
             with(user_2, price_collection).and_return(double(:deliver => true))

      proposal1.should_receive(:update_column).with(:email_invitation, true)
      proposal2.should_receive(:update_column).with(:email_invitation, true)

      subject.generate
    end
  end
end
