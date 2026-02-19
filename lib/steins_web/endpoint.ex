defmodule SteinsWeb.Endpoint do
  use Plug.Router

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:json, :urlencoded, :multipart], pass: ["*/*"], json_decoder: Jason
  plug Plug.Static, at: "/", from: {:steins, "priv/static"}, gzip: false
  plug :match
  plug :dispatch

  get "/health" do
    send_resp(conn, 200, "ok")
  end

  get "/" do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, SteinsWeb.Layout.index_html())
  end

  get "/inertia" do
    page = %{
      component: "Dashboard",
      props: %{title: "Steins QA", runs: []},
      url: "/inertia",
      version: "1"
    }

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(page))
  end

  post "/api/projects" do
    {:ok, body, _conn} = Plug.Conn.read_body(conn)
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(201, Jason.encode!(%{ok: true, received: body}))
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
