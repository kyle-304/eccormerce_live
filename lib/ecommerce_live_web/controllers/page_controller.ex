defmodule EcommerceLiveWeb.PageController do
  use EcommerceLiveWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
