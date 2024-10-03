module Api
  module V1
    module Users
      class RegistrationSerializer < ActiveModel::Serializer
        attributes :id, :email, :first_name, :last_name, :password
      end
    end
  end
end
