require 'rails_helper'

RSpec.describe Interest, type: :model do
  context '.female_interests_count' do
    let(:organization) { create(:organization) }
    let(:health_category) { create(:category, name: 'health', organization: organization) }
    let(:health_interest) { create(:interest, category: health_category, organization: organization) }
    let(:alice) { create(:user, :female, :between_20_and_30, organization: organization) }

    it 'counts only interests from health category' do
      work_category = create(:category, name: 'work', organization: organization)
      work_interest = create(:interest, category: work_category, organization: organization)
      alice.interests = [health_interest, work_interest]

      expect(Interest.female_interests_count(organization)).to eq 1
    end

    it 'counts only interests starting with cosm' do
      without_cosm_prefix_interest = create(:interest, name: "jogging", category: health_category, organization: organization)
      alice.interests = [health_interest, without_cosm_prefix_interest]

      expect(Interest.female_interests_count(organization)).to eq 1
    end

    it 'counts only interests from people in the same organization' do
      diane = create(:user, :female, :between_20_and_30)
      alice.interests = [health_interest]
      diane.interests = [health_interest]

      expect(Interest.female_interests_count(organization)).to eq 1
    end

    it 'counts only interests from female users' do
      bob = create(:user, :male, :between_20_and_30, organization: organization)
      alice.interests = [health_interest]
      bob.interests = [health_interest]

      expect(Interest.female_interests_count(organization)).to eq 1
    end

    it 'counts only interests for users with age between 20 and 30' do
      diane = create(:user, :female, age: 19, organization: organization)
      jane = create(:user, :female, age: 25, organization: organization)
      megan = create(:user, :female, age: 31, organization: organization)
      alice.age = 30
      alice.save!
      diane.interests = [health_interest]
      alice.interests = [health_interest]
      jane.interests = [health_interest]
      megan.interests = [health_interest]

      expect(Interest.female_interests_count(organization)).to eq 2
    end
  end
end
