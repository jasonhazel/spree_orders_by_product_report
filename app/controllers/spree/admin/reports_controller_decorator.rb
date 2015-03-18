# add the sales tax report
Spree::Admin::ReportsController.add_available_report!(:orders_by_product, 'Orders by Product Report')


Spree::Admin::ReportsController.class_eval do 
  before_action :orders_by_product_params, only: [:orders_by_product]

  def orders_by_product
    @search = Spree::Order.complete.ransack(params[:q])
    @products = Spree::Product.all.collect{ |p| [p.name, p.id] }
    @products.unshift ['All Products', '']


    @orders = @search.result.includes(:products)
  end

  private
  def orders_by_product_params
    params[:q] = {} unless params[:q]

    if params[:q][:completed_at_gt].blank?
      params[:q][:completed_at_gt] = Time.zone.now.beginning_of_month
    else
      params[:q][:completed_at_gt] = Time.zone.parse(params[:q][:completed_at_gt]).beginning_of_day rescue Time.zone.now.beginning_of_month
    end

    if params[:q] && !params[:q][:completed_at_lt].blank?
      params[:q][:completed_at_lt] = Time.zone.parse(params[:q][:completed_at_lt]).end_of_day rescue ""
    else
      params[:q][:completed_at_lt] = Time.now.end_of_month
    end

    params[:q][:s] ||= "completed_at desc"
  end

end