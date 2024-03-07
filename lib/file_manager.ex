defmodule FileManager do
  def upload_to_s3(url) do
    {:ok, _, _headers, ref} =:hackney.get(url)
    {:ok, body} = :hackney.body(ref)
    file_key = UUID.uuid4()
    file_hash = :crypto.hash(:sha256, body) |> Base.encode16 |> String.downcase
    path = "priv/static/assets/media/" <> file_key
    File.write!(path, body, [:write, :binary])
    File.rm(path)
    {file_key, file_hash}
  end
end
