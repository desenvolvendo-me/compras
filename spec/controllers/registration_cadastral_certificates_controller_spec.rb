require 'spec_helper'

describe RegistrationCadastralCertificatesController do
  before do
    sign_in User.make!(:sobrinho_as_admin)
  end

  context 'with creditor' do
    let :creditor do
      Creditor.make!(:sobrinho)
    end

    describe 'POST #create' do
      it 'should redirect to registration_cadastral_certificates_path with creditor_id as param' do
        post :create, :registration_cadastral_certificate => { :creditor_id => creditor.id }

        response.redirect_url.should eq registration_cadastral_certificates_path(:creditor_id => creditor.id)
      end
    end

    describe 'PUT #update' do
      it 'should redirect to registration_cadastral_certificates_path with creditor_id as param' do
        crc = RegistrationCadastralCertificate.make!(:crc, :creditor => creditor)

        put :update, :id => crc.id

        response.should redirect_to(registration_cadastral_certificates_path(:creditor_id => creditor.id))
      end
    end

    describe 'DELETE #destroy' do
      it 'should redirect to registration_cadastral_certificates_path with creditor_id as param' do
        crc = RegistrationCadastralCertificate.make!(:crc, :creditor => creditor)

        delete :destroy, :id => crc.id

        response.should redirect_to(registration_cadastral_certificates_path(:creditor_id => creditor.id))
      end
    end
  end

  describe 'GET #show' do
    it 'should render report layout' do
      get :show

      response.should render_template("layouts/report")
    end
  end
end
