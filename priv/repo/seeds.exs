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
    media_urls: [

      """
      Long text message: [1/15, 08:44] Josh Shobhnath Prajpati: [1/5, 21:17] Josh Shobhnath Prajpati: https://www.maanhelpdoor.org/Register/Left/DW119273 [1/5, 21:17] Josh Shobhnath Prajpati: https://uktrade.in/Register/61329 [1/5, 21:19] Josh Shobhnath Prajpati: Get 33 to 50% Off check this out Great savings on daily needs shopping and utilities https://bachatwallet.com/referrer?refferalcode= 848678 Referral code: 848678 [1/5, 21:20] Josh Shobhnath Prajpati: https://youtube.com/watch?v=7RL1xl_GH_I&feature=shared [1/5, 21:21] Josh Shobhnath Prajpati: Hey, I'm inviting you to sign up for Shopping! Make pension from ration by downloading Abhhyam app. why wait? Click here https://play.google.com/store/apps/details?id=com.abhhyam Use this code for AVI2936 guide id [1/5, 21:27] Josh Shobhnath Prajpati: https://youtu.be/TNDcWT3opAA?si=Ey9jdHfEAuYstgZ4 [1/5, 21:38] Josh Shobhnath Prajpati: https://youtu.be/Xf_6G2GzS2s?si=eFroP4RyKzkZuRwS (1) यूके टेरेड इस लिंक से आप 3000 रुपये से शुरूवात करे टेरेड मे इनबेस्टमेंटकर यहा 200 दिन तक 30 रुपया डेली पायेंगे जिसमे मंथली 20 दिन का 600 रुपये महीने का मिलेगा, 4 सटरडे 4 संडे टेरेड का काम नही होता है आप अपने मंथली खरचे जैसे फोन इंटरनेट बोर्डबैंड रिचार्ज डीटीऐच रिचार्ज का फाईदा ले सकते है या कमाकर अपडेट करे हर हपते 3000 रुपये इनबेस्ट करे तो 12000 रूपये से 2400 रुपये मंथली दैनिक 120 रुपये का फाईदा लेकर,राशन दूध गैस पेटरोल बच्चो की फीस भर सकते है इनकम से (2)बचत बोयलेट ऐप को डाउनलोड करके साईन इन,लोगिन करना है रैफरल 848678 भरकर अपने डिटेल भरे और यूके टेरेड से कमाये 6000 रुपये + 708 रुपये सर्बिसचार्ज+ जीऐसटी भरकर अपने बचत बोयलेट को रिचार्जकर 18 महीने तक हर महीना500 रुपये पाये यहा 1 साल के रिचार्जपर 3000 रुपये का बचत होगा,और रैफरल पर 1 बार 600 रुपया और8 प्रतिशत मंथली मंथली टरानजेक्शन पर इनकम (3) अभयम अर्ध सैनिक कैंटीन ऐप डाउनलोड करे और ऐप खोलकर अपना मन पसंद पहली ग्रोसरी राशन, किचन हैल्थ पैकेज 4 हजार रूपये का खरीदकर पाये 200 पेंशन पोइंट, 5 हजार बोनस,और200पेशन पोइंट की पहला लेबल,इनकम से ज्यादा30 प्रतिशत पे़शन फंड ओर 70 प्रतिशत इन कम पाये Bacchat Wallet - Save - Refer - Earn https://youtube.com/watch?v=7RL1xl_GH_I&feature=shared Get 33 to 50% Off check this out Great savings on daily needs shopping and utilities https://bachatwallet.com/referrer?refferalcode= 848678 Referral code: 848678 जय हिंद बंदे मातरम राम राम प्रनाम आईये हम सभी मिलकर आपसी बातचीत, सुझाव मशवरा कर बचत बोयलेट ऐप को डाउनलोड करके साईन इन लोगिन करके 848678 रैफरल लिंक डालकर फार्म भरकर अपनी के वाई सी करके 1 साल का घरेलू प्रसनल खर्चा 120000 रुपये अपने बोयलेट को रिचार्जकर 24 महीने तक हर महीना 10 हजार रूपये का लाभ लेते हुऐ यू के टेरेड मे 9000 रुपये इनबेसटमेंट कर हर महीना 1800 रूपये हर महीने और कमाये 200 दिन तक मतलब 18000 रूपया जहा हर महीना इनबेस्टःमेट का लाभ लेंगे 3 महीने बाद हमारी मंथली इनमम 5400+3000=8400 + 9 हजार फिर 17400 मेसे 15000 रूपये इनबेस्टमेंटकर 3 हजार महीना कमाये गे जो हर महीना 200 दिन तक मतलब30000 डबल 1 लाख 20 हजार मे से यहा से महीने मे बचत बोयलेट से 1लाख40 हजार रूपये और 1 लाख 40 हजार 200रूपये यूके टेरेड से टोटल 2 लाख 42 हजार रूपये का लाभ ले सकते हैं 9958840215 वाट्स ऐप से लिंक लीजिये [1/16, 07:46] Josh Shobhnath Prajpati: Getting Started with MobiArmour: Your Complete User Guide https://youtube.com/watch?v=IamN7jTqLFU&feature=shared जय हिंद बंदे मातरम राम राम प्रनाम बंधुओ हम सभी को आपस मे फोन ँनमबर 9958840215 से जुड़कर आपसी बातचीतकर,सुझावमशवरा कर सभी समस्यावो का समाधान निकालना जरुरी है जैसे आजकल हो रहे सभी अपराध ,हैकिंग,मिलावटखोरी ,अपहरन,चोरी बलात्कार,मर्डर जैसे इसको मिलकर दूर करेंगे तन मन धन से सपोटकर इसको कोई नेतामंत्री प्रधानमंत्री,, मुख्यमंत्री, सांसद बिधायक प्रधान सरपंच 1 दिमाक,काम बुध्धी रखने वाला नही कर सकता ऐसे मे जज वकील पुलिस प्रशाशन जो भी बनाया जाय तो जनता से उसको सारटीफीकेट मिला होना चाहिये क्योंकि जनता ही सरकार है वही वोट देकर बनाती है तो हटाने का अधिकार जनता के हाथ मे होना चाहिये अगर उसका ब्योहार काम करने का ढंग पसंद ना आये तो भारत का नया आटोमैटिक डिजटल कानून संबिधान बनाकर नया लागू करना है दंड सभी पर बराबर लागू हो जो भी अपने पद का दुरपयोग करे चाहे जनता हो या सरकार सिसटम का कोई भी हो [1/22, 21:10] Josh Shobhnath Prajpati: https://youtu.be/t19pvSciofc?si=XNKDJ7edsBH9kSY4
      """
    ],
    media_type: "text",
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
    media_urls: ["short text: google.com"],
    media_type: "text",
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
  },
  %{
    media_urls: [
      "is this real? https://dau.mcaindia.in/blog/video-of-rajat-sharma-promoting-cure-for-vision-loss-is-manipulated"
    ],
    media_type: "text",
    sender_number: "0000000000",
    language: "en"
  },
  %{
    media_urls: [
      "a convoluated example of all kinds of urls. https://example.com or https://www.example.com "
    ],
    media_type: "text",
    sender_number: "0000000000",
    language: "en"
  },
  %{
    media_urls: [
      "Now some real examples from social media - https://www.youtube.com/watch?v=LJc6nA6uOJE "
    ],
    media_type: "text",
    sender_number: "0000000000",
    language: "en"
  }
]
|> Enum.map(&Feed.add_to_common_feed/1)
