class ShopsController < ApplicationController
  def index
    @shops = Shop.all.order(id: :desc)
  end
end
