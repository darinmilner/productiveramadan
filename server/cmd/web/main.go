package main

import (
	"log"
	"net/http"

	"github.com/darinmilner/productiveapp/pkg/config"
	"github.com/darinmilner/productiveapp/pkg/handlers"
	"github.com/darinmilner/productiveapp/pkg/render"
)

const portNumber = ":8000"

func main() {
	var app config.AppConfig
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

	log.Println("Server running on port: ", portNumber)
	srv := &http.Server{
		Addr:    portNumber,
		Handler: routes(&app),
	}

	err = srv.ListenAndServe()
	log.Fatal(err)
}