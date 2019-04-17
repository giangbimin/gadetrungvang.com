class EmailMarketingsController < ApiController
  def send_email
    part = params[:part].to_i
    part = 1 if part < 1
    part = 8 if part > 7
    from_line = (part - 1) * 10_000
    to_line = part * 10_000
    if to_line > 0
      PhuQuocMailingWorker.perform_async(from_line, to_line)
      json_response({ message: 'ok' }, :ok)
    else
      json_response({ message: 'params errors' }, :unprocessable_entity)
    end
  end
end
