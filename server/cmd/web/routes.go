package main

import (
	"log"
	"net/http"

	"github.com/darinmilner/productiveapp/pkg/config"
	"github.com/darinmilner/productiveapp/pkg/handlers"
	"github.com/go-chi/chi"
)

func routes(app *config.AppConfig) http.Handler {
	mux := chi.NewRouter()

	mux.Use(WriteToConsole)

	hadithHandler := handlers.NewHadithHandlers()
	mux.Get("/", handlers.Repo.Home)
	mux.Get("/about", handlers.Repo.About)
	mux.Get("/hadiths", hadithHandler.GetHadith)

	fileServer := http.FileServer(http.Dir("./static/"))

	mux.Handle("/static/*", http.StripPrefix("/static", fileServer))

	return mux
}

//WriteToConsole middleware--USELESS
func WriteToConsole(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Println("Hit the page")
		next.ServeHTTP(w, r)
	})
}
