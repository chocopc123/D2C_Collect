class ShopsController < ApplicationController
  before_action :authenticate_shop, {only: [:edit, :update, :destroy, :password_reset, :password_update, :logout]}
  before_action :ensure_correct_shop, {only: [:edit, :update, :destroy, :password_reset, :password_update]}
  before_action :authenticate_user, {only: [:add_review]}
  before_action :set_search_genre

  protect_from_forgery except: :index

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
        if @search_genre.floor == 1
          @hit_duplication_shops = ShopsGenre.where(genre_id: @search_genre.genre_id)
          @hit_duplication_shops_ids = @hit_duplication_shops.pluck(:shop_id)
          @hit_shops_ids = @hit_duplication_shops_ids.uniq
          @hit_shops = []
          @hit_shops_ids.each do |hit_shops_id|
            @hit_shops.insert(0, ShopsGenre.find_by(shop_id: hit_shops_id))
          end
        else
          @hit_shops = ShopsGenre.where(genre_column_id: @search_genre.id)
        end
        if @hit_shops != nil
          @shops = []
          @hit_shops.each do |hit_shop|
            @shops.insert(0, Shop.find_by(id: hit_shop.shop_id ) )
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
    @reviews = Review.where(shop_id: @shop.id)
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
        @shop_genre = ShopsGenre.new(shop_id: params[:id], genre: @genre.name, genre_id: @genre.genre_id, genre_column_id: @genre.id)
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

  def add_review
    @review = Review.new(user_id: @current_user.id, shop_id: params[:id], content: params[:content])
    if @review.save
      flash[:notice] = "レビューを投稿しました。"
    end
    redirect_to("/shops/#{params[:id]}")
  end

  def remove_review
    @destroy_review = Review.find_by(id: params[:review_id])
    @destroy_review.destroy
    flash[:notice] = "レビューを削除しました"
    redirect_to("/shops/#{params[:id]}")
  end
end
