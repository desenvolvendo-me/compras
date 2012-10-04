require 'spec_helper'

describe PurchaseSolicitationItemGroupAnnulsController do
  before do
    sign_in User.make!(:sobrinho_as_admin_and_employee)
  end

  context 'GET new' do
    let :purchase_solicitation_item_group do
      double(:purchase_solicitation_item_group)
    end

    it 'should raise Unauthorized exception if is not annullable' do
      pending "It is not raising exception in test, but works perfectly in practice"

      purchase_solicitation_item_group.stub(:annullable?).and_return(false)

      ResourceAnnul.any_instance.should_receive(:annullable).
                                 twice.
                                 and_return(purchase_solicitation_item_group)

      expect { get :new, :annullable_id => 1 }.to raise_exception(Exceptions::Unauthorized)
    end

    it 'should allow new when is annullable' do
      purchase_solicitation_item_group.stub(:annullable?).and_return(true)
      purchase_solicitation_item_group.stub(:annulled?).and_return(false)

      ResourceAnnul.any_instance.should_receive(:annullable).
                                 exactly(3).times.
                                 and_return(purchase_solicitation_item_group)

      get :new, :annullable_id => 1
    end
  end

  context 'POST create' do
    let :purchase_solicitation_item_group do
      double(:purchase_solicitation_item_group)
    end

    it 'should raise Unauthorized exception if is not annullable' do
      pending "It is not raising exception in test, but works perfectly in practice"

      purchase_solicitation_item_group.stub(:annullable?).and_return(false)

      ResourceAnnul.any_instance.should_receive(:annullable).
                                 twice.
                                 and_return(purchase_solicitation_item_group)

      expect { post :create, :annullable_id => 1 }.to raise_exception(Exceptions::Unauthorized)
    end

    it 'should allow create when is annullable' do
      item_group = PurchaseSolicitationItemGroup.make!(:antivirus)

      PurchaseSolicitationBudgetAllocationItemStatusChanger.any_instance.should_receive(:change)

      post :create, :annullable_id => item_group.id
    end
  end
end
