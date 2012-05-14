# encoding: utf-8
class SheetsController < InheritedResources::Base
  before_filter :authenticate_user!
  authorize_resource
  respond_to :html

  def create
    super
    resource.histories << History.create(user: current_user, subject: resource, action: 'create')
  end

  def update
    super
    resource.histories << History.create(user: current_user, subject: resource, action: 'update')
  end

  protected

  def collection
    @sheets ||= end_of_association_chain.page(params[:page])
  end

end

