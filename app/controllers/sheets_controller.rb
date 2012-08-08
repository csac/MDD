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

  def show
    @sheet = Sheet.find(params[:id])
    if request.path != sheet_path(@sheet)
      redirect_to @sheet, status: :moved_permanently
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

  def search_results(params)
    return @results if @results
    params[:pagination] = false
    @results = Sheet.search(params).perform.results
  end

  def previous_result
    params  = session[:last_search] || {}
    results = search_results(params).to_a
    i = results.index(resource)
    (i && i >= 1) ? results[i - 1] : nil
  end

  def next_result
    params  = session[:last_search] || {}
    results = search_results(params).to_a
    i = results.index(resource)
    (i && i < (results.size - 1)) ? results[i + 1] : nil
  end

  protected

  def collection
    @sheets ||= end_of_association_chain.page(params[:page])
  end



end

