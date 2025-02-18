Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/merchants/:merchant_id/dashboard', to: 'merchants#show'

  resources :admin, only: [:index]

  scope '/admin' do
    resources :merchants, controller: 'admin_merchants', except: %i[delete]
    resources :invoices, controller: 'admin_invoices', only: %i[index show update]
  end

  resources :merchants, only: [:show] do
    resources :invoices, controller: 'merchant_invoices', only: %i[index show update]
    resources :invoice_items, controller: 'merchant_invoice_items', only: [:update]
    resources :bulk_discounts, controller: 'merchant_bulk_discounts'
    resources :items, controller: 'merchant_items'
  end

  patch '/merchants/:merchant_id/items', to: 'merchant_items#update'

end
