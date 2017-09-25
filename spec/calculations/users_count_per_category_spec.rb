require 'rails_helper'

describe UsersCountPerCategory do
  it 'returns users count for each category' do
    organization = create(:organization)
    health = create(:category, name: 'Health', organization: organization)
    work = create(:category, name: 'Work', organization: organization)
    running = create(:interest, name: 'Running', organization: organization, category: health)
    cooking = create(:interest, name: 'Cooking', organization: organization, category: health)
    speaking = create(:interest, name: 'Public speaking', organization: organization, category: work)
    create(:user, organization: organization, interests: [running, cooking, speaking])
    create(:user, organization: organization, interests: [running])
    create(:user, organization: organization, interests: [cooking, speaking])
    create(:user, organization: organization, interests: [running, speaking])

    expect(UsersCountPerCategory.result_for(organization: organization)).to eq(
      [
        { category: 'Health', count: 5 },
        { category: 'Work', count: 3 }
      ]
    )
  end

  it 'takes only categories from given organization' do
    organization = create(:organization)
    health = create(:category, name: 'Health', organization: organization)
    work = create(:category, name: 'Work')
    running = create(:interest, name: 'Running', organization: organization, category: health)
    speaking = create(:interest, name: 'Public speaking', category: work)
    create(:user, organization: organization, interests: [running])
    create(:user, organization: organization, interests: [speaking])

    expect(UsersCountPerCategory.result_for(organization: organization)).to eq(
      [
        { category: 'Health', count: 1 }
      ]
    )
  end
end
