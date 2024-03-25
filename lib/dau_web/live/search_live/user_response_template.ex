defmodule DAUWeb.SearchLive.UserResponseTemplate do
  def get_text(query) do
    user_response_label = Map.get(query, :verification_status)
    media_type = Map.get(query, :media_type, "<unexpected media type>")

    assessment_report_url =
      case Map.get(query, :assessment_report) do
        nil -> "<awaiting assement report>"
        assessment_report -> Map.get(assessment_report, :url, "<pending addition>")
      end

    case user_response_label do
      :deepfake ->
        """
        📢 We reviewed this #{media_type} and found it to be Deepfake.
        🎯 You can read our assessment report here: #{assessment_report_url}
        🧠  Please use your discretion in sharing this information.

        Thank you reaching out to us. We hope you have a good day ahead. 🙏
        """

      :manipulated ->
        """
        📢 We reviewed this #{media_type} and found it to be Manipulated.

        🎯You can read our assessment report here: #{assessment_report_url}

        🧠  Please use your discretion in sharing this forward.

        Thank you reaching out to use. We hope you have a good day ahead. 🙏
        """

      :not_manipulated ->
        """
        📢 We reviewed this #{media_type} and found it to be Not Manipulated.

        🎯You can read our assessment report here: #{assessment_report_url}

        🧠  Please use your discretion in sharing this forward.

        Thank you reaching out to use. We hope you have a good day ahead. 🙏
        """

      :inconclusive ->
        """
        📢 We reviewed this #{media_type} and found it to be Inconclusive

        🎯You can read our assessment report here:#{assessment_report_url}

        🧠  Please use your discretion in sharing this forward.

        Thank you reaching out to use. We hope you have a good day ahead. 🙏
        """

      :not_ai_generated ->
        """
        📢 We didn't find any element of AI generation in this #{media_type}. But lack of AI-manipulation does not mean that the information provided in the message is accurate.

        Please reach out to any of these fact checkers below to verify the things being shown and spoken about in the message.

        ➡️AFP: +91- 959997398
        ➡️Boom: +91- 7700906588
        ➡️Vishvas News: +91-9599299372
        ➡️Factly: +91-9247052470
        ➡️THIP: +91-8507885079
        ➡️Newschecker: +91-9999499044
        ➡️Fact Crescendo: +91-9049053770
        ➡️Digit Eye: +91-9632830256
        ➡️India Today: +91-7370007000
        ➡️Newsmobile:+91-1171279799
        ➡️Quint WebQoof: +91-9643651818

        Thank you for reaching out to us. We hope you have a good day ahead. 🙏
        """

      :out_of_scope ->
        """
        We appreciate you taking the time out to send this message. 🙌

        We only check content that is of public importance and likely to mislead people. We don't review personal and private audio and videos.

        If you come across anything that is suspicious or misleading, please do not hesitate to reach out to us again.

        We hope you have a good day ahead. 🙏
        """

      :spam ->
        """
        We appreciate you taking the time out to send this message. 🙌

        We only check content that is of public importance and likely to mislead people. We don't review personal and private audio and videos.

        If you come across anything that is suspicious or misleading, please do not hesitate to reach out to us again.

        We hope you have a good day ahead. 🙏
        """

      :unsupported_media ->
        """
        ⚠️This tipline is only for audio and video.

        We do not review images but these fact checkers below can help. Thanks for reaching out to us.

        ➡️AFP: +91- 959997398
        ➡️Boom: +91- 7700906588
        ➡️Vishvas News: +91-9599299372
        ➡️Factly: +91-9247052470
        ➡️THIP: +91-8507885079
        ➡️Newschecker: +91-9999499044
        ➡️Fact Crescendo: +91-9049053770
        ➡️Digit Eye: +91-9632830256
        ➡️India Today: +91-7370007000
        ➡️Newsmobile:+91-1171279799
        ➡️Quint WebQoof: +91-9643651818
        """

      :unsupported_language ->
        """
        🫣 Oops! The media you shared is in a language we don't currently support. You can share it with other fact checkers on Whatsapp tiplines listed below:

        ➡️Boom: +91-7700906588
        ➡️Vishvas News: +91-9599299372
        ➡️Factly: +91-9247052470
        ➡️THIP: +91-8507885079
        ➡️Newschecker: +91-9999499044
        ➡️Fact Crescendo: +91-9049053770
        ➡️India Today: +91-7370007000
        ➡️Newsmobile:+91-1171279799
        ➡️Quint WebQoof: +91-9540511818
        ➡️Logically Facts: +91-8640070078
        ➡️Newsmeter: +91-7482830440
        """

      nil ->
        """

        """
    end
  end
end
