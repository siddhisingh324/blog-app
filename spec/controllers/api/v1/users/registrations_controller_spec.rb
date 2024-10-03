# spec/controllers/api/v1/users/registrations_controller_spec.rb

require 'rails_helper'

RSpec.describe Api::V1::Users::RegistrationsController, type: :controller do
  describe 'POST #create' do
    context 'when email is missing' do
      it 'returns an unprocessable entity response' do
        post :create, params: { first_name: 'John', last_name: 'Doe', password: 'password123' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('email')
      end
    end

    context 'when registration is valid' do
      let(:valid_attributes) do
        {
          first_name: 'John',
          last_name: 'Doe',
          email: 'john.doe@example.com',
          password: 'password123'
        }
      end

      it 'creates a new user and returns a success response' do
        post :create, params: valid_attributes

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)

        expect(json_response['data']['registration']).to be_present
        expect(json_response['data']['token']).to be_present
        expect(json_response['data']['registration']['email']).to eq('john.doe@example.com')
      end
    end

    context 'when registration is invalid' do
      it 'returns an unprocessable entity response' do
        post :create, params: { first_name: 'Jane', last_name: 'Doe', email: 'invalid_email', password: '' }

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to be_present
      end
    end
  end
end
