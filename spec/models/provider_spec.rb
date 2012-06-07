# encoding: utf-8
require 'model_helper'
require 'app/models/provider'
require 'app/models/provider_partner'
require 'app/models/provider_licitation_document'
require 'app/models/licitation_process_bidder'
require 'app/models/direct_purchase'
require 'app/models/person'
require 'app/models/company'
require 'app/models/individual'
require 'app/models/licitation_process_bidder'
require 'app/models/pledge'
require 'app/models/reserve_fund'
require 'app/models/precatory'
require 'app/models/price_collections_provider'
require 'app/models/price_collection_proposal'

describe Provider do
  it { should belong_to :person }
  it { should belong_to :agency }
  it { should belong_to :legal_nature }
  it { should belong_to :cnae }
  it { should belong_to :economic_registration }
  it { should have_and_belong_to_many :materials_groups }
  it { should have_and_belong_to_many :materials_classes }
  it { should have_and_belong_to_many :materials }

  it { should have_many(:provider_partners).dependent(:destroy).order(:id) }
  it { should have_many(:provider_licitation_documents).dependent(:destroy).order(:id) }
  it { should have_many(:direct_purchases).dependent(:restrict) }
  it { should have_many(:licitation_process_bidders).dependent(:restrict) }
  it { should have_many(:licitation_processes).dependent(:restrict).through(:licitation_process_bidders) }
  it { should have_many(:pledges).dependent(:restrict) }
  it { should have_many(:reserve_funds).dependent(:restrict) }
  it { should have_many(:precatories).dependent(:restrict) }
  it { should have_many(:price_collection_proposals).dependent(:restrict).order(:id) }
  it { should have_many(:price_collections).through(:price_collection_proposals) }

  it { should validate_presence_of :person }
  it { should validate_presence_of :registration_date }
  it { should validate_presence_of :agency }
  it { should validate_presence_of :bank_account }
  it { should validate_presence_of :legal_nature }
  it { should validate_presence_of :cnae }

  it 'should return person as to_s method' do
    subject.stub(:person => double(:to_s => 'Fulano'))

    subject.to_s.should eq 'Fulano'
  end

  it "should have partners with the same individual invalid except the first" do
    partner_one = subject.provider_partners.build(:individual_id => 1)
    partner_two = subject.provider_partners.build(:individual_id => 1)

    subject.valid?

    partner_one.errors.messages[:individual_id].should be_nil
    partner_two.errors.messages[:individual_id].should include "já está em uso"
  end

  it "should have partners with different individual valid" do
    partner_one = subject.provider_partners.build(:individual_id => 1)
    partner_two = subject.provider_partners.build(:individual_id => 2)

    subject.valid?

    partner_one.errors.messages[:individual_id].should be_nil
    partner_two.errors.messages[:individual_id].should be_nil
  end

  it 'should have at least one partner when person is Company' do
    subject.stub(:company? => true)

    subject.valid?

    subject.errors[:provider_partners].should include 'Pessoa jurídica selecionada na aba Principal. É necessário cadastrar pelo menos um sócio/responsável'
  end

  it 'should clean extra partners when is not company' do
    partner1 = double('partner', :individual_id => 1)
    partner2 = double('partner', :individual_id => 2)
    subject.stub(:provider_partners => [partner1, partner2])
    subject.stub(:valid? => true)

    subject.stub(:company? => false)

    partner1.should_receive(:destroy)
    partner2.should_receive(:destroy)

    subject.run_callbacks(:save)

    subject.stub(:company? => true)

    partner1.should_receive(:destroy).never
    partner2.should_receive(:destroy).never

    subject.run_callbacks(:save)
  end

  describe '#email' do
    context 'when has no user related to this provider' do
      it "returns the person's email" do
        subject.stub(:person).and_return double('Person', :email => 'joao@silva.com')

        subject.email.should eq 'joao@silva.com'
      end
    end

    context 'when has a user related to this provider' do
      it "returns the user's email" do
        subject.stub(:user).and_return double('User', :email => 'foo@bar.com')

        subject.email.should eq 'foo@bar.com'
      end
    end
  end

  describe '#email=' do
    let :person do
      double('Person')
    end

    it 'sets the email on person' do
      subject.stub(:person).and_return person

      person.should_receive(:email=).with('foo@bar.com')
      subject.email = 'foo@bar.com'
    end
  end

  describe '#login=' do
    context 'have no user related to this provider' do
      it 'sets the login to the given string' do
        subject.login = 'foo.bar'
        subject.login.should eq 'foo.bar'
      end
    end

    context 'have a user related to this provider' do
      it "should not override the user's login" do
        subject.stub(:user).and_return double('User', :login => 'foo.bar')

        subject.login = 'joao.silva'
        subject.login.should eq 'foo.bar'
      end
    end
  end

  describe '#login' do
    context 'have no user related to this provider' do
      it 'returns the given login' do
        subject.login = 'foo.bar'

        subject.login.should eq 'foo.bar'
      end
    end

    context 'have a user related to this provider' do
      it "returns the user's login" do
        subject.stub(:user).and_return double('User', :login => 'foo.bar')

        subject.login.should eq 'foo.bar'
      end
    end
  end
end
