defmodule AWSS3.Fake do
  @file_prefix "temp"

  def presigned_url(bucket, key) do
    {:ok, "https://#{bucket}.s3.amazonaws.com/#{key}"}
  end

  def upload_to_s3(url) do
    file_key = "#{@file_prefix}/#{UUID.uuid4()}"
    file_hash = :crypto.hash(:sha256, url) |> Base.encode16() |> String.downcase()
    {file_key, file_hash}
  end
end
