defmodule Steins.QA do
  def run_checks(project_url) do
    [
      finding("Home page reachable", "low", "pass", project_url),
      finding("Contact form visible", "medium", "pass", project_url <> "/contact"),
      finding("Checkout flow smoke", "high", "fail", project_url <> "/checkout", "Checkout button missing on mobile viewport")
    ]
  end

  defp finding(title, severity, status, path, details \\ nil) do
    %{
      "title" => title,
      "severity" => severity,
      "status" => status,
      "path" => path,
      "details" => details,
      "screenshot_url" => if(status == "fail", do: "/screenshots/placeholder-fail.png", else: nil)
    }
  end
end
