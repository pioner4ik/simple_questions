class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create_user_with_email
    email = user_params[:email]
    auth = session["devise.auth_data"]
    if email.present?
      @user = User.create_from_oauth(email, auth)
      sign_in_and_redirect @user, event: :authentication
      flash[:success] = "Successfully authenticated from #{auth['provider'].capitalize} account."
    else
      flash[:danger] = "Email is empty!"
      redirect_to :back
    end
  end

  private

    def user_params
      params.require(:user).permit(:email)
    end
end
