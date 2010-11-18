class WelcomeController < ActionController::Base
  layout "application"
  before_filter :setup_user_id

  def index
    render :action => 'index'
  end

  def about
    "Hello World"
  end

  private

  def setup_user_id
    session[:user_id] = 10
  end
end