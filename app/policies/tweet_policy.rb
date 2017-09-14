class TweetPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def send_to_facebook?
    user.admin? && (user.organization_id == record.organization_id)
  end
end
