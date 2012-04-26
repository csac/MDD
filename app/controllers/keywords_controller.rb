class KeywordsController < InheritedResources::Base
  respond_to :html

  def new
    @keyword = Keyword.new(keyword_category_id: params[:keyword_category_id])
  end

end

