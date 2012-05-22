# encoding: utf-8
class SearchController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html

  def index
    @sheets = Sheet.search(params).perform.results
  end
end

