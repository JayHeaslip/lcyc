module ApplicationHelper

  def yes_no(attr)
    attr ? 'Yes' : 'No'
  end

  def button_for(name, options ={})
    return content_tag(:button, name, class: options[:class], type: options[:button_type])
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc": "asc"
    link_to title, request.params.merge(:sort => column, :direction => direction), {class: css_class}
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
      concat(content_tag(:div, message, class: "mb-2 #{bootstrap_class_for(msg_type)}", role: "alert"))
    end
    nil
  end

  def link_to_add_person(name, f, association, **args)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    person_fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize, f: builder)
    end
    link_to(name, '#', class: "add_person " + args[:class], data: {id: id, person_fields: person_fields.gsub("\n", "")})
  end

end
