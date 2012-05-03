# encoding: utf-8
class KeywordCategoriesController < InheritedResources::Base
  before_filter :authenticate_user!
  authorize_resource
  respond_to :html

  protected

  def collection
    @keyword_categories ||= end_of_association_chain.page(params[:page])
  end

end

