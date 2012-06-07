# encoding: utf-8
class KeywordsController < InheritedResources::Base
  authorize_resource

  def new
    @keyword = Keyword.new(keyword_category_id: params[:keyword_category_id])
  end

  protected

  def collection
    @keywords ||= end_of_association_chain.page(params[:page])
  end

end

