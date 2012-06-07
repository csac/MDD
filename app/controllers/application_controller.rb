# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  respond_to :html

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end
end
