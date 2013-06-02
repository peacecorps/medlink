class RegistrationsController < Devise::RegistrationsController
  def update
    if current_user.valid_password? params['user']['current_password']
      current_user.update_attribute(:country_id, params['user']['country_id'])
    end
    super
  end
end
