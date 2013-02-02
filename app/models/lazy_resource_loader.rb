module LazyResourceLoader

  def load_resources
  	param_resource_keys.each{ |key| load_resource(key) }
  	load_main_resource
  end

  private

  def load_main_resource
    param_key_to_class(controller_model_key) rescue return

  	if params[:action] == "create" || params[:action] == "new"
			new_main_resource
  	else
  		load_resource(controller_model, params[:id] || :all)
  	end
  end

  def new_main_resource
  	resource = controller_model.new(params[:"#{controller_model_key}"])
  	instance_variable_set(variable_name_for(resource), resource)
  end

  def variable_name_for resource, plural=false
  	if resource.respond_to?(:each) 
  		return variable_name_for resource.first, true
  	end

  	key = resource.class.name.underscore
  	key = plural ? key.pluralize : key
  	:"@#{key}"
  end

  def load_resource cls, parameter = nil
  	cls = param_key_to_class(cls) if cls.is_a? String
  	parameter ||= params[:"#{cls.to_s.underscore}_id"]
    if cls.respond_to? :find
    	resource = cls.find(parameter)
    	instance_variable_set(variable_name_for(resource), resource)
    end
  end

  def controller_model
  	param_key_to_class(controller_model_key)
  end

  def controller_model_key
  	params[:controller].to_s.singularize
  end

  def param_resource_keys
  	params.map{ |k, _| k if k.to_s.ends_with?("_id") }.compact
  end

  def param_key_to_class(key)
  	key.to_s.split("_id").first.singularize.camelcase.constantize
  end

end
