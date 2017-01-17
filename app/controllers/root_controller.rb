class RootController < ApplicationController

  def index
    links = [
        href: "#{ApplicationController.hostname}/owners",
    ]

    render json: { links: links }
  end

end
