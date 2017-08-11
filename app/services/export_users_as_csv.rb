class ExportUsersAsCSV
  def initialize(users)
    @users = users
  end

  def call
    CSV.generate { |csv| users.map { |user| csv << user.values_to_export } }
  end

  private

  attr_reader :users
end
