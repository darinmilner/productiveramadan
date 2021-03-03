package models

//TemplateData sent from handlers to HTML templates
type TemplateData struct {
	StringMap map[string]string
	IntMap    map[string]int
	CSRFToken string
	FlashMsg  string
	Warning   string
	Error     string
}
