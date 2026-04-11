defmodule DAU.Accounts.UserNotifier do
  import Swoosh.Email

  alias DAU.Mailer

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({"DAU", "contact@example.com"})
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    deliver(user.email, "Confirm your DAU account", """

    Hi #{user.email},

    Welcome to Deepfake Analysis Unit (DAU).

    Please confirm your account by clicking the link below:
    #{url}

    If you didn't create this account, you can safely ignore this email.
    """)
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    deliver(user.email, "Reset your DAU password", """

    Hi #{user.email},

    We received a request to reset your password.

    You can set a new password using the link below:
    #{url}

    If you didn't request a password reset, please ignore this email.
    """)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    deliver(user.email, "Confirm your new email address", """

    Hi #{user.email},

    You requested to update your email address.

    Please confirm the change by clicking the link below:
    #{url}

    If you didn't request this change, please ignore this email.
    """)
  end
end
