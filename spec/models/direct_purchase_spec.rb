# encoding: utf-8
require 'model_helper'
require 'lib/signable'
require 'lib/annullable'
require 'app/models/resource_annul'
require 'app/models/direct_purchase'
require 'app/models/budget_allocation'
require 'app/models/direct_purchase_budget_allocation'
require 'app/models/direct_purchase_budget_allocation_item'
require 'app/models/purchase_solicitation_item_group'
require 'app/models/supply_authorization'
require 'app/models/modality_limit'
require 'app/business/direct_purchase_modality_limit_verificator'
require 'app/models/purchase_solicitation_budget_allocation_item'

describe DirectPurchase do
  it 'should return direct_purchase/year as to_s method' do
    subject.direct_purchase = 1
    subject.year = 2012

    expect(subject.to_s).to eq '1/2012'
  end

  it { should belong_to :legal_reference }
  it { should belong_to :creditor }
  it { should belong_to :budget_structure }
  it { should belong_to :licitation_object }
  it { should belong_to :delivery_location }
  it { should belong_to :employee }
  it { should belong_to :payment_method }
  it { should belong_to :purchase_solicitation }
  it { should belong_to :purchase_solicitation_item_group }
  it { should belong_to :price_registration }

  it { should have_many(:items).through(:direct_purchase_budget_allocations) }
  it { should have_many(:direct_purchase_budget_allocations).dependent(:destroy).order(:id) }
  it { should have_many(:purchase_solicitation_budget_allocation_items) }

  it { should have_one(:supply_authorization).dependent(:restrict) }
  it { should have_one(:annul).dependent(:destroy) }

  it { should auto_increment(:direct_purchase).by(:year) }

  it { should validate_duplication_of(:budget_allocation_id).on(:direct_purchase_budget_allocations) }

  it 'should return 0 for licitation_exemption when no licitation object' do
    expect(subject.licitation_exemption).to eq 0
  end

  it 'should propagate licitation_exemption method to licitation object passing modality' do
    licitation_object = double
    subject.stub(:licitation_object).and_return(licitation_object)
    subject.stub(:modality).and_return(DirectPurchaseModality::MATERIAL_OR_SERVICE)

    licitation_object.should_receive(:licitation_exemption).with(DirectPurchaseModality::MATERIAL_OR_SERVICE)

    subject.licitation_exemption
  end

  it 'should delegate purchase_licitation_exemption to licitation object' do
    expect(subject.licitation_object_purchase_licitation_exemption).to eq nil

    subject.stub(:licitation_object).and_return(double(:purchase_licitation_exemption => 300.0))

    expect(subject.licitation_object_purchase_licitation_exemption).to eq 300.0
  end

  it 'should delegate build_licitation_exemption to licitation object' do
    expect(subject.licitation_object_build_licitation_exemption).to eq nil

    subject.stub(:licitation_object).and_return(double(:build_licitation_exemption => 200.0))

    expect(subject.licitation_object_build_licitation_exemption).to eq 200.0
  end

  it 'should delegate items from purchase_solicitation_item_groups' do
    expect(subject.purchase_solicitation_item_group_purchase_solicitation_item_ids).to eq nil

    subject.stub(:purchase_solicitation_item_group).and_return(double(:purchase_solicitation_item_group, :purchase_solicitation_item_ids => [1, 2]))

    expect(subject.purchase_solicitation_item_group_purchase_solicitation_item_ids).to eq [1, 2]
  end

  context "validations" do
    it "the duplicated budget_allocations should be invalid except the first" do
      allocation_one = subject.direct_purchase_budget_allocations.build(:budget_allocation_id => 1)
      allocation_two = subject.direct_purchase_budget_allocations.build(:budget_allocation_id => 1)

      subject.valid?

      allocation_one.errors.messages[:budget_allocation_id].should be_nil
      allocation_two.errors.messages[:budget_allocation_id].should include "já está em uso"
    end

    it "the diferent budget_allocations should be valid" do
      allocation_one = subject.direct_purchase_budget_allocations.build(:budget_allocation_id => 1)
      allocation_two = subject.direct_purchase_budget_allocations.build(:budget_allocation_id => 2)

      subject.valid?

      allocation_one.errors.messages[:budget_allocation_id].should be_nil
      allocation_two.errors.messages[:budget_allocation_id].should be_nil
    end

    context "budget structure validation" do
      it { should validate_presence_of :budget_structure }

      it "does not validate budget_structure if item group is present" do
        item_group = double(:item_group, :present? => true, :annulled? => false)
        subject.stub(:purchase_solicitation_item_group => item_group)

        should_not validate_presence_of :budget_structure
      end
    end

    it { should validate_presence_of :year }
    it { should validate_presence_of :date }
    it { should validate_presence_of :legal_reference }
    it { should validate_presence_of :modality }
    it { should validate_presence_of :licitation_object }
    it { should validate_presence_of :delivery_location }
    it { should validate_presence_of :creditor }
    it { should validate_presence_of :employee }
    it { should validate_presence_of :payment_method }
    it { should validate_presence_of :delivery_term }
    it { should validate_presence_of :delivery_term_period }
    it { should validate_presence_of :pledge_type }

    context '#authorized?' do
      it 'should return true when associated with supply_authorization' do
        subject.stub(:supply_authorization).and_return(double)
        expect(subject).to be_authorized
      end

      it 'should return false when not associated with supply_authorization' do
        subject.stub(:supply_authorization).and_return(nil)
        expect(subject).not_to be_authorized
      end
    end

    it 'should have at least one budget allocation' do
      expect(subject.direct_purchase_budget_allocations).to be_empty

      subject.valid?

      expect(subject.errors[:direct_purchase_budget_allocations]).to include 'é necessário cadastrar pelo menos uma dotação'
    end

    it 'should have error when limit verificator returns false' do
      subject.stub(:licitation_object).and_return(double(:to_s => 'objeto de licitacao'))
      subject.stub(:modality).and_return(double)

      DirectPurchaseModalityLimitVerificator.any_instance.stub(:value_less_than_available_limit?).and_return(false)
      DirectPurchaseModalityLimitVerificator.any_instance.stub(:current_limit).and_return(5)

      subject.valid?

      expect(subject.errors[:total_allocations_items_value]).to include "está acima do valor acumulado para este objeto (objeto de licitacao), está acima do limite permitido (5)"
    end

    it 'should not have error when limit verificator returns true' do
      subject.stub(:licitation_object).and_return(double)
      subject.stub(:modality).and_return(double)

      DirectPurchaseModalityLimitVerificator.any_instance.stub(:value_less_than_available_limit?).and_return(true)

      subject.valid?

      expect(subject.errors[:total_allocations_items_value]).to_not include 'está acima do valor disponível no limite em vigor para esta modalidade'
    end

    context "purchase_solicitations" do
      let(:purchase_solicitation) do
        double(:can_be_grouped? => true)
      end

      it "should not have a purchase solicitation AND a purchase solicitation item group" do
        subject.stub(:purchase_solicitation => purchase_solicitation)
        subject.stub(:purchase_solicitation_item_group => double(:annulled? => false))

        subject.valid?

        expect(subject.errors[:purchase_solicitation]).to include 'deve estar em branco se houver um Agrupamento de solicitações de compra selecionado'
      end

      it "should not have a purchase solicitation that can't generate direct purchases" do
        purchase_solicitation.stub(:can_be_grouped? => false)
        subject.stub(:purchase_solicitation_id_changed? => true)
        subject.stub(:purchase_solicitation => purchase_solicitation)

        subject.valid?

        expect(subject.errors[:purchase_solicitation]).to include 'não pode gerar compras diretas com a situação atual'
      end
    end
  end

  context 'total_direct_purchase_budget_allocations_sum' do
    before do
      subject.stub(:direct_purchase_budget_allocations).and_return(direct_purchase_budget_allocations)
    end

    let :direct_purchase_budget_allocations do
      [
        double('ItemOne', :total_items_value => 10),
        double('ItemTwo', :total_items_value => 1)
      ]
    end

    it 'should return sum of total_items_value' do
      subject.total_direct_purchase_budget_allocations_sum.should eq 11
    end
  end

  context 'with purchase_solicitation_item_group' do
    let :purchase_solicitation_item_group do
      double(:purchase_solcitation_item_group)
    end

    it 'should not allow purchase_solicitation_item_group annulled' do
      purchase_solicitation_item_group.stub(:annulled?).and_return(true)
      subject.stub(:purchase_solicitation_item_group).and_return(purchase_solicitation_item_group)

      subject.valid?
      expect(subject.errors[:purchase_solicitation_item_group]).to include(I18n.translate('errors.messages.is_annulled'))
    end

    it 'should allow purchase_solicitation_item_group not annulled' do
      purchase_solicitation_item_group.stub(:annulled?).and_return(false)
      subject.stub(:purchase_solicitation_item_group).and_return(purchase_solicitation_item_group)

      subject.valid?
      expect(subject.errors[:purchase_solicitation_item_group]).to_not include(I18n.translate('errors.messages.is_annulled'))
    end
  end

  context '#annul' do
    let :annul do
      double(:annul)
    end

    it 'should be annuled when annul is present' do
      subject.stub(:annul).and_return(annul)

      expect(subject.annulled?).to be true
    end

    it 'should not be annuled when annul is not present' do
      expect(subject.annulled?).to be false
    end
  end
end
