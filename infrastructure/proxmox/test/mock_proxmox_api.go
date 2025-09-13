package test

import (
	"context"
	"fmt"
	"log"
	"net/http"
)

func loggingMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Printf("received request: %s %s", r.Method, r.URL.Path)
		next.ServeHTTP(w, r)
	})
}

func startMockProxmoxAPI(ctx context.Context) *http.Server {
	mux := http.NewServeMux()
	mux.HandleFunc("/api2/json/access/users", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		fmt.Fprintln(w, `{"data":[{"userid":"user@pve"}]}`)
	})
	mux.HandleFunc("/api2/json/access/permissions", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		fmt.Fprintln(w, `{
			"data": {
				"/": {
					"Datastore.AllocateSpace": 1,
					"Datastore.Audit": 1,
					"Pool.Allocate": 1,
					"Sys.Audit": 1,
					"Sys.Console": 1,
					"Sys.Modify": 1,
					"VM.Allocate": 1,
					"VM.Audit": 1,
					"VM.Clone": 1,
					"VM.Config.CDROM": 1,
					"VM.Config.CPU": 1,
					"VM.Config.Cloudinit": 1,
					"VM.Config.Disk": 1,
					"VM.Config.HWType": 1,
					"VM.Config.Memory": 1,
					"VM.Config.Network": 1,
					"VM.Config.Options": 1,
					"VM.Migrate": 1,
					"VM.Monitor": 1,
					"VM.PowerMgmt": 1
				}
			}
		}`)
	})
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		// Catch-all for any other requests
		w.Header().Set("Content-Type", "application/json")
		fmt.Fprintln(w, `{}`)
	})

	server := &http.Server{
		Addr:    ":8006",
		Handler: loggingMiddleware(mux),
	}

	go func() {
		if err := server.ListenAndServeTLS("cert.pem", "key.pem"); err != nil && err != http.ErrServerClosed {
			panic(err)
		}
	}()

	go func() {
		<-ctx.Done()
		server.Shutdown(context.Background())
	}()

	return server
}
