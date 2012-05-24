# encoding: utf-8
class SearchController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html

  helper_method :is_active?

  def index
    @sheets = Sheet.search(params).perform.results
  end

  def is_active?(filter, value)
    if value == 'all' && params[filter].blank?
      'active'
    elsif params[filter] == value
      'active'
    else
      ''
    end
  end
end

