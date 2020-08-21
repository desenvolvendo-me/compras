class Auction::PeopleController < Auction::BaseController
  skip_before_filter :authenticate_user!
  skip_before_filter :authorize_resource!
end
