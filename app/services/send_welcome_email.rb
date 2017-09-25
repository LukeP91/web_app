class SendWelcomeEmail < Pattern::ServicePattern
  attr_reader :user

  def initialize(user)
    @user = user
  end

  private

  def call
    EmailAllUsersJob.perform_later(user.id)
  end
end
