require "rails_helper"
require Rails.root.join("db", "datafixes", "20170922152836_unify_categories")

describe Datafixes::UnifyCategories do
  describe ".up" do
    it 'removes duplicated categories and assign interests to one of them' do
      organization = create(:organization)
      create(:category, name: 'health', organization: organization)
      category = create(:category, name: 'work', organization: organization)
      duplicated_category = create(:category, name: 'work', organization: organization)
      create(:interest, category: category, organization: organization)
      create(:interest, category: duplicated_category, organization: organization)

      Datafixes::UnifyCategories.up

      expect(Category.count).to eq 2
      expect(category.reload.interests.count).to eq 2
    end

    it 'does not remove categories outside organization' do
      category = create(:category, name: 'work')
      duplicated_category = create(:category, name: 'work')
      create(:interest, category: category, organization: category.organization)
      create(:interest, category: duplicated_category, organization: duplicated_category.organization)

      expect(Category.count).to eq 2
      expect(Category.first.interests.count).to eq 1
    end
  end
end
