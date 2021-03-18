package handlers

import (
	"encoding/json"
	"errors"
	"fmt"
	"log"
	"net/http"
	"strconv"
	"strings"
	"sync"

	"github.com/darinmilner/productiveapp/internal/config"
	"github.com/darinmilner/productiveapp/internal/forms"
	"github.com/darinmilner/productiveapp/internal/models"
	"github.com/darinmilner/productiveapp/internal/render"
)

//Repo is the repository used by the handlers
var Repo *Repository

//Repository struct
type Repository struct {
	App *config.AppConfig
}

//NewRepo creates a new repository
func NewRepo(a *config.AppConfig) *Repository {
	return &Repository{
		App: a,
	}
}

//NewHandlers sets the repository for handlers
func NewHandlers(r *Repository) {
	Repo = r
}

//Home page function
func (m *Repository) Home(w http.ResponseWriter, r *http.Request) {
	remoteIP := r.RemoteAddr
	m.App.Session.Put(r.Context(), "remoteIP", remoteIP)
	render.RenderTemplates(w, r, "home.page.html", &models.TemplateData{})
}

//About page function
func (m *Repository) About(w http.ResponseWriter, r *http.Request) {
	//perform some logic
	stringMap := make(map[string]string)
	remoteIP := m.App.Session.GetString(r.Context(), "remoteIP")

	stringMap["remoteIP"] = remoteIP

	render.RenderTemplates(w, r, "about.page.html", &models.TemplateData{})
}

//About page function
func (m *Repository) SignupSuccess(w http.ResponseWriter, r *http.Request) {
	signup, ok := m.App.Session.Get(r.Context(), "signup").(models.Signup)
	if !ok {
		fmt.Println("Could not get signup model from the session")
		m.App.Session.Put(r.Context(), "error", "Could not get signup from context")
		http.Redirect(w, r, "/", http.StatusTemporaryRedirect)
		return
	}
	m.App.Session.Remove(r.Context(), "signup")
	data := make(map[string]interface{})
	data["signup"] = signup
	render.RenderTemplates(w, r, "signup-success.page.html", &models.TemplateData{
		Data: data,
	})
}

//Signup page function
func (m *Repository) Signup(w http.ResponseWriter, r *http.Request) {
	var emptySignupForm models.Signup

	data := make(map[string]interface{})
	data["signup"] = emptySignupForm

	render.RenderTemplates(w, r, "signup.page.html", &models.TemplateData{
		Form: forms.New(nil),
		Data: data,
	})
}

func (m *Repository) PostSignUp(w http.ResponseWriter, r *http.Request) {
	err := r.ParseForm()

	if err != nil {
		log.Println(err)
		return
	}

	signup := models.Signup{
		FirstName: r.Form.Get("first-name"),
		LastName:  r.Form.Get("last-name"),
		Email:     r.Form.Get("email"),
	}

	form := forms.New(r.PostForm)

	form.Required("first-name", "last-name", "email")

	form.MinLength("first-name", 3, r)

	form.MinLength("last-name", 3, r)

	form.IsEmail("email")

	if !form.Valid() {
		data := make(map[string]interface{})
		data["signup"] = signup
		render.RenderTemplates(w, r, "signup.page.html", &models.TemplateData{
			Form: form,
			Data: data,
		})
		return

	}

	//Add session
	m.App.Session.Put(r.Context(), "signup", signup)

	http.Redirect(w, r, "/signup-success", http.StatusSeeOther)
}

//Hadith defines the hadith structure
type Hadith struct {
	Day  int    `json:"Day"`
	Text string `json:"Text"`
}

//Hadiths type
type Hadiths []Hadith

//hadithHandlers struct
type hadithHandlers struct {
	sync.Mutex
	hadiths Hadiths
}

