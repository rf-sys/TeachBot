class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success_notice] = 'Account activated!'
      redirect_to root_url
    else
      flash[:danger_notice] = 'Invalid activation link'
      redirect_to root_url
    end
  end
end
