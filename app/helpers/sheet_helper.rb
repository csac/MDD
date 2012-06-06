module SheetHelper

  def last_search?(referer=request.env['HTTP_REFERER'])
    if referer.present?
      uri = URI(referer)
      uri.path == '/search'
    end
  end

end

