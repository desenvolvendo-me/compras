# This is a confirmation page to users generates from providers
# They need to creates a new password
# Check https://github.com/plataformatec/devise/wiki/How-To:-Two-Step-Confirmation/
class ConfirmationsController < Devise::ConfirmationsController
  def show
    self.resource = resource_class.find_by_confirmation_token(params[:confirmation_token])
    redirect_to root_path and return unless self.resource
    super if resource.confirmed?
  end

  def confirm
    self.resource = resource_class.find_by_confirmation_token(params[resource_name][:confirmation_token])
    if self.resource.update_attributes(params[resource_name])
      self.resource = resource_class.confirm_by_token(params[resource_name][:confirmation_token])
      set_flash_message :notice, :confirmed
      sign_in_and_redirect(resource_name, resource)
    else
      render :show
    end
  end
end
