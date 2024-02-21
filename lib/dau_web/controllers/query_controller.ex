defmodule DAUWeb.QueryController do
  alias DAU.Repo
  use DAUWeb, :controller

  def index(conn, _params) do
    queries = [
      %{
        id: "12312321",
        type: "image",
        url: "https://wallpapers.com/images/featured/flower-pictures-unpxbv1q9kxyqr1d.jpg"
      },
      %{
        id: "56456456",
        type: "video",
        url:
          "https://github.com/tattle-made/feluda/raw/master/src/core/operators/sample_data/sample-cat-video.mp4"
      },
      %{
        id: "96789789",
        type: "image",
        url: "https://wallpapers.com/images/featured/flower-pictures-unpxbv1q9kxyqr1d.jpg"
      },
      %{
        id: "9423111",
        type: "image",
        url: "https://wallpapers.com/images/featured/flower-pictures-unpxbv1q9kxyqr1d.jpg"
      }
    ]

    # comment = %{
    #   types: [:plain_text, :checklist, :form],
    #   checklist: [
    #     %{id: "label_1", label: "Item 1"},
    #     %{id: "answer_1", input_type: "check"},
    #     %{id: "label_2", label: "Item 2"},
    #     %{id: "answer_2", input_type: "check"}
    #   ],
    #   data: %{
    #     type: :plain_text
    #   }
    # }
    comment = %{
      types: [:plain_text, :checklist, :form],
      checklist: [
        %{id: "label_1", label: "Item 1"},
        %{id: "answer_1", input_type: "check"},
        %{id: "label_2", label: "Item 2"},
        %{id: "answer_2", input_type: "check"}
      ],
      data: %{
        type: :checklist
      }
    }

    # queries = Repo.all(Query)
    # render(conn, :index, queries: queries)
    render(conn, :index, queries: queries, comment: comment)
  end
end
