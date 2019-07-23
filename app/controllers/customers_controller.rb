class CustomersController < ApplicationController
  def index
    @customers = Customer.limit(100)
  end

  def import
    CustomerImport.new(params[:file]).perform
    redirect_to customers_path, notice: "Data imported"
  end
end
