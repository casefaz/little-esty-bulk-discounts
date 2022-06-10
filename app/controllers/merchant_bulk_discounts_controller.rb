class MerchantBulkDiscountsController < ApplicationController
  def index 
    # binding.pry
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show

  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.new
  end

  def create 
    merchant = Merchant.find(params[:merchant_id])
    discount = merchant.bulk_discounts.new(bulk_discount_params)
    if discount.save
      redirect_to merchant_bulk_discounts_path(merchant.id), notice: 'Success!'
    else
      redirect_to new_merchant_bulk_discount_path(merchant.id), notice: "Error: Missing Field"
    end
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    discount = BulkDiscount.destroy(params[:id])
    redirect_to merchant_bulk_discounts_path(merchant.id), notice: 'Successful Destruction of Discount'
  end

  private
    def bulk_discount_params
      params.require(:bulk_discount).permit(:percentage, :quantity_threshold)
    end
end