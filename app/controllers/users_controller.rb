class UsersController < ApplicationController

    def new
        @user = User.new
    end

    def create
        @user = User.new(username: params[:username], email: params[:email], password: params[:password], icon_name: "default_icon.jpg")
        if @user.save
          if params[:icon]
            @user.icon_name = "#{@user.id}.jpg"
            icon = params[:icon]
            File.binwrite("public/user_icons/#{@user.icon_name}", icon.read)
            @user.save
          end
          session[:user_id] = @user.id
          flash[:notice] = "登録完了しました"
          redirect_to("/users/index")
        else
          render("users/new")
        end
    end

    def login
      @user = User.find_by(email: params[:email])
      if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        flash[:notice] = "ログインしました"
        redirect_to("/users/#{@user.id}")
      else
        @email = params[:email]
        @password = params[:password]
        @error_message = "メールアドレスまたはパスワードが間違っています"
        render("users/login_form")
      end
    end

    def logout
      session[:user_id] = nil
      flash[:notice] = "ログアウトしました"
      redirect_to("/shops/index")
    end

    def show
      @user = User.find_by(id: params[:id])
    end
end
