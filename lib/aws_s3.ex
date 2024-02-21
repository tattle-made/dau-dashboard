defmodule AWSS3 do
  @opts [query_params: [{"x-amz-acl", "public-read"}]]

  @doc """
  Get a short lived URL to file on S3
  ### Example
  ```
  bucket = "bucket.tattle.co.in"
  key = "canon/manipulated-media/filename"
  case AWSS3.presigned_url(bucket, key) do
    {:ok, url} -> IO.inspect(url)
    {:error, error} -> IO.inspect(error)
  end
  ```
  """
  def presigned_url(bucket, key) do
    ExAws.Config.new(:s3)
    |> ExAws.S3.presigned_url(
      :get,
      bucket,
      key,
      @opts
    )
  end
end
