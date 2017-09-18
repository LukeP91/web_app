require 'rails_helper'
require Rails.root.join('db', 'datafixes', '20170918104639_add_new_categories')

describe Datafixes::AddNewCategories do
  describe '.up' do
    it 'adds new categories' do
      organization = create(:organization, name: 'Google')
      expect do
        Datafixes::AddNewCategories.up
      end.to change { Category.count }.by(5)
      expect(Category.where(organization: organization).pluck(:name)).to eq %w[school travel people living nonprofit]
    end

    it 'does not duplicate already existing category with given name' do
      organization = create(:organization, name: 'Google')
      create(:category, name: 'school', organization: organization)
      create(:category, name: 'travel', organization: organization)
      create(:category, name: 'people', organization: organization)
      create(:category, name: 'living', organization: organization)

      expect do
        Datafixes::AddNewCategories.up
      end.to change { Category.count }.by(1)
      expect(Category.where(organization: organization).pluck(:name)).to eq %w[school travel people living nonprofit]
    end
  end
end
