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

  def clean_csv
    file_data = File.join(Rails.root, 'app', 'csv', 'data_email_phuquoc.csv')
    if File.exist?(file_data)
      json_response({ message: 'file_data exist' }, :unprocessable_entity)
    else
      EmailCrawlerWorker.perform_async
      json_response({ message: 'ok' }, :ok)
    end
  end

end
