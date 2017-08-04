class UserPolicy < ApplicationPolicy
  def show?
    user.admin? && (user.organization_id == record.organization_id)
  end

  def index?
    user.admin?
  end

  def new?
    user.admin?
  end

  def create?
    user.admin?
  end

  def edit?
    user.admin? && (user.organization_id == record.organization_id)
  end

  def update?
    user.admin? && (user.organization_id == record.organization_id)
  end

  def destroy?
    user.admin? && (record.id != user.id)
  end

  def send_email?
    user.admin? && (user.organization_id == record.organization_id)
  end
end
