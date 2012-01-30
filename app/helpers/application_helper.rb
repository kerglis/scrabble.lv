module ApplicationHelper

  def t1(klass)
    klass.model_name.human
  end

  def t2(klass)
    klass.model_name.human(:count => 2)
  end

  def tN(klass)
    t("create_new", :model => klass.model_name.human)
  end

  def tE(klass)
    t("edit_existing", :model => klass.model_name.human)
  end

  def admin_namespace?
    controller.class.name.split("::").first == "Admin"
  end

  def data_for_js_tree(root)
    root.tree_params(false)
  end

  def link_to_edit(resource, options = {})
    editable = resource.editable? rescue true # ja nav f-cija - ļaujam rediģēt
    options.reverse_merge! :url => edit_resource_url(resource) unless options.key? :url
    text = options[:text] rescue ""
    link_to(text.to_s + icon('edit', :title => I18n.t("edit")), options[:url], options.update(:class => 'iconlink')) if editable
  end

  def link_to_destroy(resource, options = {})
    options.assert_valid_keys(:url, :confirm, :label)
    options.reverse_merge! :url => resource_url(resource) unless options.key? :url
    options.reverse_merge! :confirm => t("confirm_delete")
    options.reverse_merge! :label => icon("minus-circle", :title => I18n.t("delete")) unless  options.key? :label

    in_params = { 
      :remote =>    true,
      :method =>    :delete,
      :confirm =>   options[:confirm],
    }

    link_to(options[:label], options[:url], in_params)
  end

  def link_to_delete(resource, options = {})
    link_to_destroy(resource, options)
  end

  def flag(locale, options = {})
    image_tag("flags/flag_#{locale}.gif", options)
  end

  def icon(icon_name, options = {})
    image_tag("icons/#{icon_name}.png", options)
  end

  def self.icon_a(icon_name, options = {})
    image_tag("icons/#{icon_name}.png", options)
  end

  def icon_active(options = {})
    icon((options[:icon_active]) ? options[:icon_active] : "tick-circle")
  end

  def icon_inactive(options = {})
    icon((options[:icon_inactive]) ? options[:icon_inactive] : "disabled-dim")
  end

  def link_to_swap(resource, options = {})
    options.reverse_merge! :url =>      resource_url(resource)      unless options.key? :url
    options.reverse_merge! :confirm =>  t("confirm_deactivate")     unless options.key? :confirm
    options.reverse_merge! :state =>    resource.state == "active"  unless options.key? :state
    options.reverse_merge! :action =>   :swap                       unless options.key? :action

    path = Rails.application.routes.recognize_path(options[:url])
    swap_path = {:controller => path[:controller], :id => resource.id, :action => options[:action] }

    icn = (options[:state])       ? icon_active(options) : icon_inactive(options)
    in_options = { :method => :get, :confirm => options[:confirm], :remote => true }
    in_options.delete(:confirm) unless options[:state]

    link_to icn, swap_path, in_options
  end

  def link_to_swap_field(resource, options = {}, html = {})
    options.reverse_merge! :url =>      resource_url(resource)      unless options.key? :url
    options.reverse_merge! :action =>   :swap_field                 unless options.key? :action
    options.reverse_merge! :html => {}                              unless options.key? :html

    icon_active = icon_active(options)
    icon_inactive = icon_inactive(options)
    field_name = options[:field]

    html[:title] ||= I18n.t("swap")
    path = Rails.application.routes.recognize_path(options[:url])
    swap_path = {:controller => path[:controller], :id => resource.id, :action => options[:action], :field => field_name }
    icon = (resource[field_name]) ? icon_active : icon_inactive

    link_to(icon, swap_path, { :remote => true }, html)
  rescue
    "-"
  end

  def state_icon(resource)
    case resource.state
      when "active"
        icon("tick-circle") 
      when "inactive"
        icon("cross-circle")
    end
  end

  def url_options_authenticate?(params = {})
    return true if current_user.admin?
    false
  end

  def attachment_link(asset)
    link_to(icon(asset.icon) + " " + asset.attachment_file_name, asset.attachment.url) if asset
  end

  # Make an admin tab that coveres one or more resources supplied by symbols
  # Option hash may follow. Valid options are
  #   * :label to override link text, otherwise based on the first resource name (translated)
  #   * :route to override automatically determining the default route
  #   * :match_path as an alternative way to control when the tab is active, /products would match /admin/products, /admin/products/5/variants etc.
  def tab(*args)
    options = {:label => args.first.to_s }
    if args.last.is_a?(Hash)
      options = options.merge(args.pop)
    end
    options[:route] ||=  "admin_#{args.first}"
    options[:extra_html] ||= ""

    destination_url = send("#{options[:route]}_path")
        
    return("") unless url_options_authenticate?(Rails.application.routes.recognize_path(destination_url))

    klass = options[:label].to_s.classify.constantize
    link = link_to(t2(klass) + options[:extra_html], destination_url)
    
    css_classes = []

    selected = if options[:match_path]
      pattern = (options[:match_path].class == Array) ? options[:match_path].join('|') : options[:match_path]
      request.request_uri.index(/\/admin\/?(#{pattern})/) != nil
    else
      args.include?(controller.controller_name.to_sym)
    end
    css_classes << 'active' if selected

    if options[:css_class]
      css_classes << options[:css_class]
    end
    content_tag('li', link, :class => css_classes.join(' '))
  end

end