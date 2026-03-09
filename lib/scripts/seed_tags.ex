defmodule Scripts.SeedTags do
  alias DAU.OpenData.Tag
  alias DAU.OpenData
  alias DAU.OpenData.TagsCategory
  alias DAU.Repo

  def run() do
    tags = get_tags()

    Enum.each(tags, fn {key, value} ->
      category_result =
        case Repo.get_by(TagsCategory, slug: OpenData.normalize_tag(key)) do
          nil ->
            case OpenData.add_tag_category(%{category: key, slug: OpenData.normalize_tag(key)}) do
              {:ok, cat} -> {:ok, cat}
              {:error, changeset} ->
                IO.puts("failed to create category #{key}: #{inspect(changeset.errors)}")
                {:error, :category_failed}
            end

          existing ->
            {:ok, existing}
        end

      case category_result do
        {:ok, %TagsCategory{} = cat} ->
          Enum.each(value, fn tag ->
            case Repo.get_by(Tag, slug: OpenData.normalize_tag(tag)) do
              nil ->
                case OpenData.add_tag(%{name: tag, slug: OpenData.normalize_tag(tag), tags_category_id: cat.id}) do
                  {:ok, _} -> :ok
                  {:error, changeset} ->
                    IO.puts("failed to create tag #{tag} in category #{key}: #{inspect(changeset.errors)}")
                end

              existing ->
                {:ok, existing}
            end
          end)

        {:error, _} ->
          # skip tags if category creation failed
          :ok
      end
    end)
  end

  def get_tags do
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
      # "Not sure what this is" => [
      #   "Phase-1",
      #   "Phase-2",
      #   "Phase-3",
      #   "Phase-4",
      #   "Phase-5",
      #   "Phase-6",
      #   "Phase-7"
      # ],
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
end
