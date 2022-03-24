class HomeController < ApplicationController
  def index
    redirect_to user_subscriptions_path if user_signed_in?
  end
end
