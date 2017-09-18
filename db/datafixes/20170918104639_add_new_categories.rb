class Datafixes::AddNewCategories < Datafix
  def self.up
    organization = Organization.find_by(name: 'Google')
    Category.find_or_create_by(name: 'school', organization: organization)
    Category.find_or_create_by(name: 'travel', organization: organization)
    Category.find_or_create_by(name: 'people', organization: organization)
    Category.find_or_create_by(name: 'living', organization: organization)
    Category.find_or_create_by(name: 'nonprofit', organization: organization)
  end
end
