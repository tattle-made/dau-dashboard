defmodule DAUWeb.SearchLive.Component do
  use DAUWeb, :live_view
  use DAUWeb, :html

  def render(assigns) do
    ~H"""
    <div class="p-2 bg-green-200">
      <% tags = [
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
        "Trigger warning",
        "Sexual content",
        "Graphic content",
        "Profanity",
        "Out of scope",
        "Palestine Genocide",
        "Ukraine War",
        "Celeb Conduct",
        "Leader Conduct",
        "Imposter Content",
        "Islamophobia",
        "Misogyny",
        "Political Fakes",
        "Election 2024",
        "Phase-1",
        "Phase-2",
        "Phase-3",
        "Phase-4",
        "Phase-5",
        "Phase-6",
        "Phase-7",
        "Farmers' Protest",
        "Economy",
        "International Relations",
        "Pakistan",
        "China",
        "Entertainment",
        "Sports",
        "Youtube",
        "Vimeo",
        "Twitter",
        "Facebook",
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
        "Mohan Bhagwat",
        "Manohar Lal Khattar",
        "Asaduddin Owaisi",
        "Kisan Mazdur Morcha (KMM)",
        "Bharat Kisan Union (BKU)",
        "Sarwan Singh Pandher",
        "Jagjit Singh Dallewal",
        "Manjeet Singh Rai",
        "Rakesh Tikait",
        "Ravish Kumar",
        "Anjana Om Kashyap",
        "Sudhir Chaudhary",
        "Punya Prasun Bajpai",
        "Rajat Sharma",
        "Arnab Goswami",
        "Rajdeep Sardesai",
        "Palki Sharma",
        "Faye D'souza"
      ] %>
    </div>
    """
  end

  def mount(params, session, socket) do
    tags = ["one"]
    {:ok, assign(socket, :tags, tags)}
  end

  def handle_event("add-tag", unsigned_params, socket) do
    IO.puts(~c"add tag event got on server")
    # {:noreply, socket}
    {:noreply, update(socket, :tags, &["two" | &1])}
  end

  def handle_event("remove-tag", unsigned_params, socket) do
    IO.puts("tag removed")
    {:noreply, socket}
  end
end

# <%= for query <- @queries do %>
#       <div class="rounded-lg py-2 my-2 border-2 border-slate-100 ">
#         <.query query={query} />
#       </div>
#     <% end %>
