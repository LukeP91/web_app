require 'rails_helper'

describe UsersByAge do
  describe '.result_for' do
    it 'returns sorted array of age ranges with users count withing organization' do
      organization = create(:organization)
      create(:user, age: 77, organization: organization)
      create(:user, age: 6, organization: organization)
      create(:user, age: 6, organization: organization)
      create(:user, age: 15, organization: organization)
      create(:user, age: 51, organization: organization)
      create(:user, age: 55, organization: organization)
      create(:user, age: nil, organization: organization)
      create(:user, age: 25)

      expect(UsersByAge.result_for(organization: organization)).to eq(
        [
          { range: 'Child: <0-10)', count: 2 },
          { range: 'Teen: <10-18)', count: 1 },
          { range: 'Adult: <18-65)', count: 2 },
          { range: 'Elderly: <65-100)', count: 1 }
        ]
      )
    end
  end
end
