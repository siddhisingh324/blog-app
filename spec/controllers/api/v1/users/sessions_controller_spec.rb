# spec/controllers/api/v1/users/sessions_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::Users::SessionsController, type: :controller do
  EMAIL = 'john.doe@example.com'
  PASSWORD = 'password123'

  describe 'POST #create' do
    let!(:user) { create(:user, email: EMAIL, password: PASSWORD) }

    context 'when credentials are valid' do
      it 'returns a success response with user data' do
        post :create, params: { email: EMAIL, password: PASSWORD }

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)

        expect(json_response['success']).to be true
        expect(json_response['data']['response']).to be_present
        expect(json_response['data']['response']['token']).to be_present
      end
    end

    context 'when credentials are invalid' do
      it 'returns an unprocessable entity response' do
        post :create, params: { email: EMAIL, password: 'wrongpassword' }

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to be_present
      end
    end

    context 'when email is missing' do
      it 'returns an unprocessable entity response' do
        post :create, params: { password: PASSWORD }

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include(
          { 'user_authentication' => "Email id is not registered please signup first." }
        )
      end
    end

    context 'when password is missing' do
      it 'returns an unprocessable entity response' do
        post :create, params: { email: EMAIL }

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include(
          { 'user_authentication' => "Email address or password does not match." }
        )
      end
    end
  end
end
