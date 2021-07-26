require 'model_helper'
require 'lib/signable'
require 'app/models/persona/person'
require 'app/models/person'
require 'app/models/unico/cnae'
require 'app/models/unico/creditor_document'
require 'app/models/creditor_document'
require 'app/models/cnae'
require 'app/models/persona/creditor'
require 'app/models/creditor'
require 'app/models/unico/creditor_representative'
require 'app/models/unico/document_type'
require 'app/models/document_type'
require 'app/models/unico/creditor_secondary_cnae'
require 'app/models/creditor_secondary_cnae'
require 'app/models/creditor_material'
require 'app/models/unico/creditor_balance'
require 'app/models/unico/regularization_or_administrative_sanction'
require 'app/models/unico/registration_cadastral_certificate'
require 'app/models/bidder'
require 'app/models/licitation_process'
require 'app/models/licitation_process_ratification'
require 'app/models/purchase_process_accreditation_creditor'
require 'app/models/purchase_process_item'
require 'app/models/purchase_process_creditor_proposal'
require 'app/models/purchase_process_creditor_disqualification'
require 'app/models/realignment_price'
require 'app/models/creditor_representative'

describe Creditor do
  describe 'default values' do
    it 'uses false as default for municipal_public_administration' do
      expect(subject.municipal_public_administration).to be false
    end

    it 'uses false as default for autonomous' do
      expect(subject.autonomous).to be false
    end
  end

  it { should have_many(:representative_people).through(:representatives) }
  it { should have_many(:materials).through(:creditor_materials) }
  it { should have_many(:creditor_materials).dependent(:destroy) }
  it { should have_many(:bidders).dependent(:restrict) }
  it { should have_many(:licitation_processes).dependent(:restrict).through(:bidders) }
  it { should have_many(:purchase_process_accreditation_creditors).dependent(:restrict) }
  it { should have_many(:purchase_process_items).dependent(:restrict) }
  it { should have_many(:purchase_process_creditor_proposals).dependent(:restrict) }
  it { should have_many(:realignment_prices).dependent(:restrict) }
  it { should have_many(:proposal_disqualifications).dependent(:restrict) }
  it { should have_many(:licitation_process_ratifications).dependent(:restrict) }

  it { should have_and_belong_to_many :contracts }

  it { should validate_presence_of :person }
  it { should validate_duplication_of(:document_type_id).on(:documents) }

  it { should_not validate_presence_of :main_cnae }
  it { should_not validate_presence_of :contract_start_date }
  it { should_not validate_presence_of :social_identification_number }

  it { should delegate(:name).to(:person).allowing_nil(true) }
  it { should delegate(:personable_type_humanize).to(:person).allowing_nil(true) }
  it { should delegate(:company_partners).to(:person).allowing_nil(true) }
  it { should delegate(:individual?).to(:person).allowing_nil(true) }

  context 'when is company' do
    before do
      subject.stub(:company?).and_return(true)
    end

    it { should validate_presence_of :main_cnae }
  end

  context 'when is autonomous' do
    before do
      subject.stub(:autonomous?).and_return(true)
    end

    it { should validate_presence_of :contract_start_date }
    it { should validate_presence_of :social_identification_number }
  end

  context 'when is not autonomous' do
    before do
      subject.stub(:autonomous?).and_return(false)
    end

    it "contract_start_date should be nil" do
      subject.contract_start_date = Date.new(2012, 04, 05)

      subject.run_callbacks(:save)

      expect(subject.contract_start_date).to be nil
    end

    it "social_identification_number should be nil" do
      subject.social_identification_number = 12345

      subject.run_callbacks(:save)

      expect(subject.social_identification_number).to be nil
    end
  end

  describe 'cnaes' do
    it "should return selected_cnaes" do
      subject.stub(:cnae_ids).and_return( [1, 2, 3] )
      subject.main_cnae_id = 4
      expect(subject.selected_cnaes).to eq [1, 2, 3, 4]
    end

    let :main_cnae do
      double :main_cnae
    end

    it "should be invalid when has a secondary cnae equal a main cnae" do
      main_cnae.stub(:id).and_return(3)
      subject.stub(:main_cnae).and_return(main_cnae)
      subject.stub(:cnae_ids).and_return( [1, 2, 3] )

      subject.valid?

      expect(subject.errors.messages[:cnaes]).to include "não pode haver um CNAE secundário igual ao CNAE principal"
    end

    it "should be valid when has not a secondary cnae equal a main cnae" do
      main_cnae.stub(:id).and_return(4)
      subject.stub(:main_cnae).and_return(main_cnae)
      subject.stub(:cnae_ids).and_return( [1, 2, 3] )

      subject.valid?

      expect(subject.errors.messages[:cnaes]).to be_nil
    end
  end

  describe '#user?' do
    let :user do
      double('User', :persisted? => false, :present? => false)
    end

    before do
      subject.stub(:user).and_return user
    end

    it 'returns false when has not user' do
      expect(subject).not_to be_user
    end

    it 'returns true when has user and it is persisted' do
      user = double("User", :persisted? => true)

      subject.stub(:user).and_return(user)

      expect(subject).to be_user
    end

    it 'returns false when has user and it is not persisted' do
      user = double("User", :persisted? => false)

      subject.stub(:user).and_return(user)

      expect(subject).not_to be_user
    end
  end

  describe 'representatives' do
    let :person do
      double :person
    end

    it "should be invalid when has a representative equal a person" do
      person.stub(:id).and_return(1)
      person.stub(:company?).and_return(true)
      subject.stub(:person).and_return(person)
      subject.stub(:representative_person_ids).and_return( [1, 2, 3] )

      subject.valid?

      expect(subject.errors.messages[:representatives]).to include "não pode haver um representante igual ao credor"
    end

    it "should be valid when has not a representative equal a person" do
      person.stub(:id).and_return(4)
      person.stub(:company?).and_return(true)
      subject.stub(:person).and_return(person)
      subject.stub(:representative_person_ids).and_return( [1, 2, 3] )

      subject.valid?

      expect(subject.errors.messages[:representatives]).to be_nil
    end
  end

  describe '#proposal_by_item' do
    let(:item) { double(:item, id: 5) }
    let(:purchase_process_creditor_proposals) { double(:purchase_process_creditor_proposals) }

    it 'should return the proposal for a given item' do
      subject.stub(purchase_process_creditor_proposals: purchase_process_creditor_proposals)

      purchase_process_creditor_proposals.
        should_receive(:by_item_id).
        with(5).
        and_return(purchase_process_creditor_proposals)

      purchase_process_creditor_proposals.
        should_receive(:licitation_process_id).
        with(1).
        and_return(['proposal'])

      expect(subject.proposal_by_item(1, item)).to eq 'proposal'
    end
  end

  describe '#proposal_by_lot' do
    let(:purchase_process_creditor_proposals) { double(:purchase_process_creditor_proposals) }

    it 'should return the proposal for a given item' do
      subject.stub(purchase_process_creditor_proposals: purchase_process_creditor_proposals)

      purchase_process_creditor_proposals.
        should_receive(:licitation_process_id).
        with(1).
        and_return(purchase_process_creditor_proposals)

      purchase_process_creditor_proposals.
        should_receive(:by_lot).
        with(5).
        and_return(['proposal'])

      expect(subject.proposal_by_lot(1, 5)).to eq 'proposal'
    end
  end
end
