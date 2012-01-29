class Admin::UsersController < Admin::BaseController
  resource_controller                                                             

  create.wants.html { redirect_to edit_object_url(@object) }
  update.wants.html { redirect_to edit_object_url(@object) }

  def destroy
    destroy_object
  end

private

  def collection
    load_filters
    @search = User.metasearch(@filters)
    @collection = @search.paginate( :per_page => @rpp, :page => params[:page])
  end

end
