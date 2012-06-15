module SheetHelper

  def last_search?
    !session[:last_search].nil?
  end

end

