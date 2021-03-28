package main

import (
	"context"
	"encoding/gob"
	"flag"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/alexedwards/scs/v2"
	"github.com/darinmilner/productiveapp/internal/config"
	"github.com/darinmilner/productiveapp/internal/handlers"
	"github.com/darinmilner/productiveapp/internal/models"
	"github.com/darinmilner/productiveapp/internal/render"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

const portNumber = ":8001"

var session *scs.SessionManager
var app config.AppConfig

var infoLog *log.Logger
var errorLog *log.Logger

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

	//read flags
	inProduction := flag.Bool("production", true, "Application is in production")
	useCache := flag.Bool("cache", true, "Use Template cache")

	//dbName := flag.String("dbname", "", "db name")
	//dbConnectionString := flag.String("dbstring", "", "db connection string")
	// dbUser := flag.String("dbuser", "", "db user")
	// dbPass := flag.String("dbpass", "", "db password")
	//dbPort := flag.String("dbport", "", "db port")
	//dbSSL := flag.String("dbssl", "disable", "db ssl setting")

	flag.Parse()
	//Change to true when in production

	// if *dbConnectionString == "" {
	// 	log.Print("Mongo DB connection string missing")
	// 	os.Exit(1)
	// }
	app.InProduction = *inProduction

	//Info log
	infoLog = log.New(os.Stdout, "INFO\t", log.Ldate|log.Ltime)

	app.InfoLog = infoLog

	errorLog = log.New(os.Stdout, "ERROR\t", log.Ldate|log.Ltime|log.Lshortfile)
	app.ErrorLog = errorLog

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
	app.UseCache = *useCache

	ctx, _ := context.WithTimeout(context.Background(), 10*time.Second)

	//connectionString := fmt.Sprintf("%s", *&dbConnectionString)
	clientOptions := options.Client().ApplyURI(config.DbConnectionString)
	config.Client, _ = mongo.Connect(ctx, clientOptions)

	repo := handlers.NewRepo(&app)

	handlers.NewHandlers(repo)

	render.NewTemplates(&app)

	return nil
}
