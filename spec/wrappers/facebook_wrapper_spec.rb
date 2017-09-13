require 'rails_helper'

describe FacebookWrapper do
  describe '#post_on_wall' do
    context 'when access token is valid' do
      it 'sends tweet to facebook' do
        organization = create(:organization, facebook_access_token: 'test')
        response = double('RequestResponse', ok?: true)
        allow(FacebookWrapper).to receive(:post).and_return(response)

        FacebookWrapper.new(organization).post_on_wall('message')

        expect(FacebookWrapper).to have_received(:post)
          .with('https://graph.facebook.com/v2.10/feed', query: { message: 'message', access_token: 'test' })
      end

      it 'returns :ok' do
        organization = create(:organization, facebook_access_token: 'test')
        response = double('RequestResponse', ok?: true)
        allow(FacebookWrapper).to receive(:post).and_return(response)

        expect(FacebookWrapper.new(organization).post_on_wall('message')).to eq :ok
      end
    end

    context 'when access token is invalid' do
      it 'returns :expired_token' do
        organization = create(:organization, facebook_access_token: 'test')
        response = double('RequestResponse', ok?: false)
        allow(FacebookWrapper).to receive(:post).and_return(response)

        expect(FacebookWrapper.new(organization).post_on_wall('message')).to eq :expired_token
      end
    end
  end
end
