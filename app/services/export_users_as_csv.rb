class ExportUsersAsCSV
  def self.export(users)
    CSV.generate do |csv|
      users.map{ |user| csv << user.user_data_for_csv }
    end
  end
end
