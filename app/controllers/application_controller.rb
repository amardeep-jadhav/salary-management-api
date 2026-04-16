class ApplicationController < ActionController::API
  include Pagy::Backend

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :bad_request

  private

  def not_found(e)
    render json: { error: e.message }, status: :not_found
  end

  def bad_request(e)
    render json: { error: e.message }, status: :bad_request
  end
end
