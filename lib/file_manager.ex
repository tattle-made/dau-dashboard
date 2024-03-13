defmodule FileManager do
  alias ExAws.S3

  def upload_to_s3(url) do
    {:ok, _, _headers, ref} = :hackney.get(url)
    {:ok, body} = :hackney.body(ref)
    file_key = "app-data/#{UUID.uuid4()}"
    file_hash = :crypto.hash(:sha256, body) |> Base.encode16() |> String.downcase()
    S3.put_object("staging.dau.tattle.co.in", file_key, body) |> ExAws.request!()
    {file_key, file_hash}
  end
end
