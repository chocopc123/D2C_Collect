class AdminsController < ApplicationController
  def login_form
    @admin = Admin.new
  end

  def login
    @admin = Admin.find_by(admin_id: params[:admin_id])
    if @admin && @admin.authenticate(params[:password])
      session[:admin] = 1
      flash[:notice] = "管理者権限にログインしました"
      redirect_to("/shops/index")
    else
      @admin_id = params[:admin_id]
      @password = params[:password]
      @error_message = "IDまたはPasswordが間違っています"
      render("admins/login_form")
    end
  end
end
