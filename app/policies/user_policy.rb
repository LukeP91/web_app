class UserPolicy < ApplicationPolicy
  def show?
    user.admin?
  end

  def index?
    user.admin?
  end

  def edit?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end
end
