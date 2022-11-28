module ApplicationHelper

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc": "asc"
    link_to title, request.params.merge(sort: column, direction: direction), {class: css_class}
  end

  def back_link(i)
    if session[:breadcrumbs].nil?
      root_path
    else
      path = session[:breadcrumbs].split(", ")
      path[-1-i] || root_path
    end
  end

  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "mb-2 text-center alert #{bootstrap_class_for(msg_type)}"))
    end
    nil
  end

  def link_to_add_attachment(name, f, association, **args)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    attachment_fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize, f: builder)
    end
    link_to(name, '#', class: "add_attachment " + args[:class], data: {id: id, attachment_fields: attachment_fields.gsub("\n", "")})
  end

  def read_only_not(roles)
    current_user.roles?(roles) ? false : true
  end

end
