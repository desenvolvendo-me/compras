require 'spec_helper'

describe DirectPurchasesController do
  before do
    sign_in User.make!(:sobrinho_as_admin_and_employee)
  end

  it 'uses current employee as default value for employee' do
    get :new

    assigns(:direct_purchase).employee.should eq controller.current_user.employee
  end

  it 'show unauthorized as default value for status' do
    get :new

    assigns(:direct_purchase).status.should eq DirectPurchaseStatus::UNAUTHORIZED
  end

  describe 'POST create' do
    it 'should set unauthorized as status' do
      DirectPurchase.any_instance.should_receive(:status=).with(DirectPurchaseStatus::UNAUTHORIZED)

      post :create
    end
  end
end
