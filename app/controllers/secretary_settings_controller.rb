class SecretarySettingsController < CrudController

  def index
    @secretary_settings = Secretary.by_user(current_user.id)
  end

  def new
    @secretary_setting = SecretarySetting.build_secretary_settings params[:secretary]
  end

  def router
    id = SecretarySetting.was_persisted(params[:id])
    if id
      redirect_to edit_secretary_setting_path(id)
    else
      redirect_to new_secretary_setting_path(secretary: params[:id])
    end
  end

  def signature_generate
    digital_signature = Digest::MD5.hexdigest(params[:employee] + params[:secretary] + params[:signature])
    render json: {digital_signature: digital_signature}
  end

end