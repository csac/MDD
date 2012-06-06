class KeywordObserver < ActiveRecord::Observer

  def before_destroy(model)
    model.sheets.each do |sheet|
      sheet.keywords.delete(model)
      sheet.save
    end
    Sheet.refresh_index!
  end

end
