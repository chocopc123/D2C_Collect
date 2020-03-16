class ApplicationController < ActionController::Base
    before_action :set_current_shop

    def set_current_shop
        @current_shop = Shop.find_by(id: session[:shop_id])
    end

    def authenticate_shop
        if @current_shop == nil
            flash[:notice] = "ログインが必要です"
            redirect_to("/shops/login_form")
        end
    end
end
