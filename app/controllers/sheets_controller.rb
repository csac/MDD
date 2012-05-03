# encoding: utf-8
class SheetsController < InheritedResources::Base
  before_filter :authenticate_user!
  authorize_resource
  respond_to :html

  protected

  def collection
    @sheets ||= end_of_association_chain.page(params[:page])
  end

end

