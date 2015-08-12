class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    admin? || country_pcmo?
  end

  def new?
    create?
  end

  def update?
    admin? || country_pcmo?
  end

  def edit?
    update?
  end

  def destroy?
    user.admin?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  def admin?
    user.admin?
  end

  def inactive?
    user.inactive?
  end

  def country_pcmo?
    user.pcmo? && (user.country_id == record.country_id)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope
      elsif user.pcmo?
        scope.where(country_id: user.country_id)
      else
        scope.where(user_id: user.id)
      end
    end
  end
end
