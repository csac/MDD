class KeywordCategoriesController < InheritedResources::Base
  before_filter :authenticate_user!
  authorize_resource
  respond_to :html
end

