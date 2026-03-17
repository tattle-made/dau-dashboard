defmodule DAU.OpenData do
  import Ecto.Query, warn: false
  alias DAU.OpenData.Tag
  alias DAU.OpenData.TagsCategory
  alias DAU.Repo

  def get_open_data_from_csv() do
    # File.stream!("priv/static/open_data/dau-subset-snapshot-16-02-07.csv")
    res =
      File.stream!("priv/static/open_data/assessment_reports.csv")
      |> CSV.decode!(headers: true, escape_max_lines: 50)
      |> Enum.map(&cast_row/1)

    res
  end

  defp cast_row(row) do
    Enum.into(row, %{}, fn {key, value} ->
      {key, cast_field(key, value)}
    end)
  end

  defp cast_field(_key, nil), do: nil
  defp cast_field(_key, ""), do: nil

  defp cast_field("id", value), do: parse_int(value)
  defp cast_field("exact_count", value), do: parse_int(value)

  defp cast_field(field, value) when field in ["inserted_at", "updated_at"] do
    parse_naive_datetime(value) || value
  end

  defp cast_field("tags", value), do: parse_pg_array(value)
  defp cast_field("media_urls", value), do: parse_pg_array(value)

  defp cast_field(field, value)
       when field in ["factcheck_articles", "resources", "assessment_report"] do
    parse_json(value)
  end

  defp cast_field(_key, value), do: value

  defp parse_int(value) when is_integer(value), do: value

  defp parse_int(value) when is_binary(value) do
    case Integer.parse(String.trim(value)) do
      {int, _} -> int
      :error -> value
    end
  end

  defp parse_int(value), do: value

  defp parse_naive_datetime(value) when is_binary(value) do
    value
    |> String.trim()
    |> String.replace(" ", "T")
    |> NaiveDateTime.from_iso8601()
    |> case do
      {:ok, dt} -> dt
      _ -> nil
    end
  end

  defp parse_naive_datetime(_), do: nil

  defp parse_pg_array(value) when is_binary(value) do
    value = String.trim(value)

    cond do
      value == "" ->
        []

      String.starts_with?(value, "{") and String.ends_with?(value, "}") ->
        inner =
          value
          |> String.trim_leading("{")
          |> String.trim_trailing("}")

        inner
        |> parse_pg_array_items()
        |> Enum.reject(&(&1 == ""))

      true ->
        [value]
    end
  end

  defp parse_pg_array(value) when is_list(value), do: value
  defp parse_pg_array(_), do: []

  # Parse a Postgres text array body like:
  # AI-video,"Language : Hindi",Phase-5,"Narendra Modi"
  defp parse_pg_array_items(inner) do
    inner
    |> String.to_charlist()
    |> do_parse_pg_array_items([], [], :outside, false)
    |> Enum.map(fn chars ->
      chars
      |> to_string()
      |> String.trim()
    end)
  end

  defp do_parse_pg_array_items([], current, acc, _state, _in_quotes) do
    acc =
      case current do
        [] -> acc
        item -> [Enum.reverse(item) | acc]
      end

    Enum.reverse(acc)
  end

  # Inside quoted value
  defp do_parse_pg_array_items([?" | rest], current, acc, :inside, false) do
    do_parse_pg_array_items(rest, current, acc, :outside, true)
  end

  defp do_parse_pg_array_items([char | rest], current, acc, :inside, in_quotes) do
    do_parse_pg_array_items(rest, [char | current], acc, :inside, in_quotes)
  end

  # Just left a quoted value; next comma ends the item
  defp do_parse_pg_array_items([?, | rest], current, acc, :outside, true) do
    acc = [Enum.reverse(current) | acc]
    do_parse_pg_array_items(rest, [], acc, :outside, false)
  end

  # Skip spaces right after quoted value
  defp do_parse_pg_array_items([char | rest], current, acc, :outside, true)
       when char in [?\s, ?\t] do
    do_parse_pg_array_items(rest, current, acc, :outside, true)
  end

  # Start of quoted value
  defp do_parse_pg_array_items([?" | rest], current, acc, :outside, false) do
    do_parse_pg_array_items(rest, current, acc, :inside, false)
  end

  # Comma between unquoted items
  defp do_parse_pg_array_items([?, | rest], current, acc, :outside, false) do
    acc =
      case current do
        [] -> acc
        item -> [Enum.reverse(item) | acc]
      end

    do_parse_pg_array_items(rest, [], acc, :outside, false)
  end

  # Any other char in unquoted context
  defp do_parse_pg_array_items([char | rest], current, acc, :outside, in_quotes) do
    do_parse_pg_array_items(rest, [char | current], acc, :outside, in_quotes)
  end

  defp parse_json(value) when is_binary(value) do
    trimmed = String.trim(value)

    if trimmed == "" do
      nil
    else
      case Jason.decode(trimmed) do
        {:ok, decoded} -> decoded
        _ -> value
      end
    end
  end

  defp parse_json(value), do: value

  def get_metadata_tags_with_categories() do
    %{
      "Disclaimers" => ["Sexual content", "Graphic content", "Profanity", "Trigger warning"],
      "Indian News/Public Discourse" => [
        "Farmers' Protest",
        "Election 2024",
        "EVM",
        "RSS",
        "Electoral Bonds",
        "Virat Kohli",
        "Sachin Tendulkar",
        "Reservations",
        "Inheritance Tax",
        "Caste Census",
        "Wealth Redistribution",
        "Bheem Sena",
        "Anant Ambani",
        "DMRC",
        "Aviator App",
        "Gandhi family",
        "Kuki",
        "Meitei",
        "Rajat Sharma",
        "Mukesh Ambani",
        "Bollywood",
        "Ranveer Singh",
        "MS Dhoni",
        "Aamir Khan",
        "Amitabh Bachchan",
        "Kangana Ranaut",
        "Anupam Kher",
        "Rajat Sharma",
        "Arnab Goswami",
        "Rajdeep Sardesai",
        "Palki Sharma",
        "Faye D'souza",
        "Ravish Kumar",
        "Shah Rukh Khan",
        "Akshay Kumar",
        "Shereen Bhan",
        "Sweta Singh",
        "Rashmika Mandanna",
        "US Elections",
        "COVID-19",
        "Nandan Nilekani",
        "Sam Pitroda",
        "Kash Patel",
        "Op Sindoor",
        "Devi Prasad Shetty",
        "Imran Khan",
        "Sanjay Malhotra",
        "Pahalgam",
        "The Pope",
        "Kumbh Mela",
        "Alia Bhatt",
        "Ratan Tata",
        "NCSI",
        "Sonakshi Sinha",
        "Finance",
        "Nita Ambani",
        "Shaktikanta Das",
        "Rahil Chaudhary",
        "Naresh Trehan",
        "Jill Biden",
        "US politics",
        "Wion",
        "Narayana Murthy",
        "Sundar Pichai"
      ],
      "Indian Region" => [
        "Mysore",
        "Wayanad",
        "Manipur",
        "Surat",
        "Himachal Pradesh",
        "Andhra Pradesh",
        "Rajasthan",
        "Odisha",
        "Telangana",
        "Assam",
        "Manipur",
        "J&K",
        "Haryana",
        "Punjab",
        "Delhi",
        "Gujarat",
        "Kerala",
        "Karnataka",
        "Tamil Nadu",
        "Maharashtra",
        "Madhya Pradesh",
        "West Bengal",
        "Bihar",
        "Uttar Pradesh"
      ],
      "International Relations" => [
        "Palestine Genocide",
        "Ukraine War",
        "Pakistan",
        "China",
        "Palestine",
        "Israel"
      ],
      "Language" => [
        "Language : English",
        "Language : Hindi",
        "Language : Tamil",
        "Language : Telugu",
        "Language : Urdu",
        "Language : Marathi",
        "Language : Bangla",
        "Language : Other",
        "Language : Punjabi",
        "Language : Kannada",
        "Language : Bengali",
        "Language : Sinhala",
        "Language : Portuguese",
        "Language : Greek",
        "Language : Gujarati",
        "Language : Arabic",
        "Language : Nepali",
        "Language : Meitei"

        # Bangal
        # Bangal (Bangladeshi)
      ],
      "Media source" => ["Youtube", "Vimeo", "Twitter", "Facebook", "X", "Instagram"],
      "Misc" => [
        "Out of scope",
        "Jamie Dimon",
        "Tom Cruise",
        "Hindu",
        "Elon Musk",
        "Mark Zuckerberg",
        "Anti India",
        "Broken Link"
      ],
      "News sections" => ["Entertainment", "Sports", "Economy", "International Relations"],
      "Not sure what this is" => [
        "Phase-1",
        "Phase-2",
        "Phase-3",
        "Phase-4",
        "Phase-5",
        "Phase-6",
        "Phase-7"
      ],
      "Political Leaders" => [
        "Narendra Modi",
        "Amit Shah",
        "Rahul Gandhi",
        "Sonia Gandhi",
        "Rajnath Singh",
        "Nitin Gadkari",
        "Manoj Tiwari",
        "Piyush Goyal",
        "Yogi Adityanath",
        "JP Nadda",
        "Priyanka Gandhi",
        "Nitish Kumar",
        "Mamata Banerjee",
        "Rajnath Singh",
        "Arvind Kejriwal",
        "Rekha Gupta",
        "Mohan Bhagwat",
        "Manohar Lal Khattar",
        "Asaduddin Owaisi",
        "Kisan Mazdur Morcha (KMM)",
        "Bharat Kisan Union (BKU)",
        "Sarwan Singh Pandher",
        "Jagjit Singh Dallewal",
        "Manjeet Singh Rai",
        "Rakesh Tikait",
        "Anjana Om Kashyap",
        "Sudhir Chaudhary",
        "Punya Prasun Bajpai",
        "Mahua Moitra",
        "Kanhaiya Kumar",
        "B. R. Ambedkar",
        "D K Shivakumar",
        "Mallikarjun Kharge",
        "Baba Ramdev",
        "Nitin Gadkari",
        "Dhruv Rathee",
        "Amit Malviya",
        "Dinesh Lal Yadav",
        "Mahatma Gandhi",
        "Shashi Tharoor",
        "Hema Malini",
        "Akbaruddin Owaisi",
        "HD Kumaraswamy",
        "Dolly Sharma",
        "Annie Raja",
        "Manmohan Singh",
        "Arun Govil",
        "Bhupesh Baghel",
        "Akhilesh Yadav",
        "Volodymyr Zelenskyy",
        "Vladimir Putin",
        "Donald Trump",
        "Rishi Sunak",
        "Joe Biden",
        "Emmanuel Macron",
        "J D Vance",
        "Ebrahim Raisi",
        "Atishi Marlena Singh",
        "Tejasvi Surya",
        "Nirmala Sitharaman",
        "Kamala Harris"
      ],
      "Political Parties" => [
        "INC",
        "BJP",
        "AAP",
        "Trinamool Congress (TMC)",
        "Bahujan Samaj Party (BSP)",
        "CPI",
        "CPIM",
        "Nationalist Congress Party (NCP)",
        "Shiv Sena",
        "Telangana Rashtra Samithi (TRS)",
        "Biju Janata Dal (BJD)",
        "Rashtriya Janata Dal (RJD)",
        "All India Trinamool Congress (TMC)",
        "Dravida Munnetra Kazhagam (DMK)",
        "Shiromani Akali Dal (SAD)",
        "United Democratic Party (Meghalaya)",
        "Naga Peoples Front",
        "Goa Forward Party",
        "Asom Gana Parishad",
        "Jharkhand Mukti Morcha",
        "YSR Congress",
        "Telugu Desam Party (TDP)",
        "AIADMK",
        "People's Democratic Party (PDP)",
        "Yuvajana Sramika Rythu Congress Party",
        "People's Party of Arunachal",
        "Janata Dal (Secular)",
        "Janata Dal (United)",
        "Bodoland Peoples Front",
        "United People's Party, Liberal",
        "Rashtriya Lok Samta Party",
        "Communist Party of India (Marxist-Leninist) Liberation",
        "Janata Congress Chhattisgarh (J)",
        "Maharashtrawadi Gomantak",
        "Indian National Lok Dal",
        "Jannayak Janta Party",
        "J&K National Conference",
        "J&K National Panthers Party",
        "J&K Peoples Democratic Party (PDP)",
        "AJSU Party",
        "Kerala Congress (M)",
        "Indian Union Muslim League",
        "Revolutionary Socialist Party",
        "Maharashtra Navnirman Seena",
        "Hill State People's Democratic Party (Meghalaya)",
        "People's Democratic Front",
        "Voice of the People Party",
        "Mizo National Front",
        "Zoram Nationalist Party",
        "Nationalist Democratic Progressive Party",
        "Lok  Janshakti Party (Ram Vilas)",
        "All India Anna Dravida Munnetra Kazhagam",
        "All India N.R. Congress (Puducherry)",
        "Rashtriya Loktantrik Party (Rajasthan)",
        "Sikkim Democratic Front",
        "Sikkim Krantikari Morcha",
        "Desiya Murpokku Dravida Kazhagam (Tamil Nadu)",
        "All India Majlis-E-Ittehadul Muslimeen (Telangana)",
        "Bharat Rashtra Samithi (Telangana)",
        "Indigenous People's Front of Tripura",
        "Tipra Motha Party",
        "Apna Dal (Soneylal) Uttar Pradesh",
        "All India Forward Bloc (West Bengal)",
        "IUML",
        "UDF",
        "AIUDF",
        "I.N.D.I.A",
        "NDA",
        "Samajwadi Party"
      ],
      "Prejudice/Bias" => ["Islamophobia", "Misogyny", "Castiest", "Anti-minority"],
      "Redundant" => [
        "Pro INC",
        "Anti INC",
        "Pro Rahul Gandhi",
        "Anti Rahul Gandhi",
        "Pro Modi",
        "Anti Modi",
        "Pro BJP",
        "Anti BJP",
        "Anti-Mahatma Gandhi",
        "Anti-Hindu",
        "INDI alliance",
        "Anti INDI alliance",
        "Anti Samajwadi Party",
        "Anti Akhilesh Yadav",
        "Pro Arvind Kejriwal",
        "Anti Arvind Kejriwal",
        "Anti AAP",
        "Pro AAP",
        "Israel-Palestine",
        "Real Voice",
        "Real Video"
      ],
      "Type of Content" => [
        "Imposter Content",
        "Celeb Conduct",
        "Leader Conduct",
        "Political Fakes",
        "Health misinformation",
        "Financial scams",
        "Satire",
        "Spoof",
        "Naural Disaster Fake",
        "Lip-sync",
        "Weather/Climate Hoax",
        "Financial Advice",
        "Hate speech"
      ],
      "Type of synthetic content" => [
        "Suspected cheapfake",
        "Suspected deepfake",
        "Deepfake",
        "Cheapfake",
        "AI-voice",
        "AI-video",
        "Manipulated video",
        "Manipulated audio",
        "Faceswap",
        "AI-image",
        "Real Video, AI Voice",
        "AI Video, Real Voice",
        "AI Video, AI Voice",
        "Real Video, Real Voice",
        "Voice Clone",
        "A.I. Slop"
      ]
    }
  end

  def get_metadata_tags_with_categories_from_csv() do
    res =
      File.stream!("priv/static/open_data/metadata_tags.csv")
      |> CSV.decode!(headers: true, escape_max_lines: 50)
      # |> Enum.take(30)
      |> Enum.to_list()

    res = res |> rows_to_columns()

    File.write!("output.ex", inspect(res, pretty: true, limit: :infinity))
  end

  def rows_to_columns(rows) do
    Enum.reduce(rows, %{}, fn row, acc ->
      Enum.reduce(row, acc, fn {key, value}, acc2 ->
        Map.update(acc2, key, [value], &[value | &1])
      end)
    end)
    |> Map.new(fn {k, v} -> {k, Enum.reverse(clean_values(v))} end)
  end

  def clean_values(values) do
    Enum.reject(values, fn v -> v == "" end)
    |> Enum.map(fn v ->
      String.trim_trailing(v, ",")
    end)
  end

  def add_tag_category(attrs \\ %{}) do
    %TagsCategory{}
    |> TagsCategory.changeset(attrs)
    |> Repo.insert()
  end

  def add_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  def normalize_tag(tag) when is_binary(tag) do
    tag
    |> String.downcase()
    |> String.trim()
    # treat punctuation as separators
    |> String.replace(~r/[\/:'-]+/, " ")
    # collapse whitespace
    |> String.replace(~r/\s+/, " ")
    # choose canonical separator
    |> String.replace(" ", "_")
  end

  def list_tag_categories_with_tags() do
    TagsCategory
    |> order_by([tc], asc: tc.category)
    |> preload(tags: ^from(t in Tag, order_by: [asc: t.name]))
    |> Repo.all()
  end

  def list_languages_tags() do
    Tag |> where([t], like(t.slug, "language_%") and t.slug != "language_other") |> Repo.all()
  end

  def extract_first_url_from_text(text) when is_binary(text) do
    # The Regex:
    # 1. \b(?:https?:\/\/|www\.) -> Mandatory prefix (Prevents sentence-typo matches)
    # 2. [a-zA-Z0-9\-\.]+ -> Handles infinite subdomains/dots
    # 3. (?:\/\S*)? -> Greedily grabs the path/query params until it hits a space (\S)
    regex = ~r/\b(?:https?:\/\/|www\.)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,}(?:\/\S*)?/i

    case Regex.run(regex, text) do
      [url | _] ->
        url
        # 1. Remove trailing punctuation (periods, commas, etc. at the end of sentences)
        |> (&Regex.replace(~r/[.,)\]\}]+$/, &1, "")).()
        # 2. Prepend https:// if it only starts with www. (Puppeteer requires a protocol)
        |> (fn
              "www." <> _ = u -> "https://" <> u
              u -> u
            end).()

      _ ->
        nil
    end
  end
end
