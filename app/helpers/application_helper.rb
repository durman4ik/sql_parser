module ApplicationHelper

  def active_class?(path)
    request.path == path ? 'active' : ''
  end

  def show_yandex_metrika?
    Rails.env != 'development'
  end
end
