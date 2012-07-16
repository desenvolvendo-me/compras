# encoding: utf-8
require 'spec_helper'

describe ResourceAnnulsController do
  before do
    sign_in User.make!(:sobrinho_as_admin_and_employee)
  end

  context "with annullable" do
    let :annullable do
      ContractTermination.make!(:contrato_rescindido)
    end

    let :resource do
      double(:resource)
    end

    it "should show have the edit parent url" do
      subject.stub(:annullable_id => annullable.id)
      subject.stub(:resource => resource)

      resource.stub(:annullable => annullable)

      subject.edit_parent_path.should eq [:edit, annullable]
    end
  end

  describe 'GET #new' do
    it "should return 401 if parent is already annulled" do
      resource_annul = ResourceAnnul.make!(:rescisao_de_contrato_anulada)

      subject.stub(:controller_name => 'contract_termination_annuls')
      subject.should_receive(:validate_parent!).
              with(instance_of(ResourceAnnul)).
              and_raise(Exceptions::Unauthorized)

      get :new, :annullable_id => resource_annul.annullable_id

      response.code.should eq '401'
    end
  end

  describe 'POST #create' do
    it "should redirect to edit parent path after create" do
      pledge_liquidation = PledgeLiquidation.make!(:empenho_2012)

      subject.should_receive(:annul)
      subject.stub(:controller_name => 'pledge_liquidation_annuls')

      post :create, :resource_annul => { :annullable_id => pledge_liquidation.id, :annullable_type => 'PledgeLiquidation' }

      response.should be_success
      response.location.should match '/pledge_liquidations/1/edit'
    end

    it "should return 401 if parent is already annulled" do
      resource_annul = ResourceAnnul.make!(:rescisao_de_contrato_anulada)

      subject.should_receive(:validate_parent!).
              with(instance_of(ResourceAnnul)).
              and_raise(Exceptions::Unauthorized)

      post :create, :resource_annul => resource_annul.attributes

      response.code.should eq '401'
    end
  end

  it "should return annullable_id from params at annulable_id method" do
    pledge_liquidation = PledgeLiquidation.make!(:empenho_2012)

    subject.stub(:controller_name => 'pledge_liquidation_annuls')
    subject.should_receive(:annullable_id).twice.and_return(pledge_liquidation.id)

    get :new, :annulable_id => pledge_liquidation.id
  end

  it "should return the parent model name at parent_model_name method" do
    pledge_liquidation = PledgeLiquidation.make!(:empenho_2012)

    subject.stub(:controller_name => 'pledge_liquidation_annuls')
    subject.parent_model_name.should eq 'pledge_liquidation'
  end
end
