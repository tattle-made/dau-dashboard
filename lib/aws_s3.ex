defmodule AWSS3 do
  def client() do
    Application.get_env(:dau, :aws_client)
  end
end

defmodule AWSS3.Production do
  require Logger
  alias ExAws.S3

  @opts [query_params: [{"x-amz-acl", "public-read"}]]
  @file_prefix Application.compile_env(:dau, [AWSS3, :file_prefix])

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

  def upload_to_s3(url) do
    {:ok, _, _headers, ref} = :hackney.get(url)
    {:ok, body} = :hackney.body(ref)
    file_key = "#{@file_prefix}/#{UUID.uuid4()}"
    file_hash = :crypto.hash(:sha256, body) |> Base.encode16() |> String.downcase()
    S3.put_object("staging.dau.tattle.co.in", file_key, body) |> ExAws.request!()
    {file_key, file_hash}
  end
end

# defmodule AWSS3.Sandbox do
#   @file_prefix "temp"
#   def presigned_url(bucket, key) do
#     "https://#{bucket}-region.aws.amazon.com/#{key}"
#   end

#   def upload_to_s3(url) do
#     file_key = "#{@file_prefix}/#{UUID.uuid4()}"
#     file_hash = :crypto.hash(:sha256, url) |> Base.encode16() |> String.downcase()
#     {file_key, file_hash}
#   end
# end

defmodule AWSS3.Sandbox do
  require Logger
  alias ExAws.S3

  @opts [query_params: [{"x-amz-acl", "public-read"}]]
  @file_prefix Application.compile_env(:dau, [AWSS3, :file_prefix])

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

  def upload_to_s3(url) do
    options = [timeout: 60000, recv_timeout: 60000]

    Logger.debug("Starting upload_to_s3 with URL: #{url}")

    {:ok, _, _headers, ref} = :hackney.get(url, [], "", options)
    Logger.debug("Hackney GET successful, ref: #{inspect(ref)}")

    {:ok, body} = :hackney.body(ref)
    Logger.debug("Hackney response body received")

    file_key = "#{@file_prefix}/#{UUID.uuid4()}"
    Logger.debug("Generated file key: #{file_key}")

    file_hash = :crypto.hash(:sha256, body) |> Base.encode16() |> String.downcase()
    Logger.debug("Generated file hash: #{file_hash}")

    S3.put_object("staging.dau.tattle.co.in", file_key, body) |> ExAws.request!()
    Logger.info("File uploaded successfully to S3, key: #{file_key}")

    {file_key, file_hash}
  rescue
    error ->
      Logger.error("Error in upload_to_s3: #{inspect(error)}")
      {:error, error}
  end

end
