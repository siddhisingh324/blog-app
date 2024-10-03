# app/controllers/api/v1/api_controller.rb

class Api::V1::ApiController < ActionController::API
  include Pagination
  include ApplicationMethods
  attr_reader :current_user

  def per_page
    params[:per_page] || 10
  end

  def page
    params[:page] || 1
  end

  private

  def authenticate_request
    auth = AuthorizeApiRequest.call(request.headers)
    @current_user = auth.result
    render_unauthorized_response(auth.errors) and return unless @current_user
  end

  def sort_by
    params[:sort] ? params[:sort] : 'asc'
  end
end
