class SendWelcomeEmail
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def call
    EmailAllUsersJob.perform_later(user.id)
  end
end
