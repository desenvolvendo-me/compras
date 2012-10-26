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

      expect(subject.edit_parent_path).to eq [:edit, annullable]
    end
  end

  describe 'GET #new' do
    it "should return 401 if parent is already annulled" do
      pending 'Waiting solution for rails update' do
        resource_annul = ResourceAnnul.make!(:rescisao_de_contrato_anulada)

        subject.stub(:controller_name => 'contract_termination_annuls')
        subject.should_receive(:validate_parent!).
          with(instance_of(ResourceAnnul)).
          and_raise(Exceptions::Unauthorized)

        get :new, :annullable_id => resource_annul.annullable_id

        expect(response.code).to eq '401'
      end
    end
  end

  describe 'POST #create' do
    it "should return 401 if parent is already annulled" do
      pending 'Waiting solution for rails update' do
        resource_annul = ResourceAnnul.make!(:rescisao_de_contrato_anulada)

        subject.should_receive(:validate_parent!).
          with(instance_of(ResourceAnnul)).
          and_raise(Exceptions::Unauthorized)

        post :create, :resource_annul => resource_annul.attributes

        expect(response.code).to eq '401'
      end
    end
  end
end
