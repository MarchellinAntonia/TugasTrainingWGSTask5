class UsersController < ApplicationController
  def index
  	@users = User.all
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(params_user)
  	if @user.save
  		flash[:notice] = "User successfully added!"
  		redirect_to action: "index"
  	else
  		flash[:error] = "data not valid"
        render 'new'
  	end
  end

  def edit
  	@user = User.find_by_id(params[:id])
  end

  def update
  	@user = User.find_by_id(params[:id])
	if @user.update(params_user)
		flash[:notice] = "#{params[:name]} successfully updated!"
        redirect_to action: 'index'
	else
		flash[:error] = "data not valid"
		render 'edit'
	end
  end

  def destroy
  	@user = User.find_by_id(params[:id])
  	if @user.destroy
        flash[:notice] = "#{params[:name]} successfully deleted"
        redirect_to action: 'index'
    else
        flash[:error] = "fails delete a records"
        redirect_to action: 'index'
    end
  end

  private
    def params_user
        params.require(:user).permit(:name, :sex, :dob, :email, :phone, :address)
    end
end
