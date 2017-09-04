class SourcePolicy < ApplicationPolicy
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
    user.admin? && (user.organization_id == record.organization_id)
  end
end
