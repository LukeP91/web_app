require 'rails_helper'

describe ProfilesController do
  include Devise::Test::ControllerHelpers

  describe '#update' do
    context 'when profile is updated' do
      it 'calls service object to broadcast categories stats update' do
        allow(Broadcast::UpdateCategoriesStats).to receive(:call)
        user = create(:user)
        sign_in user

        post :update, params: {
          user: {
            email: 'example@example.com',
            first_name: 'Example',
            last_name: 'Example',
            age: 25
          }
        }

        expect(Broadcast::UpdateCategoriesStats).to have_received(:call).with(organization: user.organization)
      end
    end
  end
end
