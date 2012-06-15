# encoding: utf-8
class SearchController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html

  helper_method :is_active?, :firsts, :skills_keywords_by_name, :paginable_sheets

  def index
    session[:last_search] = params
    @sheets = Sheet.search(params).perform.results
  end

  def is_active?(filter, value)
    if value == 'all' && params[filter].blank?
      'active'
    elsif params[filter].kind_of?(Array) and params[filter].include?(value)
      'active'
    elsif params[filter] == value
      'active'
    else
      ''
    end
  end

  # Take a facet and returns the n elements of the list with the
  # higher count values.
  def firsts(facet, n)
    @terms ||= facet['terms'].sort_by{ |term| term['count'] }.reverse.slice(0..9)
  end

  def skills_keywords_by_name
    KeywordCategory.skills.keywords.sort_by(&:name)
  end

  def paginable_sheets(sheets)
    Kaminari.paginate_array(sheets.to_a, total_count: sheets.total).page(params[:page] || 1)
  end
end

