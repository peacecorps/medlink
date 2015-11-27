class NewUserForm < UserForm
  property :email
  property :country_id
  property :pcv_id

  validates :email, :country_id, :pcv_id, presence: true
  validate :unique_email

  def unique_email
    if User.where(email: email).any?
      errors.add :email, "is already taken"
    end
  end
end
