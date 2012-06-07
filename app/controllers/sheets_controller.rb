# encoding: utf-8
class SheetsController < InheritedResources::Base
  before_filter :authenticate_user!
  authorize_resource
  respond_to :html

  helper_method :search_results, :previous_result, :next_result

  def create
    create! do |success, error|
      success.any do
        resource.histories << History.create(user: current_user, subject: resource, action: 'create')
        redirect_to sheet_path(resource)
      end
    end
  end

  def update
    update! do |success, error|
      success.any do
        resource.histories << History.create(user: current_user, subject: resource, action: 'update')
        redirect_to sheet_path(resource)
      end
    end
  end

  def search_results(uri)
    query  = URI(uri).query
    params = Rack::Utils.parse_nested_query(query)
    Sheet.search(params).perform.results
  end

  def previous_result
    results = search_results(request.env['HTTP_REFERER']).to_a
    i = results.index(resource)
    i >= 1 ? results[i - 1] : nil
  end

  def next_result
    results = search_results(request.env['HTTP_REFERER']).to_a
    i = results.index(resource)
    i < (results.size - 1) ? results[i + 1] : nil
  end

  protected

  def collection
    @sheets ||= end_of_association_chain.page(params[:page])
  end

end

