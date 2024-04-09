# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     DAU.Repo.insert!(%DAU.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias DAU.Accounts
alias DAU.Feed

# Create Users
[
  %{email: "dau_admin@email.com", password: "dau_admin_pw", role: :admin},
  %{
    email: "dau_associate2@email.com",
    password: "dau_associate_pw",
    role: :secratariat_associate
  },
  %{
    email: "tattle_manager@email.com",
    password: "tattle_manager_pw",
    role: :secratariat_manager
  },
  %{
    email: "dau_factchecker@email.com",
    password: "dau_factchecker_pw",
    role: :expert_factchecker
  },
  %{
    email: "dau_forensic@email.com",
    password: "dau_forensic_pw",
    role: :expert_forensic
  },
  %{email: "dau_user@email.com", password: "dau_user_pw", role: :user}
]
|> Enum.map(&Accounts.register_user(&1))

[
  %{
    media_urls: ["temp/audio-01.wav"],
    media_type: "audio",
    sender_number: "0000000000",
    language: "en"
  },
  %{
    media_urls: ["temp/video-04.mp4"],
    media_type: "video",
    sender_number: "0000000000",
    language: "en"
  },
  %{
    media_urls: ["temp/audio-03.mp4"],
    media_type: "audio",
    sender_number: "0000000000",
    language: "en"
  },
  %{
    media_urls: ["temp/video-02.mp4"],
    media_type: "video",
    sender_number: "0000000000",
    language: "en"
  },
  %{
    media_urls: ["temp/audio-07.wav"],
    media_type: "audio",
    sender_number: "0000000000",
    language: "en"
  }
]
|> Enum.map(&Feed.add_to_common_feed/1)
