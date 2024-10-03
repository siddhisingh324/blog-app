require 'rails_helper'

RSpec.describe Api::V1::BlogsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:blog) { create(:blog, user: user) }

  before do
    request.headers['Authorization'] = JsonWebToken.encode(user_id: user.id, exp: 7.days.from_now, user_type: 'User')
  end

  describe 'POST #create' do
    context 'when the request is valid' do
      it 'creates a new blog and returns a success response' do
        post :create, params: { blog: { title: Faker::Book.title, description: Faker::Lorem.paragraph } }

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)

        expect(json_response['success']).to be true
        expect(json_response['data']['title']).to be_present
      end
    end

    context 'when the request is invalid' do
      it 'returns an unprocessable entity response' do
        post :create, params: { blog: { title: '', description: '' } }

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to be_present
      end
    end
  end

  describe 'GET #index' do
    it 'returns a list of blogs' do
      create_list(:blog, 3, user: user)

      get :index

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)

      expect(json_response['success']).to be true
      expect(json_response['data']['blogs'].size).to eq(4) # 3 from create_list + 1 initial blog
    end
  end

  describe 'GET #show' do
    context 'when the blog exists' do
      it 'returns the blog' do
        get :show, params: { id: blog.id }

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)

        expect(json_response['success']).to be true
        expect(json_response['data']['blog']['id']).to eq(blog.id)
      end
    end

    context 'when the blog does not exist' do
      it 'returns an unprocessable entity response' do
        get :show, params: { id: 9999 } # Non-existing ID

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)

        expect(json_response['errors']).to include(I18n.t('blog.not_found'))
      end
    end
  end

  describe 'PUT #update' do
    context 'when the blog exists' do
      it 'updates the blog and returns success' do
        put :update, params: { id: blog.id, blog: { title: 'Updated Title' } }

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)

        expect(json_response['success']).to be true
        expect(json_response['data']['blog']['title']).to eq('Updated Title')
      end
    end

    context 'when the blog does not exist' do
      it 'returns an unprocessable entity response' do
        put :update, params: { id: 9999, blog: { title: 'Non-existent' } }

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)

        expect(json_response['errors']).to include(I18n.t('blog.not_found'))
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when the blog exists' do
      it 'deletes the blog and returns success' do
        delete :destroy, params: { id: blog.id }

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)

        expect(json_response['success']).to be true
        expect(json_response['data']['id']).to eq(blog.id)
      end
    end

    context 'when the blog does not exist' do
      it 'returns an unprocessable entity response' do
        delete :destroy, params: { id: 9999 } # Non-existing ID

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)

        expect(json_response['errors']).to include(I18n.t('blog.not_found'))
      end
    end
  end
end