//NewHadithHandlers returns the map of hadith and their day number
func NewHadithHandlers() *hadithHandlers {
	return &hadithHandlers{
		hadiths: Hadiths{
			Hadith{1, "Narrated Ibn 'Umar: Allah's Apostle said: Islam is based on (the following) five (principles): 1. To testify that none has the right to be worshipped but Allah and that Muhammad is Allah's Apostle. 2. To offer the (compulsory congregational) prayers dutifully and perfectly. 3. To pay Zakat (i.e. obligatory charity).  4. To perform Hajj. (i.e. Pilgrimage to Mecca) 5. To observe fast during the month of Ramadan.  (Bukhari, Book #2, Hadith #7)"},
			Hadith{2, "Narrated Abu Huraira: Allah's Apostle said: \"Whoever establishes prayers during the nights of Ramadan faithfully out of sincere faith and hoping to attain Allah's rewards (not for showing off), all his past sins will be forgiven.\"  (Bukhari, Book #2, Hadith #36)"},
			Hadith{3, "Narrated Ibn 'Abbas: Allah's Apostle was the most generous of all the people, and he used to reach the peak in generosity in the month of Ramadan when Gabriel met him. Gabriel used to meet him every night of Ramadan to teach him the Qur'an. Allah's Apostle was the most generous person, even more generous than the strong uncontrollable wind (in readiness and haste to do charitable deeds).  (Bukhari, Book #1, Hadith #5)"},
			Hadith{4, "Narrated Zaid bin Thabit: Allah's Apostle made a small room in the month of Ramadan (Sa'id said, \"I think that Zaid bin Thabit said that it was made of a mat\") and he prayed there for a few nights, and so some of his companions prayed behind him. When he came to know about it, he kept on sitting. In the morning, he went out to them and said, \"I have seen and understood what you did. You should pray in your houses, for the best prayer of a person is that which he prays in his house except the compulsory prayers.\" (Bukhari, Book #11, Hadith #698)"},
			Hadith{5, "Narrated Abu Salma bin 'Abdur Rahman: I asked 'Aisha, \"How is the prayer of Allah's Apostle during the month of Ramadan.\" She said, \"Allah's Apostle never exceeded eleven Rakat in Ramadan or in other months; he used to offer four Rakat-- do not ask me about their beauty and length, then four Rakat, do not ask me about their beauty and length, and then three Rakat.\" Aisha further said, \"I said, 'O Allah's Apostle! Do you sleep before offering the Witr prayer?' He replied, 'O 'Aisha! My eyes sleep but my heart remains awake'!\"  (Bukhari, Book #21, Hadith #248)"},
			Hadith{6, "Narrated Abu Huraira: A Bedouin came to the Prophet and said, \"Tell me of such a deed as will make me enter Paradise, if I do it.\" The Prophet (p.b.u.h) said, \"Worship Allah, and worship none along with Him, offer the (five) prescribed compulsory prayers perfectly, pay the compulsory Zakat, and fast the month of Ramadan.\" The Bedouin said, \"By Him, in Whose Hands my life is, I will not do more than this.\" When he (the Bedouin) left, the Prophet said, \"Whoever likes to see a man of Paradise, then he may look at this man.\"  (Bukhari, Book #23, Hadith #480)"},
			Hadith{7, "Narrated Abu Huraira: Allah's Apostle said, \"When the month of Ramadan starts, the gates of the heaven are open, the gates of Hell close and the devils are chained.\"  (Bukhari, Book #31, Hadith #123)"},
			Hadith{8, "Narrated Ibn Umar: I heard Allah's Apostle saying, \"When you see the crescent (of the month of Ramadan), start fasting, and when you see the crescent (of the month of Shawwal), stop fasting; and if the sky is overcast (and you can't see It) then regard the crescent (month) of Ramadan (as of 30 days)\".  (Bukhari, Book #31, Hadith #124)"},
			Hadith{9, "Narrated Abu Huraira: The Prophet said, \"Whoever established prayers on the night of Qadr out of sincere faith and hoping for a reward from Allah, then all his previous sins will be forgiven; and whoever fasts in the month of Ramadan out of sincere faith, and hoping for a reward from Allah, then all his previous sins will be forgiven.\"  (Bukhari, Book #31, Hadith #125)"},
			Hadith{10, "Narrated Abu Huraira: The Prophet said, \"None of you should fast a day or two before the month of Ramadan unless he has the habit of fasting (Nawafil) (and if his fasting coincides with that day) then he can fast that day.\"  (Bukhari, Book #31, Hadith #138)"},
			Hadith{11, "Narrated 'Aisha: Allah's Apostle said, \"Whoever died and should have fasted (the missed days of Ramadan) then his guardians must fast on his behalf.\"  (Bukhari, Book #31, Hadith #173)"},
			Hadith{12, "Narrated 'Aisha: Allah's Apostle used to fast till one would say that he would never stop fasting, and he would abandon fasting till one would say that he would never fast. I never saw Allah's Apostle fasting for a whole month except the month of Ramadan and did not see him fasting in any month more than in the month of Sha'ban.  (Bukhari, Book #31, Hadith #190)"},
			Hadith{13, "Narrated Ibn 'Umar: Some men amongst the companions of the Prophet were shown in their dreams that the night of Qadr was in the last seven nights of Ramadan. Allah's Apostle said, \"It seems that all your dreams agree that (the Night of Qadr) is in the last seven nights, and whoever wants to search for it (i.e. the Night of Qadr) should search in the last seven (nights of Ramadan).\"  (Bukhari, Book #32, Hadith #232)"},
			Hadith{14, "Narrated 'Aisha: Allah's Apostle used to practice Itikaf in the last ten nights of Ramadan and used to say, \"Look for the Night of Qadr in the last ten nights of the month of Ramadan.\"  (Bukhari, Book #32, Hadith #237)"},
			Hadith{15, "Narrated 'Ubada bin As-Samit: The Prophet came out to inform us about the Night of Qadr but two Muslims were quarreling with each other. So, the Prophet said, \"I came out to inform you about the Night of Qadr but such-and-such persons were quarreling, so the news about it had been taken away; yet that might be for your own good, so search for it on the 29th, 27th and 25th (of Ramadan).  (Bukhari, Book #32, Hadith #240)"},
			Hadith{16, "Narrated Aisha: With the start of the last ten days of Ramadan, the Prophet used to tighten his waist belt (i.e. work hard) and used to pray all the night and used to keep his family awake for the prayers. (Bukhari, Book #32, Hadith #241)"},
			Hadith{17, "Narrated Tawus: Ibn Abbas said, \"Allah's Apostle travelled in the month of Ramadan and he fasted till he reached (a place called) 'Usfan, then he asked for a tumbler of water and drank it by the daytime so that the people might see him. He broke his fast till he reached Mecca.\" Ibn Abbas used to say, \"Allah's Apostle fasted and sometimes did not fast while traveling, so one may fast or may not (on journeys)\". (Bukhari, Book #59, Hadith #576)"},
			Hadith{18, "Narrated Al-Bara: When the order of compulsory fasting of Ramadan was revealed, the people did not have sexual relations with their wives for the whole month of Ramadan, but some men cheated themselves (by violating that restriction). So, Allah revealed: \"Allah is aware that you were deceiving yourselves, but He accepted your repentance and forgave you.\" (3.187).  (Bukhari, Book #60, Hadith #35)"},
			Hadith{19, "Narrated Abu-Huraira: Gabriel used to repeat the recitation of the Qur'an with the Prophet once a year, but he repeated it twice with him in the year he died. The Prophet used to stay in I'tikaf for ten days every year (in the month of Ramadan). (Bukhari, Book #61, Hadith #520)"},
			Hadith{20, "Narrated Abu Huraira: A man came to the Prophet and said, \"I am ruined!\" The Prophet said, \"Why?\" He said, \"I had sexual intercourse with my wife while fasting (in the month of Ramadan).\" The Prophet said to him, \"Manumit a slave (as expiation).\" He replied, \"I cannot afford that.\" The Prophet said, \"Then fast for two successive months.\" He said, \"I cannot.\" The Prophet said, \"Then feed sixty poor persons.\" He said, \"I have nothing to do that.\" In the meantime, a basket full of dates was brought to the Prophet. He said, \"Where is the questioner.\" The man said, \"I am here.\" The Prophet said (to him), \"Give this (basket of dates) in charity (as expiation).\" He said, \"O Allah's Apostle! Shall I give it to poorer people than us? By Him Who sent you with the Truth, there is no family between Medina's two mountains poorer than us.\" The Prophet smiled till his pre-molar teeth became visible. He then said, \"Then take it.\"  (Bukhari, Book #64, Hadith #281)"},
			Hadith{21, "Narrated Abu Huraira: The Prophet said, \"Whoever believes in Allah and His Apostle offers prayers perfectly and fasts (the month of) Ramadan then it is incumbent upon Allah to admit him into Paradise, whether he emigrates for Allah's cause or stays in the land where he was born.\" They (the companions of the Prophet) said, \"O Allah's Apostle! Should we not inform the people of that?\" He said, \"There are one-hundred degrees in Paradise which Allah has prepared for the mujahidoon in His Cause. The distance between every two degrees is like the distance between the sky and the Earth, so if you ask Allah for anything, ask Him for the Firdaus, for it is the last part of Paradise and the highest part of Paradise, and at its top there is the Throne of Beneficent, and from it gush forth the rivers of Paradise.\"  (Bukhari, Book #93, Hadith #519)"},
			Hadith{22, "Narrated Anas: Zaid bin Thabit said, \"We took the \"Suhur\" (the meal taken before dawn while fasting is observed) with the Prophet and then stood up for the (morning) prayer.\" I asked him how long the interval between the two (Suhur and prayer) was. He replied, 'The interval between the two was just sufficient to recite fifty to Sixth 'Ayat.\"  (Bukhari, Book #10, Hadith #549)"},
			Hadith{23, "Narrated Shaqiq: that he had heard Hudhaifa saying, \"Once I was sitting with 'Umar and he said, 'Who amongst you remembers the statement of Allah's Apostle about the afflictions?' I said, 'I know it as the Prophet had said it.' 'Umar said, 'No doubt you are bold.' I said, 'The afflictions caused for a man by his wife, money, children and neighbor are expiated by his prayers, fasting, charity and by enjoining (good) and forbidding (evil).' 'Umar said, 'I did not mean that, but I asked about that affliction which will spread like the waves of the sea. I said, 'O leader of the faithful believers! You need not be afraid of it as there is a closed door between you and it.' 'Umar asked, Will the door be broken or opened?' I replied, 'It will be broken.' 'Umar said, 'Then it will never be closed again.' I was asked whether 'Umar knew that door. I replied that he knew it as one knows that there will be night before the tomorrow morning. I narrated a Hadith that was free from any mis-statement\" The sub narrator added that they deputed Masruq to ask Hudhaifa (about the door). Hudhaifa said, \"The door was 'Umar himself.\"  (Bukhari, Book #10, Hadith #503)"},
			Hadith{24, "Narrated Anas bin Malik Sometimes Allah's Apostle would not fast (for so many days) that we thought that he would not fast that month and he sometimes used to fast (for so many days) that we thought he would not leave fasting through-out that month and (as regards his prayer and sleep at night), if you wanted to see him praying at night, you could see him praying and if you wanted to see him sleeping, you could see him sleeping.  (Bukhari, Book #21, Hadith #242)"},
			Hadith{25, "Narrated Abu Huraira: Allah's Apostle said, \"fasting is a shield (or a screen or a shelter). So, the person observing fasting should avoid sexual relation with his wife and should not behave foolishly and impudently, and if somebody fights with him or abuses him, he should tell him twice, 'I am fasting.\" The Prophet added, \"By Him in Whose Hands my soul is, the smell coming out from the mouth of a fasting person is better in the sight of Allah than the smell of musk. (Allah says about the fasting person), 'He has left his food, drink and desires for My sake. The fast is for Me, so I will reward (the fasting person) for it and the reward of good deeds is multiplied ten times.\"  (Bukhari, Book #31, Hadith #118)"},
			Hadith{26, "Narrated Abu Huraira: The Prophet said, \"Whoever does not give up forged speech and evil actions, Allah is not in need of his leaving his food and drink (i.e. Allah will not accept his fasting.)\"  (Bukhari, Book #31, Hadith #127)"},
			Hadith{27, "Narrated Abu Huraira: Allah's Apostle said, \"Allah said, 'All the deeds of Adam's sons (people) are for them, except fasting which is for Me, and I will give the reward for it.' fasting is a shield or protection from the fire and from committing sins. If one of you is fasting, he should avoid sexual relation with his wife and quarreling, and if somebody should fight or quarrel with him, he should say, 'I am fasting.' By Him in Whose Hands my soul is, the unpleasant smell coming out from the mouth of a fasting person is better in the sight of Allah than the smell of musk. There are two pleasures for the fasting person, one at the time of breaking his fast, and the other at the time when he will meet his Lord; then he will be pleased because of his fasting.\"  (Bukhari, Book #31, Hadith #128)"},
			Hadith{28, "Narrated 'Aisha: The Prophet used to kiss and embrace (his wives) while he was fasting, and he had more power to control his desires than any of you. Said Jabir, \"The person who gets discharge after casting a look (on his wife) should complete his fast.\"  (Bukhari, Book #31, Hadith #149)"},
			Hadith{29, "Narrated Abu Huraira: The Prophet said, \"If somebody eats or drinks forgetfully then he should complete his fast, for what he has eaten or drunk, has been given to him by Allah.\" Narrated 'Amir bin Rabi'a, \"I saw the Prophet cleaning his teeth with Siwak while he was fasting so many times as I can't count.\" And narrated Abu Huraira, \"The Prophet said, 'But for my fear that it would be hard for my followers, I would have ordered them to clean their teeth with Siwak on every performance of ablution.\" The same is narrated by Jabir and Zaid bin Khalid from the Prophet who did not differentiate between a fasting and a non-fasting person in this respect (using Siwak). Aisha said, \"The Prophet said, \"It (i.e. Siwak) is a purification for the mouth and it is a way of seeking Allah's pleasures.\" Ata' and Qatada said, \"There is no harm in swallowing the resultant saliva.\"  (Bukhari, Book #31, Hadith #154)"},
			Hadith{30, "Narrated Jabir bin 'Abdullah: Allah's Apostle was on a journey and saw a crowd of people, and a man was being shaded (by them). He asked, \"What is the matter?\" They said, \"He (the man) is fasting.\" The Prophet said, \"It is not righteousness that you fast on a journey.\"  (Bukhari, Book #31, Hadith #167)"},
		},
	}

}

