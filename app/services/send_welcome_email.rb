class SendWelcomeEmail
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def call
    user_ids = User.in_organization(Organization.find(user.organization_id)).pluck(:id)
    EmailAllUsersJob.perform_later(user.id, user_ids)
  end
end
