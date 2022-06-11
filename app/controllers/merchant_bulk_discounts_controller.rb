class MerchantBulkDiscountsController < ApplicationController
  def index 
    # binding.pry
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    # binding.pry
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.new
  end

  def create 
    merchant = Merchant.find(params[:merchant_id])
    discount = merchant.bulk_discounts.new(bulk_discount_params)
    if discount.save
      redirect_to merchant_bulk_discounts_path(merchant.id), notice: 'Success! Discount Created'
    else
      redirect_to new_merchant_bulk_discount_path(merchant.id), notice: "Error: Missing Field"
    end
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    discount = BulkDiscount.destroy(params[:id])
    redirect_to merchant_bulk_discounts_path(merchant.id), notice: 'Successful Destruction of Discount'
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def update 
    merchant = Merchant.find(params[:merchant_id])
    discount = BulkDiscount.find(params[:id])
    if discount.update(bulk_discount_params)
      redirect_to merchant_bulk_discount_path(merchant.id, discount.id)
    else
      redirect_to edit_merchant_bulk_discount_path(merchant.id, discount.id), notice: 'Discount not updated, add missing field'
    end

  end

  private
    def bulk_discount_params
      params.require(:bulk_discount).permit(:percentage, :quantity_threshold)
    end
end