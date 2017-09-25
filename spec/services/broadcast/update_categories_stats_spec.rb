require 'rails_helper'

describe Broadcast::UpdateCategoriesStats do
  it 'broadcasts message about categories stats update via categories channel' do
    organization = create(:organization)
    health = create(:category, name: 'Health', organization: organization)
    cycling = create(:interest, name: 'Cycling', organization: organization, category: health)
    create(:user, interests: [cycling], organization: organization)
    allow(ActionCable.server).to receive(:broadcast)

    Broadcast::UpdateCategoriesStats.call(organization: organization)

    expect(ActionCable.server).to have_received(:broadcast).with(
      'categories',
      users_by_category: [
        { category: 'Health', count: 1 }
      ]
    )
  end
end
