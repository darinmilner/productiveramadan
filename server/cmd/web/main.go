package main

import (
	"encoding/gob"
	"log"
	"net/http"
	"time"

	"github.com/alexedwards/scs/v2"
	"github.com/darinmilner/productiveapp/internal/config"
	"github.com/darinmilner/productiveapp/internal/handlers"
	"github.com/darinmilner/productiveapp/internal/models"
	"github.com/darinmilner/productiveapp/internal/render"
)

const portNumber = ":8001"

var session *scs.SessionManager
var app config.AppConfig

func main() {

	err := run()
	log.Println("Server running on port: ", portNumber)
	srv := &http.Server{
		Addr:    portNumber,
		Handler: routes(&app),
	}

	err = srv.ListenAndServe()
	log.Fatal(err)
}

func run() error {

	//put into the session
	gob.Register(models.Signup{})

	//Change to true when in production
	app.InProduction = false
	session = scs.New()
	session.Lifetime = 24 * time.Hour

	session.Cookie.Persist = true
	session.Cookie.SameSite = http.SameSiteLaxMode
	session.Cookie.Secure = app.InProduction //True in Production

	app.Session = session

	tc, err := render.CreateTemplateCache()
	if err != nil {
		log.Fatal("Can not create template cache")
		return err
	}

	app.TemplateCache = tc
	app.UseCache = false

	repo := handlers.NewRepo(&app)

	handlers.NewHandlers(repo)

	render.NewTemplates(&app)

	return nil
}
