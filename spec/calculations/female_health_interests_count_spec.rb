require 'rails_helper'

describe FemaleHealthInterestsCount do
  it 'counts only interests from health category' do
    organization = create(:organization)
    health_category = create(:category, name: 'health', organization: organization)
    work_category = create(:category, name: 'work', organization: organization)
    health_interest = create(:interest, category: health_category, organization: organization)
    work_interest = create(:interest, category: work_category, organization: organization)
    create(
      :user,
      :female,
      :between_20_and_30,
      organization: organization,
      interests: [health_interest, work_interest]
    )

    expect(FemaleHealthInterestsCount.result_for(organization: organization)).to eq 1
  end

  it 'counts only interests starting with cosm' do
    organization = create(:organization)
    health_category = create(:category, name: 'health', organization: organization)
    health_interest = create(:interest, category: health_category, organization: organization)
    without_cosm_prefix_interest = create(
      :interest,
      name: 'jogging',
      category: health_category,
      organization: organization
    )
    create(
      :user,
      :female,
      :between_20_and_30,
      organization: organization,
      interests: [health_interest, without_cosm_prefix_interest]
    )

    expect(FemaleHealthInterestsCount.result_for(organization: organization)).to eq 1
  end

  it 'counts only interests from people in the same organization' do
    organization = create(:organization)
    health_category = create(:category, name: 'health', organization: organization)
    health_interest = create(:interest, category: health_category, organization: organization)
    create(
      :user,
      :female,
      :between_20_and_30,
      organization: organization,
      interests: [health_interest]
    )
    create(:user, :female, :between_20_and_30, interests: [health_interest])
    expect(FemaleHealthInterestsCount.result_for(organization: organization)).to eq 1
  end

  it 'counts only interests from female users' do
    organization = create(:organization)
    health_category = create(:category, name: 'health', organization: organization)
    health_interest = create(:interest, category: health_category, organization: organization)
    create(:user, :female, :between_20_and_30, organization: organization, interests: [health_interest])
    create(:user, :male, :between_20_and_30, organization: organization, interests: [health_interest])

    expect(FemaleHealthInterestsCount.result_for(organization: organization)).to eq 1
  end

  it 'counts only interests for users with age between 20 and 30' do
    organization = create(:organization)
    health_category = create(:category, name: 'health', organization: organization)
    health_interest = create(:interest, category: health_category, organization: organization)
    create(:user, :female, age: 30, organization: organization, interests: [health_interest])
    create(:user, :female, age: 19, organization: organization, interests: [health_interest])
    create(:user, :female, age: 20, organization: organization, interests: [health_interest])
    create(:user, :female, age: 31, organization: organization, interests: [health_interest])

    expect(FemaleHealthInterestsCount.result_for(organization: organization)).to eq 2
  end
end
