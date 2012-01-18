class BookmarksController < CrudController
  before_filter :update_links

  defaults :singleton => true

  def empty
  end

  def show
    return if resource && resource.links.any?

    # keep flash messages because bookmarks#show is the root route
    # and we can receive some flash here like from sign in page.
    flash.keep

    redirect_to empty_bookmark_path
  end

  protected

  def update_links
    link_updater = LinkUpdater.new
    link_updater.update!
  end

  def begin_of_association_chain
    current_user
  end
end
