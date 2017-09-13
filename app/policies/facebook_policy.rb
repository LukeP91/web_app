class FacebookPolicy < Struct.new(:user, :facebook)
  def show?
    user.admin?
  end

  def callback?
    user.admin?
  end
end
