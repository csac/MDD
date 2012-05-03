# encoding: utf-8
class KeywordsController < InheritedResources::Base
  before_filter :authenticate_user!
  authorize_resource
  respond_to :html

  def new
    @keyword = Keyword.new(keyword_category_id: params[:keyword_category_id])
  end

  protected

  def collection
    @keywords ||= end_of_association_chain.page(params[:page])
  end

end

