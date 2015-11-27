class AdminEditUserForm < UserForm
  property :country_id
  property :pcv_id

  validates :country_id, :pcv_id, presence: true

  # TODO: disallow admins from demoting themselves
  def initialize user, editor:
    raise Pundit::NotAuthorizedError unless editor.admin?
    super
  end
end
