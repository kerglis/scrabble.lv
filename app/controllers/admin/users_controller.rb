class Admin::UsersController < Admin::BaseController

  inherit_resources
  #resource_controller                                                             

  def create
    create! { edit_resource_url(resource) }
  end

  def update
    update! { edit_resource_url(resource) }
  end

  def destroy
    destroy_object
  end

protected

  def collection
    load_filters
    @search = User.metasearch(@filters)
    @collection = @search.paginate( :per_page => @rpp, :page => params[:page])
  end

end