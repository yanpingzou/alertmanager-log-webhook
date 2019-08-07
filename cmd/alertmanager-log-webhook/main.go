package main

import (
	"io"
	"io/ioutil"
	"net/http"
	"os"
	"time"

	"github.com/gorilla/mux"
	jsoniter "github.com/json-iterator/go"
	"github.com/prometheus/common/version"
	log "github.com/sirupsen/logrus"
	"github.com/yanpingzou/alertmanager-log-webhook/model"
	"gopkg.in/alecthomas/kingpin.v2"
)

const (
	// DefaultRequestTimeout default timeout from invoking log webhook.
	DefaultRequestTimeout = 15 * time.Second
)

var (
	listenAddress  = kingpin.Flag("web.listen-address", "Address to listen on for the web interface and API.").Default(":8061").String()
	requestTimeout = kingpin.Flag("log.timeout", "Timeout from invoking log webhook.").Default(DefaultRequestTimeout.String()).Duration()
)

func init() {
	file, err := os.OpenFile("/volumes_logs/alerts.log", os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0666)
	if err != nil {
		log.Fatal(err)
	}

	log.SetFormatter(&log.JSONFormatter{})
	// log.SetOutput(os.Stdout)
	log.SetOutput(file)
	log.SetLevel(log.InfoLevel)
}

// WebhookHandler write alertmanager alerts to file.
func WebhookHandler(w http.ResponseWriter, r *http.Request) {
	// var req map[string]interface{}
	var notification model.Notification
	body, _ := ioutil.ReadAll(r.Body)
	defer r.Body.Close()

	var json = jsoniter.ConfigCompatibleWithStandardLibrary
	json.Unmarshal(body, &notification)

	for i := 0; i < len(notification.Alerts); i++ {
		if notification.Alerts[i].Status == model.AlertResolved {
			notification.Alerts[i].Duration = (notification.Alerts[i].EndsAt.UnixNano() - notification.Alerts[i].StartsAt.UnixNano()) / 1e9
		}
		notification.Alerts[i].UnixStartsAt = notification.Alerts[i].StartsAt.UnixNano() / 1e6
		notification.Alerts[i].SendsAt = time.Now().UnixNano() / 1e6
		alert, _ := json.Marshal(notification.Alerts[i])
		log.Info(string(alert))
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	io.WriteString(w, `success`)
}

func main() {
	kingpin.Version(version.Print("alertmanager-log-webhook"))
	kingpin.HelpFlag.Short('h')
	kingpin.Parse()

	r := mux.NewRouter()
	r.HandleFunc("/webhook", WebhookHandler).Methods("POST")

	srv := &http.Server{
		Handler:      r,
		Addr:         *listenAddress,
		WriteTimeout: *requestTimeout,
		ReadTimeout:  *requestTimeout,
	}

	log.Fatal(srv.ListenAndServe())
}
