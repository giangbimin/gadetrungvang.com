class EmailMarketingsController < ApiController
  def send_email
    params[:plan_id]
    plan = MarketingPlan.find_by(id: params[:plan_id])
    file = File.join(Rails.root, 'public', 'csv', "#{params[:file_name]}.csv")
    if File.exist?(file) && plan
      EmailByCsvWorker.perform_async(file, plan)
    else
      json_response({ message: 'error params' }, :unprocessable_entity)
    end
  end

  def clean_csv
    file_data = File.join(Rails.root, 'public', 'csv', 'emails_verified.csv')
    if File.exist?(file_data)
      json_response({ message: 'file_data exist' }, :unprocessable_entity)
    else
      EmailCrawlerWorker.perform_async
      json_response({ message: 'ok' }, :ok)
    end
  end
end
