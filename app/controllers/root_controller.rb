class RootController < ApplicationController

  def index
    links = [
        {href: "#{ApplicationController.hostname}/projects"},
        {href: "#{ApplicationController.hostname}/users"}
    ]
    render json: { links: links }
  end
end
