package handlers

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/darinmilner/productiveapp/pkg/config"
	"github.com/darinmilner/productiveapp/pkg/models"
	"github.com/darinmilner/productiveapp/pkg/render"
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
	render.RenderTemplates(w, "home.page.html", &models.TemplateData{})
}

//Home page function
func (m *Repository) About(w http.ResponseWriter, r *http.Request) {
	render.RenderTemplates(w, "about.page.html", &models.TemplateData{})
}

//Hadith defines the hadith structure
type Hadith struct {
	Day  int
	Text string
}

type hadithHandlers struct {
	hadith map[string]Hadith
}

func NewHadithHandlers() *hadithHandlers {
	return &hadithHandlers{
		hadith: map[string]Hadith{
			"id1": Hadith{
				Text: "Hadith1",
				Day:  1,
			},
			"id2": Hadith{
				Text: "Hadith2",
				Day:  2,
			},
		},
	}

}

//GetHadith a day function
func (h *hadithHandlers) GetHadith(w http.ResponseWriter, r *http.Request) {

	enableCors(&w)
	hadiths := make([]Hadith, len(h.hadith))
	//day := getDayNumber(index)
	index := 0
	for _, hadith := range h.hadith {
		hadiths[index] = hadith
		index++
	}

	jsonBytes, err := json.Marshal(hadiths)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(err.Error()))
	}

	w.Header().Add("content-type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write(jsonBytes)

}

func enableCors(w *http.ResponseWriter) {
	(*w).Header().Set("Access-Control-Allow-Origin", "*")
}

func getDayNumber(day int) int {
	fmt.Println(day)
	day++
	return day
}