//idFromUrl returns the id from the req.params
func idFromUrl(r *http.Request) (int, error) {
	parts := strings.Split(r.URL.String(), "/")
	if len(parts) != 3 {
		return 0, errors.New("Day Not Found")
	}

	id, err := strconv.Atoi(parts[len(parts)-1])
	if err != nil {
		return 0, errors.New("Not Found")
	}

	return id, nil
}

//GetHadith a day function
func (h *hadithHandlers) GetHadith(w http.ResponseWriter, r *http.Request) {

	enableCors(&w)
	defer h.Unlock()
	h.Lock()
	id, err := idFromUrl(r)
	log.Println(id)
	if err != nil {
		respondWithJSON(w, http.StatusOK, h.hadiths)
		return
	}

	if id >= len(h.hadiths) || id < 0 {
		respondWithError(w, http.StatusNotFound, "Hadith Not Found")
		return
	}

	respondWithJSON(w, http.StatusOK, h.hadiths[id])

}

func respondWithJSON(w http.ResponseWriter, code int, data interface{}) {
	jsonBytes, err := json.MarshalIndent(data, "", "\t")
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(err.Error()))
	}

	w.Header().Add("content-type", "application/json")
	w.WriteHeader(code)
	w.Write(jsonBytes)
}

func respondWithError(w http.ResponseWriter, code int, msg string) {
	respondWithJSON(w, code, map[string]string{
		"error": msg,
	})
}

