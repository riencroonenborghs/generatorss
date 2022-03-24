module ApplicationHelper
  def active_page?(path)
    request.fullpath.start_with?(path)
  end
end
