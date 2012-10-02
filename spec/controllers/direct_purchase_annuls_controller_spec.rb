require 'spec_helper'

describe DirectPurchaseAnnulsController do
  before do
    sign_in User.make!(:sobrinho_as_admin_and_employee)
  end

  context 'POST #create' do
    let :annullable do
      DirectPurchase.make!(:compra)
    end

    it 'should annul the direct_purchase' do
      DirectPurchaseAnnulment.any_instance.should_receive(:annul)
      ResourceAnnul.any_instance.should_receive(:annullable).at_least(:once).and_return(annullable)

      post :create, :annullable => annullable
    end
  end
end
