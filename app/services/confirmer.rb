class Confirmer
  def initialize token:
    @token = token
  end

  def run params
    return unless user.present?
    user.assign_attributes params if params.present?
    user.confirm if user.valid?
  end

  def user
    @_user ||= User.find_by_confirmation_token(@token)
  end
end
