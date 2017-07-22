class ExportUsersAsCSV
  def self.export(users)
    CSV.generate { |csv| users.map { |user| csv << user.values_to_export } }
  end
end
