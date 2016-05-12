class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    country_admin?
  end

  def new?
    create?
  end

  def update?
    country_admin?
  end

  def edit?
    update?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  def admin?
    user.admin?
  end

  def country_pcmo?
    user.pcmo? && (user.country_id == country_id)
  end

  def country_admin?
    admin? || country_pcmo?
  end

  def country_id
    record.country_id
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.all
      elsif user.pcmo?
        scope.where(country_id: user.country_id)
      else
        scope.none
      end
    end
  end
end
