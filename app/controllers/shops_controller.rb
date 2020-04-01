class ShopsController < ApplicationController
  before_action :authenticate_shop, {only: [:edit, :update, :destroy, :password_reset, :password_update, :logout]}
  before_action :ensure_correct_shop, {only: [:edit, :update, :destroy, :password_reset, :password_update]}
  before_action :set_search_genre

  def index
    # session[:search_genre_id]セット
    if @search_genre
      @genres = Genre.where(genre_id: @search_genre.genre_id, floor: 2)
    else
      @genres = Genre.where(floor: 1)
    end
    if params[:genre]
      @genre = Genre.find_by(id: params[:genre])
      session[:search_genre_id] = @genre.id
      redirect_to("/shops/index")
    end
    if @search_genre
      if params[:keyword]
        @shops = Shop.where("name Like ?", "%#{params[:keyword]}%").order(id: :desc)
      else
        shops_id = ShopsGenre.where(genre_id: @search_genre.genre_id)
        #if (shops_id.to_a)[0] != nil
        #  @shops = []
        #  @shops

        #  @shops = Shop.where(id: (shops_id.to_a)[0].shop_id )
        #  @shops[0] = Shop.where(id: (shops_id.to_a)[0] )
        #  @shops[1] = Shop.where(id: (shops_id.to_a)[1] )
        #end
        if (shops_id.to_a)[0] != nil
          @shops = []
          i = 0
          (shops_id.to_a).each do |shops_id|
            @shopsx = Shop.where(id: shops_id.shop_id )
            @shops + [@shopsx]
          end
        end

      end
    else
      if params[:keyword]
        @shops = Shop.where("name Like ?", "%#{params[:keyword]}%").order(id: :desc)
      else
        @shops = Shop.all.order(id: :desc)
      end
    end
    if @shops
      @result_amount = @shops.count
    end
  end

  def new
    @shop = Shop.new
  end

  def show
    @shop = Shop.find_by(id: params[:id])
    @shop_genres = ShopsGenre.where(shop_id: @shop.id)
  end

  def create
    @shop = Shop.new(name: params[:name], url: params[:url], email: params[:email], password: params[:password], icon_name: "default_icon.jpg")
    if @shop.save
      if params[:icon]
        @shop.icon_name = "#{@shop.id}.jpg"
        icon = params[:icon]
        File.binwrite("public/shop_icons/#{@shop.icon_name}", icon.read)
        @shop.save
      end
      session[:shop_id] = @shop.id
      flash[:notice] = "登録完了しました"
      redirect_to("/shops/index")
    else
      render("shops/new")
    end
  end

  def edit
    @shop = Shop.find_by(id: params[:id])
  end

  def update
    @shop = Shop.find_by(id: params[:id])
    @shop.name = params[:name]
    @shop.url = params[:url]
    @shop.email = params[:email]
    if @shop.save
      if params[:icon]
        @shop.icon_name = "#{@shop.id}.jpg"
        icon = params[:icon]
        File.binwrite("public/shop_icons/#{@shop.icon_name}", icon.read)
        @shop.save
      end
      flash[:notice] = "編集完了しました"
      redirect_to("/shops/#{@shop.id}")
    else
      render("shops/edit")
    end
  end

  def destroy
    @shop = Shop.find_by(id: params[:id])
    @shop.destroy
    flash[:notice] = "ショップを削除しました"
    redirect_to("/shops/index")
  end

  def login
    @shop = Shop.find_by(email: params[:email])
    if @shop && @shop.authenticate(params[:password])
      session[:shop_id] = @shop.id
      flash[:notice] = "ログインしました"
      redirect_to("/shops/#{@shop.id}")
    else
      @email = params[:email]
      @password = params[:password]
      @error_message = "メールアドレスまたはパスワードが間違っています"
      render("shops/login_form")
    end
  end

  def password_reset
    @shop = Shop.new
  end

  def password_update
    @shop = Shop.find_by(id: @current_shop.id)
    if params[:new_password] && @shop.authenticate(params[:current_password])
      @shop.password = params[:new_password]
      if @shop.save
        flash[:notice] = "パスワードを再設定しました"
        redirect_to("/shops/#{@shop.id}")
      else
        render("/shops/password_reset")
      end
    else
      @error_message = "パスワードが間違っているか、空です"
      render("/shops/password_reset")
    end
  end

  def logout
    session[:shop_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/shops/index")
  end

  def ensure_correct_shop
    if @current_shop && @current_shop.id != params[:id].to_i
      flash[:notice] = "権限がありません"
      redirect_to("/shops/index")
    end
  end

  def add_genre
    if params[:genre]
      @genre = Genre.find_by(id: params[:genre])
      if @genre.floor == 2
        @shop_genre = ShopsGenre.new(shop_id: params[:id], genre: @genre.name, genre_id: @genre.genre_id)
        @shop_genre.save
        redirect_to("/shops/#{params[:id]}")
      end
      @genres = Genre.where(genre_id: @genre.genre_id, floor: 2)
    else
      @genres = Genre.where(floor: 1)
    end
  end

  def remove_genre
    @shop_genres = ShopsGenre.where(shop_id: params[:id])
  end

  def genre_destroy
    @destroy_genre = ShopsGenre.find_by(id: params[:genre])
    @destroy_genre.destroy
    redirect_to("/shops/#{params[:id]}")
  end

  def search_genre_reset
    session[:search_genre_id] = nil
    redirect_to("/shops/index")
  end

  def set_search_genre
    @search_genre = Genre.find_by(id: session[:search_genre_id])
  end
end
