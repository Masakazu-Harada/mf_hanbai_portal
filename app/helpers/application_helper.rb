module ApplicationHelper
  def document_title
    if @title.present?
      "#{@title} - mf_hanbai_portal"
    else
      "mf_hanbai_portal"
    end
  end
end
