class EmailMarketingsController < ApiController
  def send_email
    from_line = params[:from_line].to_i
    to_line = params[:to_line].to_i
    if to_line > 0 && from_line < to_line
      PhuQuocMailingWorker.perform_async(from_line, to_line)
      json_response({ message: 'ok' }, :ok)
    else
      json_response({ message: 'params errors' }, :unprocessable_entity)
    end
  end
end
