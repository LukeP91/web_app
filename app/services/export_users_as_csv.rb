class ExportUsersAsCSV
  def self.export(users)
    CSV.generate { |csv| users.map{ |user| csv << user.user_data_for_csv } }
  end
end
