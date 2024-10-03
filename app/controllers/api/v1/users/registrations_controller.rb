#app/controllers/api/v1/users/registrations_controller.rb

module Api
  module V1
    module Users
      class RegistrationsController < Api::V1::ApiController
        skip_before_action :authenticate_request

        def create
          return render_unprocessable_entity(I18n.t('errors.field_empty', resource: 'User', field: 'email')) unless registration_params[:email].present?
          user = User.new(registration_params)
          if user.save
            render_success_response({
              registration: single_serializer.new(user, serializer: RegistrationSerializer)
            }.merge(jwt_token(user)), I18n.t('registration.success'))
          else
            render_unprocessable_entity_response(user)
          end
        end

        private

        def registration_params
          params.permit(:first_name, :last_name, :email, :password)
        end

        def jwt_token(user)
          { token: JsonWebToken.encode(user_id: user.id, exp: 24.hours.from_now, user_type: 'User') }
        end

        def decode_jwt_token(token)
          begin
            decoded_token = JWT.decode(token, nil, false)
            user_data = decoded_token[0]
            return user_data
          rescue JWT::DecodeError => e
            Rails.logger.error "JWT decoding error: #{e.message}"
            return nil
          end
        end
      end
    end
  end
end
