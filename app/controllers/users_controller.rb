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
          redirect_to("/shops/index")
        else
          render("users/new")
        end
    end
end
