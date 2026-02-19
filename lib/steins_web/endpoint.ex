defmodule SteinsWeb.Endpoint do
  use Plug.Router

  alias Steins.{QA, Store}

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

  get "/api/projects" do
    json(conn, 200, Store.list("projects"))
  end

  post "/api/projects" do
    {:ok, body, _conn} = Plug.Conn.read_body(conn)
    attrs = Jason.decode!(body)

    project =
      Store.insert("projects", %{
        "name" => Map.get(attrs, "name", "Untitled Project"),
        "base_url" => Map.get(attrs, "base_url", "https://example.com")
      })

    json(conn, 201, project)
  end

  post "/api/runs" do
    {:ok, body, _conn} = Plug.Conn.read_body(conn)
    attrs = Jason.decode!(body)
    project_id = Map.get(attrs, "project_id")

    projects = Store.list("projects")
    project = Enum.find(projects, fn p -> p["id"] == project_id end)

    if project do
      run = Store.insert("runs", %{"project_id" => project_id, "status" => "completed"})

      findings =
        QA.run_checks(project["base_url"])
        |> Enum.map(fn f -> Store.insert("findings", Map.put(f, "run_id", run["id"])) end)

      json(conn, 201, %{"run" => run, "findings" => findings})
    else
      json(conn, 404, %{"error" => "project not found"})
    end
  end

  get "/api/runs/:id/findings" do
    run_id = String.to_integer(id)

    findings =
      Store.list("findings")
      |> Enum.filter(fn f -> f["run_id"] == run_id end)

    json(conn, 200, findings)
  end

  get "/api/reports/:id.md" do
    run_id = String.to_integer(id)

    findings =
      Store.list("findings")
      |> Enum.filter(fn f -> f["run_id"] == run_id end)

    md = report_markdown(run_id, findings)

    conn
    |> put_resp_content_type("text/markdown")
    |> send_resp(200, md)
  end

  match _ do
    send_resp(conn, 404, "not found")
  end

  defp json(conn, status, payload) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(payload))
  end

  defp report_markdown(run_id, findings) do
    lines =
      findings
      |> Enum.map(fn f ->
        "- [#{String.upcase(f["status"])}] #{f["title"]} (severity: #{f["severity"]})" <>
          if(f["details"], do: "\n  - details: #{f["details"]}", else: "")
      end)

    ["# QA Report Run ##{run_id}", "", "## Findings", "" | lines]
    |> Enum.join("\n")
  end
end
