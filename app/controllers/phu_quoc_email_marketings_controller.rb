class PhuQuocEmailMarketingsController < ApiController
  def send_email
    batch_size = params[:batch_size].to_i
    if batch_size > 0
      PhuQuocShophouseMailingWorker.perform_async(batch_size)
      json_response({ message: 'ok' }, :ok)
    else
      json_response({ message: 'batch_size errors' }, :unprocessable_entity)
    end
  end
end
