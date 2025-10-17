defmodule DAU.SlackPayloadFixtures do

  def all_payloads2() do
    [%{
      "test" => "Text on Main Channel",
      "api_app_id" => "A09DVQ7TY1F",
      "authorizations" => [
        %{
          "enterprise_id" => nil,
          "is_bot" => true,
          "is_enterprise_install" => false,
          "team_id" => "T09DGSRBZRC",
          "user_id" => "U09DH07QHHC"
        }
      ],
      "context_enterprise_id" => nil,
      "context_team_id" => "T09DGSRBZRC",
      "event" => %{
        "blocks" => [
          %{
            "block_id" => "ywk4G",
            "elements" => [
              %{
                "elements" => [%{"text" => "Text on Main thread", "type" => "text"}],
                "type" => "rich_text_section"
              }
            ],
            "type" => "rich_text"
          }
        ],
        "channel" => "C09DGSRHCKY",
        "channel_type" => "channel",
        "client_msg_id" => "63472ab6-203d-492c-be24-d2ef6c55cb07",
        "event_ts" => "1757316344.296449",
        "team" => "T09DGSRBZRC",
        "text" => "Text on Main thread",
        "ts" => "1757316344.296449",
        "type" => "message",
        "user" => "U09DDA47RT7"
      },
      "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
      "event_id" => "Ev09E5DD5W92",
      "event_time" => 1757316344,
      "is_ext_shared_channel" => false,
      "team_id" => "T09DGSRBZRC",
      "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
      "type" => "event_callback"
    }]

   end
  def all_payloads() do
# Contents

