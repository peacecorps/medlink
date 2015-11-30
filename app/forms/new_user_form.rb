class NewUserForm < UserForm
  property :email

  validates :email, presence: true
  validate :unique_email

  def unique_email
    if User.where(email: email).any?
      errors.add :email, "is already taken"
    end
  end
end
