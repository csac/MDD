# encoding: utf-8
class KeywordCategoriesController < InheritedResources::Base
  before_filter :authenticate_user!
  authorize_resource
  respond_to :html

  def index
    redirect_to keywords_path
  end

  def destroy
    destroy! do
      redirect_to :back
    end
  end

  protected

  def collection
    @keyword_categories ||= end_of_association_chain.page(params[:page])
  end

end

