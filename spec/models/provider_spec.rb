# encoding: utf-8
require 'model_helper'
require 'app/models/provider'
require 'app/models/provider_partner'
require 'app/models/provider_licitation_document'
require 'app/models/licitation_process_invited_bidder'
require 'app/models/direct_purchase'
require 'app/models/person'
require 'app/models/company'
require 'app/models/individual'

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
  it { should have_many(:licitation_process_invited_bidders).dependent(:restrict) }

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

    subject.save

    subject.stub(:company? => true)

    partner1.should_receive(:destroy).never
    partner2.should_receive(:destroy).never

    subject.save
  end
end
