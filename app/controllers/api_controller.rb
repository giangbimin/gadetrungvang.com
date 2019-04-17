# frozen_string_literal: true

class ApiController < ActionController::API
  rescue_from Rack::Timeout::RequestTimeoutException do
    render_error_response('server_timeout')
  end

  rescue_from ArgumentError do |error|
    render_error_response(error.message, :unprocessable_entity)
  end

  rescue_from StandardError do |error|
    render_error_response(error.message)
  end

  def json_response(object, status = :ok)
    render json: object, status: status
  end

  private

  def render_error_response(error, status = :internal_server_error)
    json_response({ message: error }, status)
  end
end
