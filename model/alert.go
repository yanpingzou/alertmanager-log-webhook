package model

import "time"

const (
	// AlertFiring firing
	AlertFiring string = "firing"
	// AlertResolved resolved
	AlertResolved string = "resolved"
)

// Alert is a generic representation of an alert in the Prometheus eco-system.
type Alert struct {
	Labels       map[string]string `json:"labels"`
	Annotations  map[string]string `json:"annotations"`
	StartsAt     time.Time         `json:"startsAt,omitempty"`
	EndsAt       time.Time         `json:"endsAt,omitempty"`
	SendsAt      int64             `json:"sendsAt,omitempty"`
	Status       string            `json:"status"`
	UnixStartsAt int64             `json:"unixStartsAt"`
	Duration     int64             `json:"duration,omitempty"`
}

// Notification contains a several alerts from Prometheus eco-system.
type Notification struct {
	Version  string  `json:"version"`
	Status   string  `json:"status"`
	Receiver string  `json:"receiver"`
	Alerts   []Alert `json:"alerts"`
}
