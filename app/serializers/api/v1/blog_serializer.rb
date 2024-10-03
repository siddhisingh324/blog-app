# app/serializers/api/v1/users/blog_serializer.rb

module Api
  module V1
    class BlogSerializer < ActiveModel::Serializer
      attributes :id, :user_id, :title, :description
    end
  end
end
