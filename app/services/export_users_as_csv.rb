class ExportUsersAsCSV < Pattern::ServicePattern
  def initialize(users)
    @users = users
  end

  private

  def call
    CSV.generate { |csv| users.map { |user| csv << user.values_to_export } }
  end

  attr_reader :users
end
