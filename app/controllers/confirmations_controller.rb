class ConfirmationsController < Devise::ConfirmationsController
  def show
    @original_token = params[:confirmation_token]
    self.resource = resource_class.find_by_confirmation_token @original_token
    super if resource.nil? or resource.confirmed?
  end

  def confirm
    @original_token = params[:user].try(:[], :confirmation_token)
    confirmer = Confirmer.new token: @original_token

    if confirmer.run permitted_params
      set_flash_message :notice, :confirmed
      sign_in_and_redirect :user, confirmer.user
    else
      self.resource = confirmer.user
      render action: :show
    end
  end

  private

  def permitted_params
    params.require(resource_name).permit(:confirmation_token, :password, :password_confirmation)
  end
end