# Text on Main Channel
# Text Reply inisde a thread
# Text with multiple lines in main thread
# When a message in a thread is "also send to the channel"
# Only URL in the main channel
# URL with text in the main channel
# URL with normal text in a thread reply
# Image only (no text) on the main channel
# Image with some text on the main channel
# Multiple files (word and pdf) with some text
# some text then markdown and highlighted code  text section
# Edited above message and added extra text below markdown
# Text and then edit the text (2 payloads)
# Simple Delete (2 Payloads)
# Send a file and then delete it (multiple payloads)
# Send message, then start a thread, then delete the original message (multiple payloads)
# Sending files and then in edit, add some extra text. (files cannot be delted in edit, they have to be deleted directly)
# message in main, then a 2-3 new thread message, delete thread message, then delete main message and then delete thread message again (9 payloads)
#--------------------------------------------------------------------------------------------------
[

# Text on Main Channel
%{
  "test" => "Text on Main Channel",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "blocks" => [
      %{
        "block_id" => "ywk4G",
        "elements" => [
          %{
            "elements" => [%{"text" => "Text on Main thread", "type" => "text"}],
            "type" => "rich_text_section"
          }
        ],
        "type" => "rich_text"
      }
    ],
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "client_msg_id" => "63472ab6-203d-492c-be24-d2ef6c55cb07",
    "event_ts" => "1757316344.296449",
    "team" => "T09DGSRBZRC",
    "text" => "Text on Main thread",
    "ts" => "1757316344.296449",
    "type" => "message",
    "user" => "U09DDA47RT7"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09E5DD5W92",
  "event_time" => 1757316344,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},
# --------------------------------------------------------------------------------------------------------------------------------------------------------
# Text Reply inisde a thread
%{
  "test" => "Reply inside a thread (thread of above testcase main message)",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "blocks" => [
      %{
        "block_id" => "FjLgI",
        "elements" => [
          %{
            "elements" => [
              %{"text" => "Reply to a text in main thread", "type" => "text"}
            ],
            "type" => "rich_text_section"
          }
        ],
        "type" => "rich_text"
      }
    ],
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "client_msg_id" => "8fdd75ba-f90f-450e-9ae2-de7db3c3467c",
    "event_ts" => "1757316408.171889",
    "parent_user_id" => "U09DDA47RT7",
    "team" => "T09DGSRBZRC",
    "text" => "Reply to a text in main thread",
    "thread_ts" => "1757316344.296449",
    "ts" => "1757316408.171889",
    "type" => "message",
    "user" => "U09DDA47RT7"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09DX350LCB",
  "event_time" => 1757316408,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},
#---------------------------------------------------------------------------------------------------------
# Text with multiple lines in main thread

%{
  "test" => "multi-line text on main channel",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "blocks" => [
      %{
        "block_id" => "XaPLU",
        "elements" => [
          %{
            "elements" => [
              %{
                "text" => "some text\nother text in new line\nsome other text\n\n\ntext after a few new lines",
                "type" => "text"
              }
            ],
            "type" => "rich_text_section"
          }
        ],
        "type" => "rich_text"
      }
    ],
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "client_msg_id" => "2e42e470-f73e-442b-b7a6-728cf5d88331",
    "event_ts" => "1758264705.997829",
    "team" => "T09DGSRBZRC",
    "text" => "some text\nother text in new line\nsome other text\n\n\ntext after a few new lines",
    "ts" => "1758264705.997829",
    "type" => "message",
    "user" => "U09DDA47RT7"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09GVQH6BPS",
  "event_time" => 1758264705,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},
#-----------------------------------------------------------------------------------------------------------------------------------------------------
# When a message in a thread is "also send to the channel"

%{
  "test" => " When Thread message is `Also send to the Channel`",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "event_ts" => "1757316466.000200",
    "hidden" => true,
    "message" => %{
      "blocks" => [
        %{
          "block_id" => "FjLgI",
          "elements" => [
            %{
              "elements" => [
                %{"text" => "Reply to a text in main thread", "type" => "text"}
              ],
              "type" => "rich_text_section"
            }
          ],
          "type" => "rich_text"
        }
      ],
      "client_msg_id" => "8fdd75ba-f90f-450e-9ae2-de7db3c3467c",
      "root" => %{
        "blocks" => [
          %{
            "block_id" => "ywk4G",
            "elements" => [
              %{
                "elements" => [
                  %{"text" => "Text on Main thread", "type" => "text"}
                ],
                "type" => "rich_text_section"
              }
            ],
            "type" => "rich_text"
          }
        ],
        "client_msg_id" => "63472ab6-203d-492c-be24-d2ef6c55cb07",
        "is_locked" => false,
        "latest_reply" => "1757316408.171889",
        "reply_count" => 1,
        "reply_users" => ["U09DDA47RT7"],
        "reply_users_count" => 1,
        "team" => "T09DGSRBZRC",
        "text" => "Text on Main thread",
        "thread_ts" => "1757316344.296449",
        "ts" => "1757316344.296449",
        "type" => "message",
        "user" => "U09DDA47RT7"
      },
      "source_team" => "T09DGSRBZRC",
      "subtype" => "thread_broadcast",
      "text" => "Reply to a text in main thread",
      "thread_ts" => "1757316344.296449",
      "ts" => "1757316408.171889",
      "type" => "message",
      "user" => "U09DDA47RT7",
      "user_team" => "T09DGSRBZRC"
    },
    "previous_message" => %{
      "blocks" => [
        %{
          "block_id" => "FjLgI",
          "elements" => [
            %{
              "elements" => [
                %{"text" => "Reply to a text in main thread", "type" => "text"}
              ],
              "type" => "rich_text_section"
            }
          ],
          "type" => "rich_text"
        }
      ],
      "client_msg_id" => "8fdd75ba-f90f-450e-9ae2-de7db3c3467c",
      "parent_user_id" => "U09DDA47RT7",
      "team" => "T09DGSRBZRC",
      "text" => "Reply to a text in main thread",
      "thread_ts" => "1757316344.296449",
      "ts" => "1757316408.171889",
      "type" => "message",
      "user" => "U09DDA47RT7"
    },
    "subtype" => "message_changed",
    "ts" => "1757316466.000200",
    "type" => "message"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09DZ0K7REZ",
  "event_time" => 1757316466,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},
# -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Only URL in the main channel
%{
  "test" => "Only URL on Main Channel",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "blocks" => [
      %{
        "block_id" => "Ev9T8",
        "elements" => [
          %{
            "elements" => [%{"type" => "link", "url" => "https://github.com"}],
            "type" => "rich_text_section"
          }
        ],
        "type" => "rich_text"
      }
    ],
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "client_msg_id" => "a632ecc3-a780-4fcd-9a8b-de49f3c4a3da",
    "event_ts" => "1757316623.562379",
    "team" => "T09DGSRBZRC",
    "text" => "<https://github.com>",
    "ts" => "1757316623.562379",
    "type" => "message",
    "user" => "U09DDA47RT7"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09E1ER803Y",
  "event_time" => 1757316623,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# URL with text in the main channel
%{
  "test" => "URL with text",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "blocks" => [
      %{
        "block_id" => "Q5RZa",
        "elements" => [
          %{
            "elements" => [
              %{"text" => "URL with normal text: ", "type" => "text"},
              %{"type" => "link", "url" => "https://github.com"}
            ],
            "type" => "rich_text_section"
          }
        ],
        "type" => "rich_text"
      }
    ],
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "client_msg_id" => "de91f9ae-94a8-4426-933f-ee5534dae965",
    "event_ts" => "1757316689.092789",
    "team" => "T09DGSRBZRC",
    "text" => "URL with normal text: <https://github.com>",
    "ts" => "1757316689.092789",
    "type" => "message",
    "user" => "U09DDA47RT7"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09DX3XRXGB",
  "event_time" => 1757316689,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},

#-------------------------------------------------------------------------------------------------------------------------------------------
# URL with text in main channel with text after URL
# %{
#   "api_app_id" => "A09DVQ7TY1F",
#   "authorizations" => [
#     %{
#       "enterprise_id" => nil,
#       "is_bot" => true,
#       "is_enterprise_install" => false,
#       "team_id" => "T09DGSRBZRC",
#       "user_id" => "U09DH07QHHC"
#     }
#   ],
#   "context_enterprise_id" => nil,
#   "context_team_id" => "T09DGSRBZRC",
#   "event" => %{
#     "blocks" => [
#       %{
#         "block_id" => "SP76j",
#         "elements" => [
#           %{
#             "elements" => [
#               %{"text" => "Url with normal text: ", "type" => "text"},
#               %{"type" => "link", "url" => "https://github.com"},
#               %{"text" => " with text after url", "type" => "text"}
#             ],
#             "type" => "rich_text_section"
#           }
#         ],
#         "type" => "rich_text"
#       }
#     ],
#     "channel" => "C09DGSRHCKY",
#     "channel_type" => "channel",
#     "client_msg_id" => "d45d1013-078f-450a-8b6f-cfa316080548",
#     "event_ts" => "1757316884.711119",
#     "team" => "T09DGSRBZRC",
#     "text" => "Url with normal text: <https://github.com> with text after url",
#     "ts" => "1757316884.711119",
#     "type" => "message",
#     "user" => "U09DDA47RT7"
#   },
#   "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
#   "event_id" => "Ev09E1FEBBJS",
#   "event_time" => 1757316884,
#   "is_ext_shared_channel" => false,
#   "team_id" => "T09DGSRBZRC",
#   "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
#   "type" => "event_callback"
# },
#--------------------------------------------------------------------------------------------------------------------------------------------
# URL with normal text in a thread reply
%{
  "test" => "URL with text on thread",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "blocks" => [
      %{
        "block_id" => "OoYo+",
        "elements" => [
          %{
            "elements" => [
              %{
                "text" => "URL with normal text in a thread reply: ",
                "type" => "text"
              },
              %{"type" => "link", "url" => "https://github.com"}
            ],
            "type" => "rich_text_section"
          }
        ],
        "type" => "rich_text"
      }
    ],
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "client_msg_id" => "8ace1971-097c-43cc-b8fc-a4b86f9c8116",
    "event_ts" => "1757316761.149369",
    "parent_user_id" => "U09DDA47RT7",
    "team" => "T09DGSRBZRC",
    "text" => "URL with normal text in a thread reply: <https://github.com>",
    "thread_ts" => "1757316689.092789",
    "ts" => "1757316761.149369",
    "type" => "message",
    "user" => "U09DDA47RT7"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09E1F4ES5C",
  "event_time" => 1757316761,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},
#------------------------------------------------------------------------------------------------------------------------
# Image only (no text) on the main channel
%{
  "test" => "Image only no text on Main Channel",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "client_msg_id" => "c2fd2227-6c26-445b-a6aa-cf817f332573",
    "display_as_bot" => false,
    "event_ts" => "1757317203.790789",
    "files" => [
      %{
        "timestamp" => 1757317196,
        "external_type" => "",
        "mimetype" => "image/png",
        "title" => "Screenshot from 2024-11-25 10-36-55.png",
        "original_w" => 101,
        "id" => "F09E1G9PEMQ",
        "user_team" => "T09DGSRBZRC",
        "permalink_public" => "https://slack-files.com/T09DGSRBZRC-F09E1G9PEMQ-0cb6099cce",
        "user" => "U09DDA47RT7",
        "thumb_64" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09E1G9PEMQ-dc015a54fa/screenshot_from_2024-11-25_10-36-55_64.png",
        "editable" => false,
        "pretty_type" => "PNG",
        "file_access" => "visible",
        "created" => 1757317196,
        "thumb_360" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09E1G9PEMQ-dc015a54fa/screenshot_from_2024-11-25_10-36-55_360.png",
        "thumb_360_h" => 91,
        "thumb_160" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09E1G9PEMQ-dc015a54fa/screenshot_from_2024-11-25_10-36-55_160.png",
        "is_public" => true,
        "original_h" => 91,
        "filetype" => "png",
        "thumb_tiny" => "AwAsADB9ISAMmioXbcfapSubylYeZR2GaBKO4qMLkZJwKXaCPlOfarsjPmkTAgjIparqxU5qcHIzUSVi4yuI/CGoQuRknAqdhlSKgBGNrVUdiZ7ikEhQPSlUbWXnn0pMZxhhxRtIPLAGmLzE28Eg9OoqWL7lR5ABxyT3qVBhBSlsOG46o5I88ipKKhOxo1crd6dJ981MQD1FGKvmI5CNI+ct+VS0UVLdykrH/9k=",
        "skipped_shares" => true,
        "mode" => "hosted",
        "thumb_360_w" => 101,
        "size" => 5091,
        "username" => "",
        "url_private_download" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09E1G9PEMQ/download/screenshot_from_2024-11-25_10-36-55.png",
        "public_url_shared" => false,
        "display_as_bot" => false,
        "has_rich_preview" => false,
        "thumb_80" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09E1G9PEMQ-dc015a54fa/screenshot_from_2024-11-25_10-36-55_80.png",
        "permalink" => "https://dau-testworkspace.slack.com/files/U09DDA47RT7/F09E1G9PEMQ/screenshot_from_2024-11-25_10-36-55.png",
        "url_private" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09E1G9PEMQ/screenshot_from_2024-11-25_10-36-55.png",
        "media_display_type" => "unknown",
        "name" => "Screenshot from 2024-11-25 10-36-55.png",
        "is_external" => false
      }
    ],
    "subtype" => "file_share",
    "text" => "",
    "ts" => "1757317203.790789",
    "type" => "message",
    "upload" => false,
    "user" => "U09DDA47RT7"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09E1G6CNSJ",
  "event_time" => 1757317203,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
# Image with some text on the main channel
%{
  "test" => "Image with some text",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "blocks" => [
      %{
        "block_id" => "hcaPh",
        "elements" => [
          %{
            "elements" => [
              %{
                "text" => "Image with some text in the main channel",
                "type" => "text"
              }
            ],
            "type" => "rich_text_section"
          }
        ],
        "type" => "rich_text"
      }
    ],
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "client_msg_id" => "2dce7da3-2099-4ef5-a9ba-1a37e0abf5d9",
    "display_as_bot" => false,
    "event_ts" => "1757317296.458959",
    "files" => [
      %{
        "timestamp" => 1757317287,
        "external_type" => "",
        "mimetype" => "image/png",
        "title" => "Screenshot from 2024-11-25 10-36-55.png",
        "original_w" => 101,
        "id" => "F09DX5DNWGK",
        "user_team" => "T09DGSRBZRC",
        "permalink_public" => "https://slack-files.com/T09DGSRBZRC-F09DX5DNWGK-2ecd4a7358",
        "user" => "U09DDA47RT7",
        "thumb_64" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09DX5DNWGK-8563a493a1/screenshot_from_2024-11-25_10-36-55_64.png",
        "editable" => false,
        "pretty_type" => "PNG",
        "file_access" => "visible",
        "created" => 1757317287,
        "thumb_360" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09DX5DNWGK-8563a493a1/screenshot_from_2024-11-25_10-36-55_360.png",
        "thumb_360_h" => 91,
        "thumb_160" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09DX5DNWGK-8563a493a1/screenshot_from_2024-11-25_10-36-55_160.png",
        "is_public" => true,
        "original_h" => 91,
        "filetype" => "png",
        "thumb_tiny" => "AwAsADB9ISAMmioXbcfapSubylYeZR2GaBKO4qMLkZJwKXaCPlOfarsjPmkTAgjIparqxU5qcHIzUSVi4yuI/CGoQuRknAqdhlSKgBGNrVUdiZ7ikEhQPSlUbWXnn0pMZxhhxRtIPLAGmLzE28Eg9OoqWL7lR5ABxyT3qVBhBSlsOG46o5I88ipKKhOxo1crd6dJ981MQD1FGKvmI5CNI+ct+VS0UVLdykrH/9k=",
        "skipped_shares" => true,
        "mode" => "hosted",
        "thumb_360_w" => 101,
        "size" => 5091,
        "username" => "",
        "url_private_download" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09DX5DNWGK/download/screenshot_from_2024-11-25_10-36-55.png",
        "public_url_shared" => false,
        "display_as_bot" => false,
        "has_rich_preview" => false,
        "thumb_80" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09DX5DNWGK-8563a493a1/screenshot_from_2024-11-25_10-36-55_80.png",
        "permalink" => "https://dau-testworkspace.slack.com/files/U09DDA47RT7/F09DX5DNWGK/screenshot_from_2024-11-25_10-36-55.png",
        "url_private" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09DX5DNWGK/screenshot_from_2024-11-25_10-36-55.png",
        "media_display_type" => "unknown",
        "name" => "Screenshot from 2024-11-25 10-36-55.png",
        "is_external" => false
      }
    ],
    "subtype" => "file_share",
    "text" => "Image with some text in the main channel",
    "ts" => "1757317296.458959",
    "type" => "message",
    "upload" => false,
    "user" => "U09DDA47RT7"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09DLHXSBRD",
  "event_time" => 1757317296,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},
#--------------------------------------------------------------------------------------------------------------------------------------------
# Image with some text and multiple URLs
# %{
#    "test" => "IMage with some text and URLs",
#   "api_app_id" => "A09DVQ7TY1F",
#   "authorizations" => [
#     %{
#       "enterprise_id" => nil,
#       "is_bot" => true,
#       "is_enterprise_install" => false,
#       "team_id" => "T09DGSRBZRC",
#       "user_id" => "U09DH07QHHC"
#     }
#   ],
#   "context_enterprise_id" => nil,
#   "context_team_id" => "T09DGSRBZRC",
#   "event" => %{
#     "blocks" => [
#       %{
#         "block_id" => "VcyF/",
#         "elements" => [
#           %{
#             "elements" => [
#               %{"text" => "Image with some text and ", "type" => "text"},
#               %{"type" => "link", "url" => "https://github.com"},
#               %{"text" => " ", "type" => "text"},
#               %{"type" => "link", "url" => "https://google.com"},
#               %{"text" => " multiple urls", "type" => "text"}
#             ],
#             "type" => "rich_text_section"
#           }
#         ],
#         "type" => "rich_text"
#       }
#     ],
#     "channel" => "C09DGSRHCKY",
#     "channel_type" => "channel",
#     "client_msg_id" => "ce534cf0-375a-45e8-a8e3-8aced17785fa",
#     "display_as_bot" => false,
#     "event_ts" => "1757317984.878549",
#     "files" => [
#       %{
#         "timestamp" => 1757317974,
#         "external_type" => "",
#         "mimetype" => "image/png",
#         "title" => "Screenshot from 2024-11-25 10-36-55.png",
#         "original_w" => 101,
#         "id" => "F09E5H8Q7NY",
#         "user_team" => "T09DGSRBZRC",
#         "permalink_public" => "https://slack-files.com/T09DGSRBZRC-F09E5H8Q7NY-6ea4445e8a",
#         "user" => "U09DDA47RT7",
#         "thumb_64" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09E5H8Q7NY-08005f257e/screenshot_from_2024-11-25_10-36-55_64.png",
#         "editable" => false,
#         "pretty_type" => "PNG",
#         "file_access" => "visible",
#         "created" => 1757317974,
#         "thumb_360" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09E5H8Q7NY-08005f257e/screenshot_from_2024-11-25_10-36-55_360.png",
#         "thumb_360_h" => 91,
#         "thumb_160" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09E5H8Q7NY-08005f257e/screenshot_from_2024-11-25_10-36-55_160.png",
#         "is_public" => true,
#         "original_h" => 91,
#         "filetype" => "png",
#         "thumb_tiny" => "AwAsADB9ISAMmioXbcfapSubylYeZR2GaBKO4qMLkZJwKXaCPlOfarsjPmkTAgjIparqxU5qcHIzUSVi4yuI/CGoQuRknAqdhlSKgBGNrVUdiZ7ikEhQPSlUbWXnn0pMZxhhxRtIPLAGmLzE28Eg9OoqWL7lR5ABxyT3qVBhBSlsOG46o5I88ipKKhOxo1crd6dJ981MQD1FGKvmI5CNI+ct+VS0UVLdykrH/9k=",
#         "skipped_shares" => true,
#         "mode" => "hosted",
#         "thumb_360_w" => 101,
#         "size" => 5091,
#         "username" => "",
#         "url_private_download" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09E5H8Q7NY/download/screenshot_from_2024-11-25_10-36-55.png",
#         "public_url_shared" => false,
#         "display_as_bot" => false,
#         "has_rich_preview" => false,
#         "thumb_80" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09E5H8Q7NY-08005f257e/screenshot_from_2024-11-25_10-36-55_80.png",
#         "permalink" => "https://dau-testworkspace.slack.com/files/U09DDA47RT7/F09E5H8Q7NY/screenshot_from_2024-11-25_10-36-55.png",
#         "url_private" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09E5H8Q7NY/screenshot_from_2024-11-25_10-36-55.png",
#         "media_display_type" => "unknown",
#         "name" => "Screenshot from 2024-11-25 10-36-55.png",
#         "is_external" => false
#       }
#     ],
#     "subtype" => "file_share",
#     "text" => "Image with some text and <https://github.com> <https://google.com> multiple urls",
#     "ts" => "1757317984.878549",
#     "type" => "message",
#     "upload" => false,
#     "user" => "U09DDA47RT7"
#   },
#   "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
#   "event_id" => "Ev09E5HABQDS",
#   "event_time" => 1757317984,
#   "is_ext_shared_channel" => false,
#   "team_id" => "T09DGSRBZRC",
#   "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
#   "type" => "event_callback"
# },
#-------------------------------------------------------------------------------------------------------------------------------------------
# Multiple files (word and pdf) with some text
%{
  "test" => "Multiple files with some text",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "blocks" => [
      %{
        "block_id" => "5lTXh",
        "elements" => [
          %{
            "elements" => [
              %{"text" => "multiple files with some text", "type" => "text"}
            ],
            "type" => "rich_text_section"
          }
        ],
        "type" => "rich_text"
      }
    ],
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "client_msg_id" => "ad6b3ba9-6f02-440e-a92f-8a108a7da7bd",
    "event_ts" => "1757318416.450689",
    "files" => [
      %{
        "converted_pdf" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09DZ5E6GHK-04ae4e0443/test_file_converted.pdf",
        "created" => 1757318400,
        "display_as_bot" => false,
        "editable" => false,
        "external_type" => "",
        "file_access" => "visible",
        "filetype" => "odt",
        "has_rich_preview" => false,
        "id" => "F09DZ5E6GHK",
        "is_external" => false,
        "is_public" => true,
        "media_display_type" => "unknown",
        "mimetype" => "application/vnd.oasis.opendocument.text",
        "mode" => "hosted",
        "name" => "test file.odt",
        "permalink" => "https://dau-testworkspace.slack.com/files/U09DDA47RT7/F09DZ5E6GHK/test_file.odt",
        "permalink_public" => "https://slack-files.com/T09DGSRBZRC-F09DZ5E6GHK-97df4f0989",
        "pretty_type" => "OpenDocument Text",
        "public_url_shared" => false,
        "size" => 9449,
        "skipped_shares" => true,
        "thumb_pdf" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09DZ5E6GHK-04ae4e0443/test_file_thumb_pdf.png",
        "thumb_pdf_h" => 1286,
        "thumb_pdf_w" => 909,
        "timestamp" => 1757318400,
        "title" => "test file.odt",
        "url_private" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09DZ5E6GHK/test_file.odt",
        "url_private_download" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09DZ5E6GHK/download/test_file.odt",
        "user" => "U09DDA47RT7",
        "user_team" => "T09DGSRBZRC",
        "username" => ""
      },
      %{
        "created" => 1757318405,
        "display_as_bot" => false,
        "editable" => false,
        "external_type" => "",
        "file_access" => "visible",
        "filetype" => "pdf",
        "has_rich_preview" => false,
        "id" => "F09EEUD3M4Z",
        "is_external" => false,
        "is_public" => true,
        "media_display_type" => "unknown",
        "mimetype" => "application/pdf",
        "mode" => "hosted",
        "name" => "test file.pdf",
        "permalink" => "https://dau-testworkspace.slack.com/files/U09DDA47RT7/F09EEUD3M4Z/test_file.pdf",
        "permalink_public" => "https://slack-files.com/T09DGSRBZRC-F09EEUD3M4Z-d693dd42e2",
        "pretty_type" => "PDF",
        "public_url_shared" => false,
        "size" => 7771,
        "skipped_shares" => true,
        "thumb_pdf" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09EEUD3M4Z-1f3e7a7dce/test_file_thumb_pdf.png",
        "thumb_pdf_h" => 1286,
        "thumb_pdf_w" => 909,
        "timestamp" => 1757318405,
        "title" => "test file.pdf",
        "url_private" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09EEUD3M4Z/test_file.pdf",
        "url_private_download" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09EEUD3M4Z/download/test_file.pdf",
        "user" => "U09DDA47RT7",
        "user_team" => "T09DGSRBZRC",
        "username" => ""
      },
      %{
        "converted_pdf" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09DLLWQQR5-7b1d9b8dc3/test_file_converted.pdf",
        "created" => 1757318408,
        "display_as_bot" => false,
        "editable" => false,
        "external_type" => "",
        "file_access" => "visible",
        "filetype" => "docx",
        "has_rich_preview" => false,
        "id" => "F09DLLWQQR5",
        "is_external" => false,
        "is_public" => true,
        "media_display_type" => "unknown",
        "mimetype" => "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        "mode" => "hosted",
        "name" => "test file.docx",
        "permalink" => "https://dau-testworkspace.slack.com/files/U09DDA47RT7/F09DLLWQQR5/test_file.docx",
        "permalink_public" => "https://slack-files.com/T09DGSRBZRC-F09DLLWQQR5-ffdabe7c4f",
        "pretty_type" => "Word Document",
        "public_url_shared" => false,
        "size" => 4995,
        "skipped_shares" => true,
        "thumb_pdf" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09DLLWQQR5-7b1d9b8dc3/test_file_thumb_pdf.png",
        "thumb_pdf_h" => 1286,
        "thumb_pdf_w" => 909,
        "timestamp" => 1757318408,
        "title" => "test file.docx",
        "url_private" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09DLLWQQR5/test_file.docx",
        "url_private_download" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09DLLWQQR5/download/test_file.docx",
        "user" => "U09DDA47RT7",
        "user_team" => "T09DGSRBZRC",
        "username" => ""
      }
    ],
    "subtype" => "file_share",
    "text" => "multiple files with some text",
    "ts" => "1757318416.450689",
    "type" => "message",
    "upload" => false,
    "user" => "U09DDA47RT7"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09DLLZ1823",
  "event_time" => 1757318416,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},
# ----------------------------------------------------------------------------------------------------------------------------------------------------
# some text then markdown and highlighted code  text section
%{
  "test" => "some text then markdown and highlighted code  text section",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "blocks" => [
      %{
        "block_id" => "jJ7tF",
        "elements" => [
          %{
            "elements" => [
              %{
                "text" => "some text then markdown and highlighted ",
                "type" => "text"
              },
              %{
                "style" => %{"code" => true},
                "text" => "code",
                "type" => "text"
              },
              %{"text" => "  text section\n", "type" => "text"}
            ],
            "type" => "rich_text_section"
          },
          %{
            "border" => 0,
            "elements" => [
              %{"text" => "Markdown text\nasdffgasdf", "type" => "text"}
            ],
            "type" => "rich_text_preformatted"
          }
        ],
        "type" => "rich_text"
      }
    ],
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "client_msg_id" => "3e42630a-eb1c-4b54-8c7b-628177bef137",
    "event_ts" => "1757319011.706299",
    "team" => "T09DGSRBZRC",
    "text" => "some text then markdown and highlighted `code`  text section\n```Markdown text\nasdffgasdf```",
    "ts" => "1757319011.706299",
    "type" => "message",
    "user" => "U09DDA47RT7"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09DLNU5P9V",
  "event_time" => 1757319011,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},
#-----------------------------------------------------------------------------------------------------------------------------------------
# Edited above message and added extra text below markdown
%{
  "test" => "edit above testcase text",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "event_ts" => "1757319138.001600",
    "hidden" => true,
    "message" => %{
      "blocks" => [
        %{
          "block_id" => "qScAX",
          "elements" => [
            %{
              "elements" => [
                %{
                  "text" => "some text then markdown and highlighted ",
                  "type" => "text"
                },
                %{
                  "style" => %{"code" => true},
                  "text" => "code",
                  "type" => "text"
                },
                %{"text" => "  text section\n", "type" => "text"}
              ],
              "type" => "rich_text_section"
            },
            %{
              "border" => 0,
              "elements" => [
                %{"text" => "Markdown text\nasdffgasdf", "type" => "text"}
              ],
              "type" => "rich_text_preformatted"
            },
            %{
              "elements" => [
                %{
                  "text" => "added some extra text below the markdown in the edit",
                  "type" => "text"
                }
              ],
              "type" => "rich_text_section"
            }
          ],
          "type" => "rich_text"
        }
      ],
      "client_msg_id" => "3e42630a-eb1c-4b54-8c7b-628177bef137",
      "edited" => %{"ts" => "1757319138.000000", "user" => "U09DDA47RT7"},
      "source_team" => "T09DGSRBZRC",
      "team" => "T09DGSRBZRC",
      "text" => "some text then markdown and highlighted `code`  text section\n```Markdown text\nasdffgasdf```\nadded some extra text below the markdown in the edit",
      "ts" => "1757319011.706299",
      "type" => "message",
      "user" => "U09DDA47RT7",
      "user_team" => "T09DGSRBZRC"
    },
    "previous_message" => %{
      "blocks" => [
        %{
          "block_id" => "jJ7tF",
          "elements" => [
            %{
              "elements" => [
                %{
                  "text" => "some text then markdown and highlighted ",
                  "type" => "text"
                },
                %{
                  "style" => %{"code" => true},
                  "text" => "code",
                  "type" => "text"
                },
                %{"text" => "  text section\n", "type" => "text"}
              ],
              "type" => "rich_text_section"
            },
            %{
              "border" => 0,
              "elements" => [
                %{"text" => "Markdown text\nasdffgasdf", "type" => "text"}
              ],
              "type" => "rich_text_preformatted"
            }
          ],
          "type" => "rich_text"
        }
      ],
      "client_msg_id" => "3e42630a-eb1c-4b54-8c7b-628177bef137",
      "team" => "T09DGSRBZRC",
      "text" => "some text then markdown and highlighted `code`  text section\n```Markdown text\nasdffgasdf```",
      "ts" => "1757319011.706299",
      "type" => "message",
      "user" => "U09DDA47RT7"
    },
    "subtype" => "message_changed",
    "ts" => "1757319138.001600",
    "type" => "message"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09E1MWD5PC",
  "event_time" => 1757319138,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},
#----------------------------------------------------------------------------------------------------------------------------------
# Text and then edit the text (2 payloads)
%{
  "test" => "send text and then edit: original message",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "blocks" => [
      %{
        "block_id" => "oVQ+A",
        "elements" => [
          %{
            "elements" => [%{"text" => "some text", "type" => "text"}],
            "type" => "rich_text_section"
          }
        ],
        "type" => "rich_text"
      }
    ],
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "client_msg_id" => "8f343bbe-5aff-4f73-a497-309875cfbd53",
    "event_ts" => "1757319664.881129",
    "team" => "T09DGSRBZRC",
    "text" => "some text",
    "ts" => "1757319664.881129",
    "type" => "message",
    "user" => "U09DDA47RT7"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09DXBWE8TD",
  "event_time" => 1757319664,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},
# After Edit
%{
  "test" => "send text and then edit: edited message",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "event_ts" => "1757319675.001900",
    "hidden" => true,
    "message" => %{
      "blocks" => [
        %{
          "block_id" => "5xdCQ",
          "elements" => [
            %{
              "elements" => [%{"text" => "some text Edited", "type" => "text"}],
              "type" => "rich_text_section"
            }
          ],
          "type" => "rich_text"
        }
      ],
      "client_msg_id" => "8f343bbe-5aff-4f73-a497-309875cfbd53",
      "edited" => %{"ts" => "1757319675.000000", "user" => "U09DDA47RT7"},
      "source_team" => "T09DGSRBZRC",
      "team" => "T09DGSRBZRC",
      "text" => "some text Edited",
      "ts" => "1757319664.881129",
      "type" => "message",
      "user" => "U09DDA47RT7",
      "user_team" => "T09DGSRBZRC"
    },
    "previous_message" => %{
      "blocks" => [
        %{
          "block_id" => "oVQ+A",
          "elements" => [
            %{
              "elements" => [%{"text" => "some text", "type" => "text"}],
              "type" => "rich_text_section"
            }
          ],
          "type" => "rich_text"
        }
      ],
      "client_msg_id" => "8f343bbe-5aff-4f73-a497-309875cfbd53",
      "team" => "T09DGSRBZRC",
      "text" => "some text",
      "ts" => "1757319664.881129",
      "type" => "message",
      "user" => "U09DDA47RT7"
    },
    "subtype" => "message_changed",
    "ts" => "1757319675.001900",
    "type" => "message"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09DZ8XHM5K",
  "event_time" => 1757319675,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},
# ------------------------------------------------------------------------------------------------------------------
# Simple Delete (2 Payloads)
# Text on main channel
%{
  "test" => "send text and then delete: original message",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "blocks" => [
      %{
        "block_id" => "UxtZ4",
        "elements" => [
          %{
            "elements" => [
              %{"text" => "Testing simple delete", "type" => "text"}
            ],
            "type" => "rich_text_section"
          }
        ],
        "type" => "rich_text"
      }
    ],
    "channel" => "C09HA4QCTD0",
    "channel_type" => "channel",
    "client_msg_id" => "ac2246ef-f5c1-4726-9d40-f20461985fb1",
    "event_ts" => "1759550703.569189",
    "team" => "T09DGSRBZRC",
    "text" => "Testing simple delete",
    "ts" => "1759550703.569189",
    "type" => "message",
    "user" => "U09DDA47RT7"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5SEE0UUNURDAifQ",
  "event_id" => "Ev09KJJHUXA4",
  "event_time" => 1759550703,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},
#---------
# Delete above message
%{
  "test" => "send text and then delete: deleted message",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "channel" => "C09HA4QCTD0",
    "channel_type" => "channel",
    "deleted_ts" => "1759550703.569189",
    "event_ts" => "1759551075.000100",
    "hidden" => true,
    "previous_message" => %{
      "blocks" => [
        %{
          "block_id" => "UxtZ4",
          "elements" => [
            %{
              "elements" => [
                %{"text" => "Testing simple delete", "type" => "text"}
              ],
              "type" => "rich_text_section"
            }
          ],
          "type" => "rich_text"
        }
      ],
      "client_msg_id" => "ac2246ef-f5c1-4726-9d40-f20461985fb1",
      "team" => "T09DGSRBZRC",
      "text" => "Testing simple delete",
      "ts" => "1759550703.569189",
      "type" => "message",
      "user" => "U09DDA47RT7"
    },
    "subtype" => "message_deleted",
    "ts" => "1759551075.000100",
    "type" => "message"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5SEE0UUNURDAifQ",
  "event_id" => "Ev09KJJVPD32",
  "event_time" => 1759551075,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},
#-------------------------------------------------------------------------------------------------------------------
# Send a file and then delete it (multiple payloads)
%{
  "test" => "send a file and then delete: original message",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "client_msg_id" => "e720025d-3d1e-4e27-a794-55c55b873fdd",
    "display_as_bot" => false,
    "event_ts" => "1758519464.871559",
    "files" => [
      %{
        "timestamp" => 1758519455,
        "external_type" => "",
        "mimetype" => "video/webm",
        "title" => "check text.webm",
        "thumb_video" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09GJEU0FB6-53ff5b0d02/check_text_thumb_video.jpeg",
        "duration_ms" => 21721,
        "id" => "F09GJEU0FB6",
        "thumb_video_h" => 1440,
        "user_team" => "T09DGSRBZRC",
        "permalink_public" => "https://slack-files.com/T09DGSRBZRC-F09GJEU0FB6-c1a6301376",
        "user" => "U09DDA47RT7",
        "editable" => false,
        "pretty_type" => "WebM",
        "file_access" => "visible",
        "created" => 1758519455,
        "is_public" => true,
        "filetype" => "webm",
        "thumb_video_w" => 2560,
        "skipped_shares" => true,
        "mode" => "hosted",
        "size" => 2551772,
        "transcription" => %{"status" => "fatal"},
        "username" => "",
        "url_private_download" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09GJEU0FB6/download/check_text.webm",
        "public_url_shared" => false,
        "display_as_bot" => false,
        "has_rich_preview" => false,
        "mp4_low" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09GJEU0FB6-53ff5b0d02/file_trans.mp4",
        "permalink" => "https://dau-testworkspace.slack.com/files/U09DDA47RT7/F09GJEU0FB6/check_text.webm",
        "url_private" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09GJEU0FB6/check_text.webm",
        "media_display_type" => "video",
        "name" => "check text.webm",
        "is_external" => false
      }
    ],
    "subtype" => "file_share",
    "text" => "",
    "ts" => "1758519464.871559",
    "type" => "message",
    "upload" => false,
    "user" => "U09DDA47RT7"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09GSTDGL3B",
  "event_time" => 1758519464,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},
#------------Payload after Deleting the Above text
%{
  "test" => "send file and then delete: deleted file",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "deleted_ts" => "1758519464.871559",
    "event_ts" => "1758519516.000800",
    "hidden" => true,
    "previous_message" => %{
      "client_msg_id" => "e720025d-3d1e-4e27-a794-55c55b873fdd",
      "display_as_bot" => false,
      "files" => [
        %{
          "timestamp" => 1758519455,
          "external_type" => "",
          "mimetype" => "video/webm",
          "title" => "check text.webm",
          "thumb_video" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09GJEU0FB6-53ff5b0d02/check_text_thumb_video.jpeg",
          "duration_ms" => 21721,
          "id" => "F09GJEU0FB6",
          "thumb_video_h" => 1440,
          "user_team" => "T09DGSRBZRC",
          "permalink_public" => "https://slack-files.com/T09DGSRBZRC-F09GJEU0FB6-c1a6301376",
          "user" => "U09DDA47RT7",
          "editable" => false,
          "hls_embed" => "data:application/vnd.apple.mpegurl;base64,I0VYVE0zVQojRVhULVgtVkVSU0lPTjozCiNFWFQtWC1JTkRFUEVOREVOVC1TRUdNRU5UUwojRVhULVgtU1RSRUFNLUlORjpCQU5EV0lEVEg9NjE3Nzc2LEFWRVJBR0UtQkFORFdJRFRIPTQ3OTM4MCxDT0RFQ1M9ImF2YzEuNjQwMDI4LG1wNGEuNDAuNSIsUkVTT0xVVElPTj0xOTIweDEwODAsRlJBTUUtUkFURT0yOS45NzAKZGF0YTphcHBsaWNhdGlvbi92bmQuYXBwbGUubXBlZ3VybDtiYXNlNjQsSTBWWVZFMHpWUW9qUlZoVUxWZ3RWa1ZTVTBsUFRqb3pDaU5GV0ZRdFdDMVVRVkpIUlZSRVZWSkJWRWxQVGpvM0NpTkZXRlF0V0MxTlJVUkpRUzFUUlZGVlJVNURSVG94Q2lORldGUXRXQzFRVEVGWlRFbFRWQzFVV1ZCRk9sWlBSQW9qUlZoVVNVNUdPall1TURBMkxBcG9kSFJ3Y3pvdkwyWnBiR1Z6TG5Oc1lXTnJMbU52YlM5bWFXeGxjeTEwYldJdlZEQTVSRWRUVWtKYVVrTXRSakE1UjBwRlZUQkdRall0TlRObVpqVmlNR1F3TWk5bWFXeGxYMGhmTWpZMFh6RTVNakI0TVRBNE1GODJOVEF3UzBKUVUxODNVVlpDVWw4d01EQXdNUzUwY3dvalJWaFVTVTVHT2pZdU1EQTJMQXBvZEhSd2N6b3ZMMlpwYkdWekxuTnNZV05yTG1OdmJTOW1hV3hsY3kxMGJXSXZWREE1UkVkVFVrSmFVa010UmpBNVIwcEZWVEJHUWpZdE5UTm1aalZpTUdRd01pOW1hV3hsWDBoZk1qWTBYekU1TWpCNE1UQTRNRjgyTlRBd1MwSlFVMTgzVVZaQ1VsOHdNREF3TWk1MGN3b2pSVmhVU1U1R09qWXVNREEyTEFwb2RIUndjem92TDJacGJHVnpMbk5zWVdOckxtTnZiUzltYVd4bGN5MTBiV0l2VkRBNVJFZFRVa0phVWtNdFJqQTVSMHBGVlRCR1FqWXROVE5tWmpWaU1HUXdNaTltYVd4bFgwaGZNalkwWHpFNU1qQjRNVEE0TUY4Mk5UQXdTMEpRVTE4M1VWWkNVbDh3TURBd015NTBjd29qUlZoVVNVNUdPak11TnpBMExBcG9kSFJ3Y3pvdkwyWnBiR1Z6TG5Oc1lXTnJMbU52YlM5bWFXeGxjeTEwYldJdlZEQTVSRWRUVWtKYVVrTXRSakE1UjBwRlZUQkdRall0TlRObVpqVmlNR1F3TWk5bWFXeGxYMGhmTWpZMFh6RTVNakI0TVRBNE1GODJOVEF3UzBKUVUxODNVVlpDVWw4d01EQXdOQzUwY3dvalJWaFVMVmd0UlU1RVRFbFRWQW89Cg==",
          "pretty_type" => "WebM",
          "file_access" => "visible",
          "created" => 1758519455,
          "is_public" => true,
          "is_starred" => false,
          "filetype" => "webm",
          "thumb_video_w" => 2560,
          "skipped_shares" => true,
          "mode" => "hosted",
          "size" => 2551772,
          "transcription" => %{"status" => "fatal"},
          "username" => "",
          "url_private_download" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09GJEU0FB6/download/check_text.webm",
          "public_url_shared" => false,
          "display_as_bot" => false,
          "has_rich_preview" => false,
          "mp4_low" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09GJEU0FB6-53ff5b0d02/file_trans.mp4",
          "permalink" => "https://dau-testworkspace.slack.com/files/U09DDA47RT7/F09GJEU0FB6/check_text.webm",
          "hls" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09GJEU0FB6-53ff5b0d02/file.m3u8?_xcb=f458e",
          "url_private" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09GJEU0FB6/check_text.webm",
          "media_display_type" => "video",
          "name" => "check text.webm",

        }
      ],
      "text" => "",
      "ts" => "1758519464.871559",
      "type" => "message",
      "upload" => false,
      "user" => "U09DDA47RT7"
    },
    "subtype" => "message_deleted",
    "ts" => "1758519516.000800",
    "type" => "message"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09GJEYE160",
  "event_time" => 1758519516,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},
#-----------------------------------------------------------------------------------------
# Send message, then start a thread, then delete the original message (multiple payloads)
#some text in the main
%{
  "test" => "Send message, then start a thread, then delete the original message: original message",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "blocks" => [
      %{
        "block_id" => "syrtK",
        "elements" => [
          %{
            "elements" => [
              %{"text" => "hello, testing deletion", "type" => "text"}
            ],
            "type" => "rich_text_section"
          }
        ],
        "type" => "rich_text"
      }
    ],
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "client_msg_id" => "5333356e-fa4e-4be9-9ccc-a270f0db01e5",
    "event_ts" => "1758551191.454739",
    "team" => "T09DGSRBZRC",
    "text" => "hello, testing deletion",
    "ts" => "1758551191.454739",
    "type" => "message",
    "user" => "U09DDA47RT7"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09GMDXMK9A",
  "event_time" => 1758551191,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},
#---------------------------------------- some message in the thread of the above message
%{
  "test" => "Send message, then start a thread, then delete the original message: start thread",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "blocks" => [
      %{
        "block_id" => "LQSKt",
        "elements" => [
          %{
            "elements" => [
              %{"text" => "thread inside testing deletion", "type" => "text"}
            ],
            "type" => "rich_text_section"
          }
        ],
        "type" => "rich_text"
      }
    ],
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "client_msg_id" => "977c25a1-b67d-430a-a40c-552df56b1280",
    "event_ts" => "1758551211.815439",
    "parent_user_id" => "U09DDA47RT7",
    "team" => "T09DGSRBZRC",
    "text" => "thread inside testing deletion",
    "thread_ts" => "1758551191.454739",
    "ts" => "1758551211.815439",
    "type" => "message",
    "user" => "U09DDA47RT7"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09HA7BSDB2",
  "event_time" => 1758551211,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},
#----------------------------------------- delete the main message
%{
  "test" => "Send message, then start a thread, then delete the original message: delete original message",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "event_ts" => "1758551224.001400",
    "hidden" => true,
    "message" => %{
      "hidden" => true,
      "is_locked" => false,
      "latest_reply" => "1758551211.815439",
      "reply_count" => 1,
      "reply_users" => ["U09DDA47RT7"],
      "reply_users_count" => 1,
      "subtype" => "tombstone",
      "text" => "This message was deleted.",
      "thread_ts" => "1758551191.454739",
      "ts" => "1758551191.454739",
      "type" => "message",
      "user" => "USLACKBOT"
    },
    "previous_message" => %{
      "blocks" => [
        %{
          "block_id" => "syrtK",
          "elements" => [
            %{
              "elements" => [
                %{"text" => "hello, testing deletion", "type" => "text"}
              ],
              "type" => "rich_text_section"
            }
          ],
          "type" => "rich_text"
        }
      ],
      "client_msg_id" => "5333356e-fa4e-4be9-9ccc-a270f0db01e5",
      "is_locked" => false,
      "last_read" => "1758551211.815439",
      "latest_reply" => "1758551211.815439",
      "reply_count" => 1,
      "reply_users" => ["U09DDA47RT7"],
      "reply_users_count" => 1,
      "subscribed" => true,
      "team" => "T09DGSRBZRC",
      "text" => "hello, testing deletion",
      "thread_ts" => "1758551191.454739",
      "ts" => "1758551191.454739",
      "type" => "message",
      "user" => "U09DDA47RT7"
    },
    "subtype" => "message_changed",
    "ts" => "1758551224.001400",
    "type" => "message"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09G1THKT47",
  "event_time" => 1758551224,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},
#----------------------------- send another thread message after deleting the main message
%{
  "test" => "Send message, then start a thread, then delete the original message: new thread message after deleting original",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "blocks" => [
      %{
        "block_id" => "HfHpH",
        "elements" => [
          %{
            "elements" => [
              %{
                "text" => "another reply within the thread after deleting it",
                "type" => "text"
              }
            ],
            "type" => "rich_text_section"
          }
        ],
        "type" => "rich_text"
      }
    ],
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "client_msg_id" => "1a030a0f-2051-40e8-99e6-e6b3061c50b9",
    "event_ts" => "1758551460.667819",
    "parent_user_id" => "USLACKBOT",
    "team" => "T09DGSRBZRC",
    "text" => "another reply within the thread after deleting it",
    "thread_ts" => "1758551191.454739",
    "ts" => "1758551460.667819",
    "type" => "message",
    "user" => "U09DDA47RT7"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09GBT3R891",
  "event_time" => 1758551460,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},

# editing the above thread message
%{
  "test" => "Send message, then start a thread, then delete the original message: edit the sent thread message from previous test",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "event_ts" => "1758738418.000700",
    "hidden" => true,
    "message" => %{
      "blocks" => [
        %{
          "block_id" => "IbM5M",
          "elements" => [
            %{
              "elements" => [
                %{
                  "text" => "another reply within the thread after deleting it, editing this message in thread",
                  "type" => "text"
                }
              ],
              "type" => "rich_text_section"
            }
          ],
          "type" => "rich_text"
        }
      ],
      "client_msg_id" => "1a030a0f-2051-40e8-99e6-e6b3061c50b9",
      "edited" => %{"ts" => "1758738418.000000", "user" => "U09DDA47RT7"},
      "parent_user_id" => "USLACKBOT",
      "source_team" => "T09DGSRBZRC",
      "team" => "T09DGSRBZRC",
      "text" => "another reply within the thread after deleting it, editing this message in thread",
      "thread_ts" => "1758551191.454739",
      "ts" => "1758551460.667819",
      "type" => "message",
      "user" => "U09DDA47RT7",
      "user_team" => "T09DGSRBZRC"
    },
    "previous_message" => %{
      "blocks" => [
        %{
          "block_id" => "HfHpH",
          "elements" => [
            %{
              "elements" => [
                %{
                  "text" => "another reply within the thread after deleting it",
                  "type" => "text"
                }
              ],
              "type" => "rich_text_section"
            }
          ],
          "type" => "rich_text"
        }
      ],
      "client_msg_id" => "1a030a0f-2051-40e8-99e6-e6b3061c50b9",
      "parent_user_id" => "USLACKBOT",
      "team" => "T09DGSRBZRC",
      "text" => "another reply within the thread after deleting it",
      "thread_ts" => "1758551191.454739",
      "ts" => "1758551460.667819",
      "type" => "message",
      "user" => "U09DDA47RT7"
    },
    "subtype" => "message_changed",
    "ts" => "1758738418.000700",
    "type" => "message"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09HSAZ2A2C",
  "event_time" => 1758738418,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},

#------------------------------------------------
# Sending files and then in edit, add some extra text. (files cannot be delted in edit, they have to be deleted directly)

# first payload
%{
  "test" => "Sending files and then in edit: First message with 2 files only no text",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "client_msg_id" => "115a77d5-8cd3-48f3-9dda-f9e0cfbd15dc",
    "event_ts" => "1758734546.235579",
    "files" => [
      %{
        "converted_pdf" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09GTSUFX8T-51d63c6de4/test_file_converted.pdf",
        "created" => 1758734518,
        "display_as_bot" => false,
        "editable" => false,
        "external_type" => "",
        "file_access" => "visible",
        "filetype" => "docx",
        "has_rich_preview" => false,
        "id" => "F09GTSUFX8T",
        "is_external" => false,
        "is_public" => true,
        "media_display_type" => "unknown",
        "mimetype" => "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        "mode" => "hosted",
        "name" => "test file.docx",
        "permalink" => "https://dau-testworkspace.slack.com/files/U09DDA47RT7/F09GTSUFX8T/test_file.docx",
        "permalink_public" => "https://slack-files.com/T09DGSRBZRC-F09GTSUFX8T-cd00127a44",
        "pretty_type" => "Word Document",
        "public_url_shared" => false,
        "size" => 4995,
        "skipped_shares" => true,
        "thumb_pdf" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09GTSUFX8T-51d63c6de4/test_file_thumb_pdf.png",
        "thumb_pdf_h" => 1286,
        "thumb_pdf_w" => 909,
        "timestamp" => 1758734518,
        "title" => "test file.docx",
        "url_private" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09GTSUFX8T/test_file.docx",
        "url_private_download" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09GTSUFX8T/download/test_file.docx",
        "user" => "U09DDA47RT7",
        "user_team" => "T09DGSRBZRC",
        "username" => ""
      },
      %{
        "converted_pdf" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09HBP325J5-8fc4d37959/test_file_converted.pdf",
        "created" => 1758734538,
        "display_as_bot" => false,
        "editable" => false,
        "external_type" => "",
        "file_access" => "visible",
        "filetype" => "odt",
        "has_rich_preview" => false,
        "id" => "F09HBP325J5",
        "is_external" => false,
        "is_public" => true,
        "media_display_type" => "unknown",
        "mimetype" => "application/vnd.oasis.opendocument.text",
        "mode" => "hosted",
        "name" => "test file.odt",
        "permalink" => "https://dau-testworkspace.slack.com/files/U09DDA47RT7/F09HBP325J5/test_file.odt",
        "permalink_public" => "https://slack-files.com/T09DGSRBZRC-F09HBP325J5-a6a32e2b5c",
        "pretty_type" => "OpenDocument Text",
        "public_url_shared" => false,
        "size" => 9449,
        "skipped_shares" => true,
        "thumb_pdf" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09HBP325J5-8fc4d37959/test_file_thumb_pdf.png",
        "thumb_pdf_h" => 1286,
        "thumb_pdf_w" => 909,
        "timestamp" => 1758734538,
        "title" => "test file.odt",
        "url_private" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09HBP325J5/test_file.odt",
        "url_private_download" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09HBP325J5/download/test_file.odt",
        "user" => "U09DDA47RT7",
        "user_team" => "T09DGSRBZRC",
        "username" => ""
      }
    ],
    "subtype" => "file_share",
    "text" => "",
    "ts" => "1758734546.235579",
    "type" => "message",
    "upload" => false,
    "user" => "U09DDA47RT7"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09GVBLDL69",
  "event_time" => 1758734546,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},

# Adding some text in the above message with only 2 files (in edit, new files cant be added)
%{
  "test" => "Sending files and then in edit: edit and add some text in last testcase",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "event_ts" => "1758734686.000500",
    "hidden" => true,
    "message" => %{
      "blocks" => [
        %{
          "block_id" => "TnpqN",
          "elements" => [
            %{
              "elements" => [
                %{
                  "text" => "edited text in a message with some files (new files cannot be added in the edit, only text can)",
                  "type" => "text"
                }
              ],
              "type" => "rich_text_section"
            }
          ],
          "type" => "rich_text"
        }
      ],
      "client_msg_id" => "115a77d5-8cd3-48f3-9dda-f9e0cfbd15dc",
      "edited" => %{"ts" => "1758734686.000000", "user" => "U09DDA47RT7"},
      "files" => [
        %{
          "converted_pdf" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09GTSUFX8T-51d63c6de4/test_file_converted.pdf",
          "created" => 1758734518,
          "display_as_bot" => false,
          "editable" => false,
          "external_type" => "",
          "file_access" => "visible",
          "filetype" => "docx",
          "has_rich_preview" => false,
          "id" => "F09GTSUFX8T",
          "is_external" => false,
          "is_public" => true,
          "media_display_type" => "unknown",
          "mimetype" => "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
          "mode" => "hosted",
          "name" => "test file.docx",
          "permalink" => "https://dau-testworkspace.slack.com/files/U09DDA47RT7/F09GTSUFX8T/test_file.docx",
          "permalink_public" => "https://slack-files.com/T09DGSRBZRC-F09GTSUFX8T-cd00127a44",
          "pretty_type" => "Word Document",
          "public_url_shared" => false,
          "size" => 4995,
          "skipped_shares" => true,
          "thumb_pdf" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09GTSUFX8T-51d63c6de4/test_file_thumb_pdf.png",
          "thumb_pdf_h" => 1286,
          "thumb_pdf_w" => 909,
          "timestamp" => 1758734518,
          "title" => "test file.docx",
          "url_private" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09GTSUFX8T/test_file.docx",
          "url_private_download" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09GTSUFX8T/download/test_file.docx",
          "user" => "U09DDA47RT7",
          "user_team" => "T09DGSRBZRC",
          "username" => ""
        },
        %{
          "converted_pdf" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09HBP325J5-8fc4d37959/test_file_converted.pdf",
          "created" => 1758734538,
          "display_as_bot" => false,
          "editable" => false,
          "external_type" => "",
          "file_access" => "visible",
          "filetype" => "odt",
          "has_rich_preview" => false,
          "id" => "F09HBP325J5",
          "is_external" => false,
          "is_public" => true,
          "media_display_type" => "unknown",
          "mimetype" => "application/vnd.oasis.opendocument.text",
          "mode" => "hosted",
          "name" => "test file.odt",
          "permalink" => "https://dau-testworkspace.slack.com/files/U09DDA47RT7/F09HBP325J5/test_file.odt",
          "permalink_public" => "https://slack-files.com/T09DGSRBZRC-F09HBP325J5-a6a32e2b5c",
          "pretty_type" => "OpenDocument Text",
          "public_url_shared" => false,
          "size" => 9449,
          "skipped_shares" => true,
          "thumb_pdf" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09HBP325J5-8fc4d37959/test_file_thumb_pdf.png",
          "thumb_pdf_h" => 1286,
          "thumb_pdf_w" => 909,
          "timestamp" => 1758734538,
          "title" => "test file.odt",
          "url_private" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09HBP325J5/test_file.odt",
          "url_private_download" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09HBP325J5/download/test_file.odt",
          "user" => "U09DDA47RT7",
          "user_team" => "T09DGSRBZRC",
          "username" => ""
        }
      ],
      "source_team" => "T09DGSRBZRC",
      "text" => "edited text in a message with some files (new files cannot be added in the edit, only text can)",
      "ts" => "1758734546.235579",
      "type" => "message",
      "upload" => false,
      "user" => "U09DDA47RT7",
      "user_team" => "T09DGSRBZRC"
    },
    "previous_message" => %{
      "client_msg_id" => "115a77d5-8cd3-48f3-9dda-f9e0cfbd15dc",
      "files" => [
        %{
          "converted_pdf" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09GTSUFX8T-51d63c6de4/test_file_converted.pdf",
          "created" => 1758734518,
          "display_as_bot" => false,
          "editable" => false,
          "external_type" => "",
          "file_access" => "visible",
          "filetype" => "docx",
          "has_rich_preview" => false,
          "id" => "F09GTSUFX8T",
          "is_external" => false,
          "is_public" => true,
          "is_starred" => false,
          "media_display_type" => "unknown",
          "mimetype" => "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
          "mode" => "hosted",
          "name" => "test file.docx",
          "permalink" => "https://dau-testworkspace.slack.com/files/U09DDA47RT7/F09GTSUFX8T/test_file.docx",
          "permalink_public" => "https://slack-files.com/T09DGSRBZRC-F09GTSUFX8T-cd00127a44",
          "pretty_type" => "Word Document",
          "public_url_shared" => false,
          "size" => 4995,
          "skipped_shares" => true,
          "thumb_pdf" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09GTSUFX8T-51d63c6de4/test_file_thumb_pdf.png",
          "thumb_pdf_h" => 1286,
          "thumb_pdf_w" => 909,
          "timestamp" => 1758734518,
          "title" => "test file.docx",
          "url_private" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09GTSUFX8T/test_file.docx",
          "url_private_download" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09GTSUFX8T/download/test_file.docx",
          "user" => "U09DDA47RT7",
          "user_team" => "T09DGSRBZRC",
          "username" => ""
        },
        %{
          "converted_pdf" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09HBP325J5-8fc4d37959/test_file_converted.pdf",
          "created" => 1758734538,
          "display_as_bot" => false,
          "editable" => false,
          "external_type" => "",
          "file_access" => "visible",
          "filetype" => "odt",
          "has_rich_preview" => false,
          "id" => "F09HBP325J5",
          "is_external" => false,
          "is_public" => true,
          "is_starred" => false,
          "media_display_type" => "unknown",
          "mimetype" => "application/vnd.oasis.opendocument.text",
          "mode" => "hosted",
          "name" => "test file.odt",
          "permalink" => "https://dau-testworkspace.slack.com/files/U09DDA47RT7/F09HBP325J5/test_file.odt",
          "permalink_public" => "https://slack-files.com/T09DGSRBZRC-F09HBP325J5-a6a32e2b5c",
          "pretty_type" => "OpenDocument Text",
          "public_url_shared" => false,
          "size" => 9449,
          "skipped_shares" => true,
          "thumb_pdf" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09HBP325J5-8fc4d37959/test_file_thumb_pdf.png",
          "thumb_pdf_h" => 1286,
          "thumb_pdf_w" => 909,
          "timestamp" => 1758734538,
          "title" => "test file.odt",
          "url_private" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09HBP325J5/test_file.odt",
          "url_private_download" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09HBP325J5/download/test_file.odt",
          "user" => "U09DDA47RT7",
          "user_team" => "T09DGSRBZRC",
          "username" => ""
        }
      ],
      "text" => "",
      "ts" => "1758734546.235579",
      "type" => "message",
      "upload" => false,
      "user" => "U09DDA47RT7"
    },
    "subtype" => "message_changed",
    "ts" => "1758734686.000500",
    "type" => "message"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09GYE4RXAN",
  "event_time" => 1758734686,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},

# Delete one of the files in the above message

%{
  "test" => "Sending files and then in edit: Delete one file from last testcase",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "event_ts" => "1758734879.000600",
    "hidden" => true,
    "message" => %{
      "blocks" => [
        %{
          "block_id" => "TnpqN",
          "elements" => [
            %{
              "elements" => [
                %{
                  "text" => "edited text in a message with some files (new files cannot be added in the edit, only text can)",
                  "type" => "text"
                }
              ],
              "type" => "rich_text_section"
            }
          ],
          "type" => "rich_text"
        }
      ],
      "client_msg_id" => "115a77d5-8cd3-48f3-9dda-f9e0cfbd15dc",
      "edited" => %{"ts" => "1758734686.000000", "user" => "U09DDA47RT7"},
      "files" => [
        %{
          "converted_pdf" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09GTSUFX8T-51d63c6de4/test_file_converted.pdf",
          "created" => 1758734518,
          "display_as_bot" => false,
          "editable" => false,
          "external_type" => "",
          "file_access" => "visible",
          "filetype" => "docx",
          "has_rich_preview" => false,
          "id" => "F09GTSUFX8T",
          "is_external" => false,
          "is_public" => true,
          "media_display_type" => "unknown",
          "mimetype" => "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
          "mode" => "hosted",
          "name" => "test file.docx",
          "permalink" => "https://dau-testworkspace.slack.com/files/U09DDA47RT7/F09GTSUFX8T/test_file.docx",
          "permalink_public" => "https://slack-files.com/T09DGSRBZRC-F09GTSUFX8T-cd00127a44",
          "pretty_type" => "Word Document",
          "public_url_shared" => false,
          "size" => 4995,
          "skipped_shares" => true,
          "thumb_pdf" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09GTSUFX8T-51d63c6de4/test_file_thumb_pdf.png",
          "thumb_pdf_h" => 1286,
          "thumb_pdf_w" => 909,
          "timestamp" => 1758734518,
          "title" => "test file.docx",
          "url_private" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09GTSUFX8T/test_file.docx",
          "url_private_download" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09GTSUFX8T/download/test_file.docx",
          "user" => "U09DDA47RT7",
          "user_team" => "T09DGSRBZRC",
          "username" => ""
        },
        %{"id" => "F09HBP325J5", "mode" => "tombstone"}
      ],
      "text" => "edited text in a message with some files (new files cannot be added in the edit, only text can)",
      "ts" => "1758734546.235579",
      "type" => "message",
      "upload" => false,
      "user" => "U09DDA47RT7"
    },
    "previous_message" => %{
      "blocks" => [
        %{
          "block_id" => "TnpqN",
          "elements" => [
            %{
              "elements" => [
                %{
                  "text" => "edited text in a message with some files (new files cannot be added in the edit, only text can)",
                  "type" => "text"
                }
              ],
              "type" => "rich_text_section"
            }
          ],
          "type" => "rich_text"
        }
      ],
      "client_msg_id" => "115a77d5-8cd3-48f3-9dda-f9e0cfbd15dc",
      "edited" => %{"ts" => "1758734686.000000", "user" => "U09DDA47RT7"},
      "files" => [
        %{
          "converted_pdf" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09GTSUFX8T-51d63c6de4/test_file_converted.pdf",
          "created" => 1758734518,
          "display_as_bot" => false,
          "editable" => false,
          "external_type" => "",
          "file_access" => "visible",
          "filetype" => "docx",
          "has_rich_preview" => false,
          "id" => "F09GTSUFX8T",
          "is_external" => false,
          "is_public" => true,
          "is_starred" => false,
          "media_display_type" => "unknown",
          "mimetype" => "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
          "mode" => "hosted",
          "name" => "test file.docx",
          "permalink" => "https://dau-testworkspace.slack.com/files/U09DDA47RT7/F09GTSUFX8T/test_file.docx",
          "permalink_public" => "https://slack-files.com/T09DGSRBZRC-F09GTSUFX8T-cd00127a44",
          "pretty_type" => "Word Document",
          "public_url_shared" => false,
          "size" => 4995,
          "skipped_shares" => true,
          "thumb_pdf" => "https://files.slack.com/files-tmb/T09DGSRBZRC-F09GTSUFX8T-51d63c6de4/test_file_thumb_pdf.png",
          "thumb_pdf_h" => 1286,
          "thumb_pdf_w" => 909,
          "timestamp" => 1758734518,
          "title" => "test file.docx",
          "url_private" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09GTSUFX8T/test_file.docx",
          "url_private_download" => "https://files.slack.com/files-pri/T09DGSRBZRC-F09GTSUFX8T/download/test_file.docx",
          "user" => "U09DDA47RT7",
          "user_team" => "T09DGSRBZRC",
          "username" => ""
        },
        %{"id" => "F09HBP325J5", "mode" => "tombstone"}
      ],
      "text" => "edited text in a message with some files (new files cannot be added in the edit, only text can)",
      "ts" => "1758734546.235579",
      "type" => "message",
      "upload" => false,
      "user" => "U09DDA47RT7"
    },
    "subtype" => "message_changed",
    "ts" => "1758734879.000600",
    "type" => "message"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09H38AUK6G",
  "event_time" => 1758734879,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},
#---------------------------------------------------------------------
# message in main, then a 2-3 new thread message, delete thread message, then delete main message and then delete thread message again

#main message
%{
  "test" => "main message, then start a thread, delete one thread message, delete main message, then delete another thread message: 1",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "blocks" => [
      %{
        "block_id" => "cexVM",
        "elements" => [
          %{
            "elements" => [
              %{"text" => "testing thread deletion", "type" => "text"}
            ],
            "type" => "rich_text_section"
          }
        ],
        "type" => "rich_text"
      }
    ],
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "client_msg_id" => "268e1f33-df07-42d7-993c-b2503bd0c955",
    "event_ts" => "1758781747.507389",
    "team" => "T09DGSRBZRC",
    "text" => "testing thread deletion",
    "ts" => "1758781747.507389",
    "type" => "message",
    "user" => "U09DDA47RT7"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09GX9B0HEX",
  "event_time" => 1758781747,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},
# replies
%{
  "test" => "main message, then start a thread, delete one thread message, delete main message, then delete another thread message: 2",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "blocks" => [
      %{
        "block_id" => "950dH",
        "elements" => [
          %{
            "elements" => [%{"text" => "reply1 in thread", "type" => "text"}],
            "type" => "rich_text_section"
          }
        ],
        "type" => "rich_text"
      }
    ],
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "client_msg_id" => "a5b15c15-f2ea-424a-a273-0d2c8cc6b915",
    "event_ts" => "1758781860.877129",
    "parent_user_id" => "U09DDA47RT7",
    "team" => "T09DGSRBZRC",
    "text" => "reply1 in thread",
    "thread_ts" => "1758781747.507389",
    "ts" => "1758781860.877129",
    "type" => "message",
    "user" => "U09DDA47RT7"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09HVG2RCSU",
  "event_time" => 1758781860,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},
#----
%{
  "test" => "main message, then start a thread, delete one thread message, delete main message, then delete another thread message: 3",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "blocks" => [
      %{
        "block_id" => "Hwvd4",
        "elements" => [
          %{
            "elements" => [%{"text" => "reply2 in thread", "type" => "text"}],
            "type" => "rich_text_section"
          }
        ],
        "type" => "rich_text"
      }
    ],
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "client_msg_id" => "7bcbf595-7a85-403b-b2c7-2d62a6eaabd9",
    "event_ts" => "1758781867.383709",
    "parent_user_id" => "U09DDA47RT7",
    "team" => "T09DGSRBZRC",
    "text" => "reply2 in thread",
    "thread_ts" => "1758781747.507389",
    "ts" => "1758781867.383709",
    "type" => "message",
    "user" => "U09DDA47RT7"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09HF7HCNKB",
  "event_time" => 1758781867,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},
#---
%{
  "test" => "main message, then start a thread, delete one thread message, delete main message, then delete another thread message: 4",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "blocks" => [
      %{
        "block_id" => "J0Vst",
        "elements" => [
          %{
            "elements" => [%{"text" => "reply 3 in thread", "type" => "text"}],
            "type" => "rich_text_section"
          }
        ],
        "type" => "rich_text"
      }
    ],
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "client_msg_id" => "b547eaf1-10e7-4f0b-bf1d-7ae8dc62c1f2",
    "event_ts" => "1758781872.841089",
    "parent_user_id" => "U09DDA47RT7",
    "team" => "T09DGSRBZRC",
    "text" => "reply 3 in thread",
    "thread_ts" => "1758781747.507389",
    "ts" => "1758781872.841089",
    "type" => "message",
    "user" => "U09DDA47RT7"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09HF7HMD41",
  "event_time" => 1758781872,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},
# delete 1st one

%{
  "test" => "main message, then start a thread, delete one thread message, delete main message, then delete another thread message: 5",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "deleted_ts" => "1758781860.877129",
    "event_ts" => "1758781929.000400",
    "hidden" => true,
    "previous_message" => %{
      "blocks" => [
        %{
          "block_id" => "950dH",
          "elements" => [
            %{
              "elements" => [%{"text" => "reply1 in thread", "type" => "text"}],
              "type" => "rich_text_section"
            }
          ],
          "type" => "rich_text"
        }
      ],
      "client_msg_id" => "a5b15c15-f2ea-424a-a273-0d2c8cc6b915",
      "parent_user_id" => "U09DDA47RT7",
      "team" => "T09DGSRBZRC",
      "text" => "reply1 in thread",
      "thread_ts" => "1758781747.507389",
      "ts" => "1758781860.877129",
      "type" => "message",
      "user" => "U09DDA47RT7"
    },
    "subtype" => "message_deleted",
    "ts" => "1758781929.000400",
    "type" => "message"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09H205801G",
  "event_time" => 1758781929,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},
#---- delete main message
%{
  "test" => "main message, then start a thread, delete one thread message, delete main message, then delete another thread message: 6",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "event_ts" => "1758782474.000600",
    "hidden" => true,
    "message" => %{
      "hidden" => true,
      "is_locked" => false,
      "latest_reply" => "1758781872.841089",
      "reply_count" => 2,
      "reply_users" => ["U09DDA47RT7"],
      "reply_users_count" => 1,
      "subtype" => "tombstone",
      "text" => "This message was deleted.",
      "thread_ts" => "1758781747.507389",
      "ts" => "1758781747.507389",
      "type" => "message",
      "user" => "USLACKBOT"
    },
    "previous_message" => %{
      "blocks" => [
        %{
          "block_id" => "cexVM",
          "elements" => [
            %{
              "elements" => [
                %{"text" => "testing thread deletion", "type" => "text"}
              ],
              "type" => "rich_text_section"
            }
          ],
          "type" => "rich_text"
        }
      ],
      "client_msg_id" => "268e1f33-df07-42d7-993c-b2503bd0c955",
      "is_locked" => false,
      "last_read" => "1758781872.841089",
      "latest_reply" => "1758781872.841089",
      "reply_count" => 2,
      "reply_users" => ["U09DDA47RT7"],
      "reply_users_count" => 1,
      "subscribed" => true,
      "team" => "T09DGSRBZRC",
      "text" => "testing thread deletion",
      "thread_ts" => "1758781747.507389",
      "ts" => "1758781747.507389",
      "type" => "message",
      "user" => "U09DDA47RT7"
    },
    "subtype" => "message_changed",
    "ts" => "1758782474.000600",
    "type" => "message"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09GYS7QLTF",
  "event_time" => 1758782474,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},

# delete 2nd thread message, message payload then, again payload for the deleted parent message (maybe due to some race condition)

%{
  "test" => "main message, then start a thread, delete one thread message, delete main message, then delete another thread message: 7",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "deleted_ts" => "1758781867.383709",
    "event_ts" => "1758782872.000700",
    "hidden" => true,
    "previous_message" => %{
      "blocks" => [
        %{
          "block_id" => "Hwvd4",
          "elements" => [
            %{
              "elements" => [%{"text" => "reply2 in thread", "type" => "text"}],
              "type" => "rich_text_section"
            }
          ],
          "type" => "rich_text"
        }
      ],
      "client_msg_id" => "7bcbf595-7a85-403b-b2c7-2d62a6eaabd9",
      "parent_user_id" => "USLACKBOT",
      "team" => "T09DGSRBZRC",
      "text" => "reply2 in thread",
      "thread_ts" => "1758781747.507389",
      "ts" => "1758781867.383709",
      "type" => "message",
      "user" => "U09DDA47RT7"
    },
    "subtype" => "message_deleted",
    "ts" => "1758782872.000700",
    "type" => "message"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09HF9UE709",
  "event_time" => 1758782872,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},

#------------- Race condition, same payload of deleted main message
%{
  "test" => "main message, then start a thread, delete one thread message, delete main message, then delete another thread message: 8",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "event_ts" => "1758782872.000800",
    "hidden" => true,
    "message" => %{
      "hidden" => true,
      "is_locked" => false,
      "latest_reply" => "1758781872.841089",
      "parent_user_id" => "USLACKBOT",
      "reply_count" => 1,
      "reply_users" => ["U09DDA47RT7"],
      "reply_users_count" => 1,
      "subtype" => "tombstone",
      "text" => "This message was deleted.",
      "thread_ts" => "1758781747.507389",
      "ts" => "1758781747.507389",
      "type" => "message",
      "user" => "USLACKBOT"
    },
    "previous_message" => %{
      "hidden" => true,
      "is_locked" => false,
      "last_read" => "1758781872.841089",
      "latest_reply" => "1758781872.841089",
      "parent_user_id" => "USLACKBOT",
      "reply_count" => 1,
      "reply_users" => ["U09DDA47RT7"],
      "reply_users_count" => 1,
      "subscribed" => true,
      "subtype" => "tombstone",
      "text" => "This message was deleted.",
      "thread_ts" => "1758781747.507389",
      "ts" => "1758781747.507389",
      "type" => "message",
      "user" => "USLACKBOT"
    },
    "subtype" => "message_changed",
    "ts" => "1758782872.000800",
    "type" => "message"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09HVJFHFDE",
  "event_time" => 1758782872,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
},
#--- new thread message
%{
  "test" => "main message, then start a thread, delete one thread message, delete main message, then delete another thread message: 9",
  "api_app_id" => "A09DVQ7TY1F",
  "authorizations" => [
    %{
      "enterprise_id" => nil,
      "is_bot" => true,
      "is_enterprise_install" => false,
      "team_id" => "T09DGSRBZRC",
      "user_id" => "U09DH07QHHC"
    }
  ],
  "context_enterprise_id" => nil,
  "context_team_id" => "T09DGSRBZRC",
  "event" => %{
    "blocks" => [
      %{
        "block_id" => "WiOXk",
        "elements" => [
          %{
            "elements" => [
              %{
                "text" => "new reply after deleting main message",
                "type" => "text"
              }
            ],
            "type" => "rich_text_section"
          }
        ],
        "type" => "rich_text"
      }
    ],
    "channel" => "C09DGSRHCKY",
    "channel_type" => "channel",
    "client_msg_id" => "eceedcae-5e48-415c-9516-425763c37221",
    "event_ts" => "1758783077.959799",
    "parent_user_id" => "USLACKBOT",
    "team" => "T09DGSRBZRC",
    "text" => "new reply after deleting main message",
    "thread_ts" => "1758781747.507389",
    "ts" => "1758783077.959799",
    "type" => "message",
    "user" => "U09DDA47RT7"
  },
  "event_context" => "4-eyJldCI6Im1lc3NhZ2UiLCJ0aWQiOiJUMDlER1NSQlpSQyIsImFpZCI6IkEwOURWUTdUWTFGIiwiY2lkIjoiQzA5REdTUkhDS1kifQ",
  "event_id" => "Ev09GLNBKGEB",
  "event_time" => 1758783077,
  "is_ext_shared_channel" => false,
  "team_id" => "T09DGSRBZRC",
  "token" => "6DuNHhx3Y3wKGBsTfQHrpkcK",
  "type" => "event_callback"
}
]
end
end
