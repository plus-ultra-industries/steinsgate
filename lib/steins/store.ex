defmodule Steins.Store do
  @data_dir "priv/data"

  def ensure! do
    File.mkdir_p!(@data_dir)
    for name <- ["projects.json", "runs.json", "findings.json"] do
      path = Path.join(@data_dir, name)
      unless File.exists?(path), do: File.write!(path, "[]")
    end
  end

  def list(resource) do
    ensure!()
    resource
    |> file_path()
    |> File.read!()
    |> Jason.decode!()
  end

  def insert(resource, attrs) do
    ensure!()
    items = list(resource)
    record = Map.merge(%{"id" => System.unique_integer([:positive]), "inserted_at" => DateTime.utc_now() |> DateTime.to_iso8601()}, attrs)
    File.write!(file_path(resource), Jason.encode_to_iodata!([record | items]))
    record
  end

  defp file_path(resource), do: Path.join(@data_dir, "#{resource}.json")
end
