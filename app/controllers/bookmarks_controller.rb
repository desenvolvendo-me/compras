class BookmarksController < CrudController
  before_filter :update_links

  defaults :singleton => true

  def empty
    if current_user.try(:electronic_auction?)
      redirect_to auction_auctions_path
    end
  end

  def show
    return if resource && resource.links.any?

    # keep flash messages because bookmarks#show is the root route
    # and we can receive some flash here like from sign in page.

    company = Company.where(user_id: current_user.id).try(:last)
    if company
      redirect_to edit_auction_person_path(company.person.id)
    else
      flash.keep
      redirect_to empty_bookmark_path
    end
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
