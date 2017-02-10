class RootController < ApplicationController

  def index
    links = [
        href: "#{ApplicationController.hostname}/projects",
    ]
    render json: { links: links }
  end
end
