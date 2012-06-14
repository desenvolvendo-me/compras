require 'spec_helper'

describe DirectPurchasesController do
  before do
    sign_in User.make!(:sobrinho_as_admin_and_employee)
  end

  it 'uses current employee as default value for employee' do
    get :new

    assigns(:direct_purchase).employee.should eq controller.current_user.authenticable
  end

  it 'show unauthorized as default value for status' do
    get :new

    assigns(:direct_purchase).status.should eq DirectPurchaseStatus::UNAUTHORIZED
  end

  it 'show today as default value for date' do
    get :new

    assigns(:direct_purchase).date.should eq Date.current
  end

  describe 'POST create' do
    it 'should set unauthorized as status' do
      post :create

      assigns(:direct_purchase).status.should eq DirectPurchaseStatus::UNAUTHORIZED
    end
  end

  context 'next direct purchase' do
    let :direct_purchase do
      DirectPurchase.make!(:compra)
    end

    it 'should assign the direct purchase' do
      DirectPurchase.any_instance.stub(:next_purchase).and_return(2)

      post :create

      assigns(:direct_purchase).direct_purchase.should eq 2
    end
  end
end
