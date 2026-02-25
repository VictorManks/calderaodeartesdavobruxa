defmodule CalderaodeartesdavobruxaWeb.PageController do
  use CalderaodeartesdavobruxaWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
