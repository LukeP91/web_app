class SendWelcomeEmail
  def initialize(user)
    @user = user
  end

  def call
    EmailAllJob.perform_later(user.id, user.organization_id)
  end

  private

  attr_reader :user
end
