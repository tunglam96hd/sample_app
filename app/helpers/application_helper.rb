module ApplicationHelper
  def full_title page_title = ""
    page_title.empty? ? t(".base_title") : page_title + " | " + t(".base_title")
  end
end
