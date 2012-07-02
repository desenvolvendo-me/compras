class RegistrationCadastralCertificatesController < CrudController
  def index
    @parent = Creditor.find(params[:creditor_id])

    super
  end

  def new
    object = build_resource
    object.creditor = Creditor.find(params[:creditor_id])

    super
  end

  def create
    create!{ registration_cadastral_certificates_path(:creditor_id => resource.creditor_id) }
  end

  def update
    update!{ registration_cadastral_cerificates_path(:creditor_id => resource.creditor_id) }
  end

  def destroy
    destroy! do |success, failure|
      failure.html do
        redirect_to edit_resource_path
      end

      success.html do
        redirect_to registration_cadastral_certificates_path(:creditor_id => resource.creditor_id)
      end
    end
  end
end
