class RegistrationCadastralCertificatesController < CrudController
  def new
    object = build_resource
    object.creditor = Creditor.find(params[:creditor_id])

    super
  end

  def create
    create! { registration_cadastral_certificates_path(:creditor_id => resource.creditor_id) }
  end

  def update
    update! { registration_cadastral_cerificates_path(:creditor_id => resource.creditor_id) }
  end

  def destroy
    destroy! { registration_cadastral_certificates_path(:creditor_id => resource.creditor_id) }
  end

  def begin_of_association_chain
    if params[:creditor_id]
      @parent = Creditor.find(params[:creditor_id])
      return @parent
    end
  end
end
