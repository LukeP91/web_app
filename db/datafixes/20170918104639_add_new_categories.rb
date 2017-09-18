class Datafixes::AddNewCategories < Datafix
  def self.up
    organization = Organization.find_by(name: 'Google')
    %w[school travel people living nonprofit].each do |category_name|
      Category.find_or_create_by(name: category_name, organization: organization)
    end
  end
end
