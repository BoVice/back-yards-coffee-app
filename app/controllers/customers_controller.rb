class CustomersController < ApplicationController
  before_action :authenticate_customer!, except: [:index]
  before_action :authenticate_employee_admin!, only: [:index]

  def index
    @customers = Customer.all
  end

  def show
    @customer = Customer.find(current_customer.id)
    @stripe_customer = Stripe::Customer.retrieve(@customer.stripe_customer_id)
  end

  def edit
    @customer = Customer.find(current_customer.id)
  end

  def update
    @customer = Customer.find(current_customer.id)
    if @customer.update(customer_params)
      flash[:success] = 'Shipping address updated'
      StripeTool.customer_shipping_update(@customer)
      redirect_to '/customers/dashboard'
    else
      flash[:warning] = 'Unable to update address'
      render :edit
    end
  end

  private

  def customer_params
    params.permit(
      :first_name,
      :last_name,
      :address,
      :Address2,
      :city,
      :state,
      :zip_code
    )
  end
end
