class MerchantBulkDiscountsController < ApplicationController
  def index 
    # binding.pry
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    
  end
end