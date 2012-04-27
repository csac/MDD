class KeywordCategoriesController < InheritedResources::Base
  before_filter :authenticate_user!
  respond_to :html
end

