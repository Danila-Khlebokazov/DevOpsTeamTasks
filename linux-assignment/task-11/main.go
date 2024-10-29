package main

import (
	"fmt"
	"net/http"
	"os"
)

func healthCheckHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	_, err := fmt.Fprintln(w, "Service is healthy")
	if err != nil {
		return
	}
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Port not specified. Usage: ./api_service <port>")
		os.Exit(1)
	}
	port := os.Args[1] // obtaining port from command line, second argument

	http.HandleFunc("/health", healthCheckHandler)

	fmt.Println("Starting server on port", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		fmt.Println("Server failed to start:", err)
	}
}
