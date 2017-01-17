class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_authorization_check
  
  before_action :social_network

  def facebook
  end

  def vkontakte
  end

  private

    def social_network
      auth = request.env['omniauth.auth']
      @user = User.find_for_oauth(auth)
      if @user
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
      else
        session["devise.auth_data"] = auth
        redirect_to new_user_path
      end
    end
end