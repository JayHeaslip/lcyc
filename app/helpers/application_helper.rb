module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, request.params.merge(sort: column, direction: direction), { class: css_class }
  end

  def bootstrap_class_for(flash_type)
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, simple_format(message), class: "mb-2 text-left alert #{bootstrap_class_for(msg_type)}"))
    end
    nil
  end

  def app_revision
    GIT_REVISION
  end

  def short_app_revision
    GIT_REVISION == 'development' ? 'dev' : GIT_REVISION[0..6]
  end

  def github_commit_link
    return unless GIT_REVISION.present? && GIT_REVISION != 'development'

    link_to(
      short_app_revision,
      "https://github.com/JayHeaslip/lcyc/commit/#{GIT_REVISION}",
      target: "_blank",
      rel: "noopener",
      class: "text-decoration-none text-secondary"
    )
  end
end
