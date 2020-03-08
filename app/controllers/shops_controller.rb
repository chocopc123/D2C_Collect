class ShopsController < ApplicationController
  def index
    @shops = Shop.all.order(id: :desc)
  end

  def new
  end

  def show
    @shop = Shop.find_by(id: params[:id])
  end

  def create
    @shop = Shop.new(name: params[:name], url: params[:url], icon_name: "default_icon.jpg")
    if @shop.save
      flash[:notice] = "登録完了しました"
      redirect_to("/shops/index")
    else
      render("shops/new")
    end
  end
end
