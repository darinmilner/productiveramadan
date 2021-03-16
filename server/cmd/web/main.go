package main

import (
	"log"
	"net/http"

	"github.com/darinmilner/productiveapp/internal/config"
	"github.com/darinmilner/productiveapp/internal/handlers"
	"github.com/darinmilner/productiveapp/internal/render"
)

const portNumber = ":8001"

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

	tc, err := render.CreateTemplateCache()
	if err != nil {
		log.Fatal("Can not create template cache")
	}

	//Change to true when in production
	app.InProduction = false

	app.TemplateCache = tc
	app.UseCache = false

	repo := handlers.NewRepo(&app)

	handlers.NewHandlers(repo)

	render.NewTemplates(&app)

	return nil
}
