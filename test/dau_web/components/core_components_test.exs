defmodule DAUWeb.CoreComponentsTest do
  alias Phoenix.LiveViewTest
  alias DAUWeb.CoreComponents
  use ExUnit.Case
  import Phoenix.LiveViewTest
  import Phoenix.Component

  test "text media preview with single url" do
    assigns = %{}

    urls = ["https://example.com"]

    component =
      rendered_to_string(~H"""
      <CoreComponents.media_text text="this is a message with multiple urls. Like https://example.com" />
      """)

    parsed_components = LiveViewTest.DOM.parse(component)
    els = LiveViewTest.DOM.all(parsed_components, "a")

    rendered_urls =
      Enum.map(els, fn el ->
        {_el, _meta, url} = el
        url |> hd
      end)

    assert rendered_urls == urls
  end

  test "text media preview" do
    assigns = %{}

    urls = [
      "https://example.com",
      "https://www.example.com",
      "https://example.com",
      "http://example.com",
      "https://tattle.co.in",
      "https://api.dau.tattle.co.in",
      "https://tattle.co.in",
      "https://dau.mcaindia.in/blog/video-of-rajat-sharma-promoting-cure-for-vision-loss-is-manipulated"
    ]

    component =
      rendered_to_string(~H"""
      <CoreComponents.media_text text="this is a message with multiple urls. Like https://example.com or https://www.example.com or https://example.com. It should also support http protocols like http://example.com

            it should support multiple subdomains like in https://tattle.co.in or https://api.dau.tattle.co.in
            It needs to handle accidental periods at the end of a url like in https://tattle.co.in.

            It should also handle long urls with paths in it like https://dau.mcaindia.in/blog/video-of-rajat-sharma-promoting-cure-for-vision-loss-is-manipulated" />
      """)

    parsed_components = LiveViewTest.DOM.parse(component)
    els = LiveViewTest.DOM.all(parsed_components, "a")

    rendered_urls =
      Enum.map(els, fn el ->
        {_el, _meta, url} = el
        url |> hd
      end)

    assert rendered_urls == urls
  end
end
