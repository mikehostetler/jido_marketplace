defmodule JidoMarketplaceWeb.PageController do
  use JidoMarketplaceWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
