class ApplicationController < ActionController::Base
    before_action :set_current_shop

    def set_current_shop
        @current_shop = Shop.find_by(id: session[:shop_id])
    end
end
