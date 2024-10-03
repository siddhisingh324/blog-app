# app/controllers/api/v1/users/sessions_controller.rb

module Api
  module V1
    module Users
      class SessionsController < Api::V1::ApiController
        skip_before_action :authenticate_request

        def create
          auth = AuthenticateUser.call(auth_params[:email], auth_params[:password])
          if auth.success?
            render_success_response({ response: auth.result })
          else
            render_unprocessable_entity(auth.errors)
          end
        end

        private

        def auth_params
          params.permit(:email, :password)
        end
      end
    end
  end
end
