class FiltersController < BaseController
  
  before_filter   :init_instances
  before_filter   :load_or_create_filter, :only => [ :add, :remove ]
  
  def search
    klass = params[:klass]
    
    filters = Filter.search(klass, params[:q]) if params[:q].to_s.length > 2
    filters ||= []
    
    respond_to do |format|
      format.html { redirect_to collection_url user_stores_url() }
      format.js do
        render :update do |page|
          page.replace_html "filter_list_#{klass}", :partial => "filters/filters_list", :locals => { :filters => filters }
        end
      end
    end

  end
  
  def reset
    klass = params[:klass]
    Filter.delete_by_klass(klass)
    session[:filters] = Filter.instances

    load_filtered

    respond_to do |format|
      format.html { redirect_to collection_url user_stores_url() }
      format.js do
        render :update do |page|
          page.replace_html "filters_selected_#{klass}",  :partial => "filters/filters_list", :locals => { :filters => [] }
          page.replace_html "filter_list_#{klass}",       :partial => "filters/filters_list", :locals => { :filters => (klass != "Taxon") ? Filter.collect_by_klass(klass) : [] }
          page.replace_html "filtered_info",              :partial => "filters/filtered_info"
        end
      end
    end
 end
  
  def add
    
    if @filter
      @filter.add
      session[:filters] = Filter.instances

      klass = @filter.klass

      load_filtered      
      
      respond_to do |format|
        format.html { redirect_to collection_url user_stores_url() }
        format.js do
          render :update do |page|
            page << "$('#{dom_id(@filter.get_object, :filter)}').fade();"
            page.replace_html "filters_selected_#{klass}",  :partial => "filters/filters_selected", :locals => { :klass => klass }
            page.replace_html "filtered_info",              :partial => "filters/filtered_info"
          end
        end
      end
    end
  end

  def remove
    if @filter
      @filter.remove
      session[:filters] = Filter.instances
      
      load_filtered

      klass = @filter.klass
      
      respond_to do |format|
        format.html { redirect_to collection_url user_stores_url() }
        format.js do
          render :update do |page|
            page << "$('#{dom_id(@filter.get_object, :filter_selected)}').fade();"
            page.replace_html "filtered_info",              :partial => "filters/filtered_info"
          end
        end
      end
    end
  end
  

private
  
  def init_instances
    session[:filters] = Filter.init_instances(session[:filters])
  end
    
  def load_or_create_filter
    @filter = Filter.find(params[:id])
    @filter ||= Filter.create(params[:id])
    
    @filter_obj = @filter.get_object rescue nil
    @filter = nil unless @filter_obj
  end
  
end
