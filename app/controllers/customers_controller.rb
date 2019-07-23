class CustomersController < ApplicationController
  def index
    @customers = Customer.limit(100)
  end

  def import
    Customer.import_file params[:file]
    redirect_to customers_path, notice: "Data imported"
  end
end
