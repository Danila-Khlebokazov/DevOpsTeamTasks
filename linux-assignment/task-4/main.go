package main

import (
	"fmt"
	"github.com/gorilla/mux"
	"net/http"
)

func main() {
	router := mux.NewRouter()

	router.HandleFunc("/health-check", HealthCheck).Methods("GET")

	router.HandleFunc("/", HomePage).Methods("GET")

	router.HandleFunc("/{name}", HiName).Methods("GET")

	//router.HandleFunc("/file", UploadFile).Methods("POST")
	http.ListenAndServe(":8080", router)
}

func HealthCheck(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	fmt.Println("App health checked")
	w.Write([]byte("OK"))
}

func HomePage(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("hi\nwrite your name in url like in example: url/<your name>"))
	fmt.Println("Home page works")
}

func HiName(w http.ResponseWriter, r *http.Request) {
	name := mux.Vars(r)["name"]
	fmt.Println("name is " + name)
	fmt.Println("HiName works")
	w.Write([]byte("hi, " + name))
}
