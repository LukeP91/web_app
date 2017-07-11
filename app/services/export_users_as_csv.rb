class ExportUsersAsCSV
  def self.export(users)
    CSV.generate { |csv| users.map{ |user| csv << user.csv_format } }
  end
end