func NewAyahHandlers() *ayahHandlers {
	return &ayahHandlers{
		ayahs: Ayahs{
			Ayah{1, "Al Baqara 2:183-186 \n183. O you who believe! Observing As-Saum (the fasting) is prescribed for you as it was prescribed for those before you, that you may become Al-Muttaqun (the pious - See V.2: 2). \n184. [Observing Saum (fasts)] for a fixed number of days, but if any of you is ill or on a journey, the same number (should be made up) from other days. And as for those who can fast with difficulty, (e.g. an old man), they have (a choice either to fast or) to feed a Miskin (poor person) (for every day). But whoever does good of his own accord, it is better for him. And that you fast is better for you if only you know. \n185. The month of Ramadan in which was revealed the Qur'an, a guidance for mankind and clear proofs for the guidance and the criterion (between right and wrong). So whoever of you sights (the crescent on the first night of) the month (of Ramadan i.e. is present at his home), he must observe Saum (fasts) that month, and whoever is ill or on a journey, the same number [of days which one did not observe Saum (fasts) must be made up] from other days. Allah intends for you ease, and He does not want to make things difficult for you. (He wants that you) must complete the same number (of days), and that you must magnify Allah [i.e. to say Takbir (Allahu Akbar; Allah is the Most Great] for having guided you so that you may be grateful to Him.\n186. And when My slaves ask you (O Muhammad صلى الله عليه وسلم) concerning Me, then (answer them), I am indeed near (to them by My Knowledge). I respond to the invocations of the supplicant when he calls on Me (without any mediator or intercessor). So, let them obey Me and believe in Me, so that they may be led aright."},
			Ayah{2, "Al Iklas 112:1-4 In the name of God, the Gracious, the Merciful.\n1. Say, “He is God, the One.\n2. God, the Absolute.\n3. He begets not, nor was He begotten.\n4. And there is nothing comparable to Him."},
			Ayah{3, "Al Ahzaab 33:35&36\n35. Verily, the Muslims (those who submit to Allah in Islam) men and women, the believers men and women (who believe in Islamic Monotheism), the men and the women who are obedient (to Allah), the men and women who are truthful (in their speech and deeds), the men and the women who are patient (in performing all the duties which Allah has ordered and in abstaining from all that Allah has forbidden), the men and the women who are humble (before their Lord - Allah), the men and the women who give Sadaqat (i.e. Zakat, and alms), the men and the women who observe Saum (fast) (the obligatory fasting during the month of Ramadan, and the optional Nawafil fasting), the men and the women who guard their chastity (from illegal sexual acts) and the men and the women who remember Allah much with their hearts and tongues Allah has prepared for them forgiveness and a great reward (i.e. Paradise).\n36. It is not for a believer, man or woman, when Allah and His Messenger have decreed a matter that they should have any option in their decision. And whoever disobeys Allah and His Messenger, he has indeed strayed into a plain error."},
			Ayah{4, "Ad Dukhaan 44:2-4\n2. By the manifest Book (this Qur'an) that makes things clear.\n3. We sent it (this Qur'an) down on a blessed night [(i.e. night of Al-Qadr, Surah No. 97) in the month of Ramadan - the 9th month of the Islamic calendar]. Verily, We are ever warning [mankind that Our Torment will reach those who disbelieve in Our Oneness of Lordship and in Our Oneness of worship].\n4. Therein (that night) is decreed every matter of ordainments.\n"},
			Ayah{5, "Al-Hujuraat 49:13 \n13. O mankind! We have created you from a male and a female, and made you into nations and tribes, that you may know one another. Verily, the most honorable of you with Allah is that (believer) who has At-taqwa [i.e. he is one of the Muttaqun (the pious. See V.2:2)]. Verily, Allah is All-Knowing, All-Aware. \n(سورة الحجرات, Al-Hujuraat, Chapter #49, Verse #13)\n"},
			Ayah{6, "Al-Baqara 2:177 \nIt is not al-birr (piety, righteousness, and each and every act of obedience to Allah, etc.) that you turn your faces towards east and (or) west (in prayers); but al-birr is (the quality of) the one who believes in Allah, the Last Day, the Angels, the Book, the Prophets and gives his wealth, in spite of love for it, to the kinsfolk, to the orphans, and to Al-Masakin (the poor), and to the wayfarer, and to those who ask, and to set slaves free, performs As-Salat (Iqamat-as-Salat ), and gives the Zakat, and who fulfil their covenant when they make it, and who are patient in extreme poverty and ailment (disease) and at the time of fighting (during the battles). Such are the people of the truth and they are Al-Muttaqun (the pious)\n(سورة البقرة, Al-Baqara, Chapter #2, Verse #177)"},
			Ayah{7, "al-Imraan 3:92 \nBy no means shall you attain al-birr (piety, righteousness - here it means Allah's Reward, i.e. Paradise), unless you spend (in Allah's Cause) of that which you love; and whatever of good you spend, Allah knows it well \n(سورة آل عمران, Aal-i-Imraan, Chapter #3, Verse #92)"},
			Ayah{8, "Al-Haaqqa 69:48 \nAnd verily, this (Qur'an) is a Reminder for the Muttaqun (the pious. See V.2:2). (سورة الحاقة, Al-Haaqqa, Chapter #69, Verse #48)"},
			Ayah{9, "Al-Qadr 97:1-5 \nBismi Allahi alrrahmani alrraheemi\n1. Verily, We have sent it (this Qur'an) down in the night of Al-Qadr (Decree).\n2. And what will make you know what the night of Al-Qadr (Decree) is?\n3. The night of Al-Qadr (Decree) is better than a thousand months (i.e. worshipping Allah in that night is better than worshipping Him a thousand months, i.e. 83 years and 4 months).\n4. Therein descend the angels and the Ruh [Jibril (Gabril)] by Allah's Permission with all Decrees,\n5. (All that night), there is Peace (and Goodness from Allah to His believing slaves) until the appearance of dawn."},
			Ayah{10, "Al-Muzzammil 73:20 \nVerily, your Lord knows that you do stand (to pray at night) a little less than two thirds of the night, or half the night, or a third of the night, and also a party of those with you. And Allah measures the night and the day. He knows that you are unable to pray the whole night, so He has turned to you (in mercy). So, recite you of the qur'an as much as may be easy for you. He knows that there will be some among you sick, others travelling through the land, seeking of Allah's Bounty, yet others fighting in Allah's Cause. So recite as much of the qur'an as may be easy (for you), and perform As-Salat (Iqamat-as-Salat ) and give Zakat, and lend to Allah a goodly loan. And whatever good you send before you for yourselves (i.e. Nawafil non-obligatory acts of worship: prayers, charity, fasting, Hajj and 'Umrah), you will certainly find it with Allah, better and greater in reward. And seek Forgiveness of Allah. Verily, Allah is Oft-Forgiving, Most-Merciful.\n(سورة المزمل, Al-Muzzammil, Chapter #73, Verse #20)"},
			Ayah{11, "Al-Qiyaama, 75:16-19) \n16. Move not your tongue concerning (the Qur'an, O Muhammad صلى الله عليه وسلم) to make haste therewith. \n17. It is for Us to collect it and to give you (O Muhammad صلى الله عليه وسلم) the ability to recite it (the Qur'an).\n18. And when We have recited it to you [O Muhammad صلى الله عليه وسلم through Jibril (Gabriel)], then follow its (the Qur'an's) recital.\n19. Then it is for Us (Allah) to make it clear (to you)."},
			Ayah{12, "Al-Insaan, Chapter #76:29&30 \n29. Verily, this (Verse of the Qur'an) is an admonition, so whosoever wills, let him take a Path to his Lord (Allah). \n30. But you cannot will it, unless Allah wills it. Verily, Allah is Ever All-Knowing, All-Wise. \nAnd verily, this (qur'an) is a Reminder for the Muttaqun (the pious. See V.2:2) \n(سورة الحاقة, Al-Haaqqa, Chapter #69, Verse #48)"},
			Ayah{13, "And verily, this (qur'an) is a Reminder for the Muttaqun (the pious. See V.2:2).\n(سورة الحاقة, Al-Haaqqa, Chapter #69, Verse #48)"},
			Ayah{14, "Al-Muzzammil 73:1-4 \nBismi Allahi alrrahmani alrraheemi \n1. O you wrapped in garments (i.e. Prophet Muhammad صلى الله عليه وسلم)! \n2. Stand (to pray) all night, except a little - \n3. Half of it or a little less than that, \n4. Or a little more. And recite the Qur'an (aloud) in a slow, (pleasant tone and) style."},
			Ayah{15, "Say (O Muhammad صلى الله عليه وسلم to mankind): \"If you (really) love Allah then follow me (i.e. accept Islamic Monotheism, follow the Qur’an and the Sunnah), Allah will love you and forgive you your sins. And Allah is Oft-Forgiving, Most Merciful.\"\n(سورة آل عمران, Aal-i-Imraan, Chapter #3, Verse #31)"},
			Ayah{16, "And hold fast, all of you together, to the Rope of Allah (i.e. this Qur’an), and be not divided among yourselves , and remember Allah's Favor on you, for you were enemies one to another but He joined your hearts together, so that, by His Grace, you became brethren (in Islamic Faith), and you were on the brink of a pit of Fire, and He saved you from it. Thus, Allah makes His Ayat (proofs, evidence, verses, lessons, signs, revelations, etc.,) clear to you, that you may be guided.\n(سورة آل عمران, Aal-i-Imraan, Chapter #3, Verse #103)"},
			Ayah{17, "This (the qur'an) is a plain statement for mankind, a guidance and instruction to those who are Al-Muttaqun (the pious).\n(سورة آل عمران, Aal-i-Imraan, Chapter #3, Verse #138)"},
			Ayah{18, "O mankind! Verily, there has come to you a convincing proof (Prophet Muhammad صلى الله عليه وسلم) from your Lord; and We sent down to you a manifest light (this qur'an).\n(سورة النساء, An-Nisaa, Chapter #4, Verse #174)\n"},
			Ayah{19, "And We have sent down to you (O Muhammad صلى الله عليه وسلم) the Book (this qur'an) in truth, confirming the Scripture that came before it and Muhaymin (trustworthy in highness and a witness) over it (old Scriptures) . So judge among them by what Allah has revealed, and follow not their vain desires, diverging away from the truth that has come to you. To each among you, We have prescribed a law and a clear way. If Allah had willed, He would have made you one nation, but that (He) may test you in what He has given you; so compete in good deeds. The return of you (all) is to Allah; then He will inform you about that in which you used to differ.\n(سورة المائدة, Al-Maaida, Chapter #5, Verse #48)"},
			Ayah{20, "But no, by your Lord, they can have no faith, until they make you (o Muhammad صلى الله عليه وسلم) judge in all disputes between them, and find in themselves no resistance against your decisions, and accept (them) with full submission.\n(سورة النساء, An-Nisaa, Chapter #4, Verse #65)"},
			Ayah{21, "Ayah 7"},
			Ayah{22, "Ayah 7"},
			Ayah{23, "Ayah 7"},
			Ayah{24, "Ayah 7"},
			Ayah{25, "Ayah 7"},
		},
	}

}

//Ayahs type
type Ayahs []Ayah

//Ayah struct
type Ayah struct {
	Day  int    `json:"Day"`
	Text string `json:"Text"`
}
type ayahHandlers struct {
	ayahs Ayahs
}

//GetAyahs function sends ayahs as JSON
func (h *ayahHandlers) GetAyahs(w http.ResponseWriter, r *http.Request) {
	enableCors(&w)
	id, err := idFromUrl(r)
	log.Println(id)
	if err != nil {
		respondWithJSON(w, http.StatusOK, h.ayahs)
		return
	}
	log.Print("After if ", id)

	if id >= len(h.ayahs) || id < 0 {
		respondWithError(w, http.StatusNotFound, "Hadith Not Found")
		return
	}

	respondWithJSON(w, http.StatusOK, h.ayahs[id])

}

func enableCors(w *http.ResponseWriter) {
	(*w).Header().Set("Access-Control-Allow-Origin", "*")
}

func getDayNumber(day int) int {
	fmt.Println(day)
	day++
	return day
}
