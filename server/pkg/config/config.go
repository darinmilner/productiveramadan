package config

import "html/template"

//AppConfig has the application config
type AppConfig struct {
	UseCache      bool
	TemplateCache map[string]*template.Template
	InProduction  bool
}
