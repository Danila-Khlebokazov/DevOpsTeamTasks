package main

import (
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
)

type user struct {
	Id       int     `json:"id"`
	Name     string  `json:"name"`
	Username string  `json:"username"`
	Email    string  `json:"email"`
	Address  address `json:"address"`
	Phone    string  `json:"phone"`
	Website  string  `json:"website"`
	Company  company `json:"company"`
}

type address struct {
	Street  string `json:"street"`
	Suite   string `json:"suite"`
	City    string `json:"city"`
	Zipcode string `json:"zipcode"`
	Geo     geo    `json:"geo"`
}

type geo struct {
	Latitude  string `json:"lat"`
	Longitude string `json:"lng"`
}

type company struct {
	Name        string `json:"name"`
	CatchPhrase string `json:"catchPhrase"`
	Bs          string `json:"bs"`
}

// FIXME - fix type formatting
func (u user) String() string {
	return fmt.Sprintf(
		"ID: %s\nName: %s\nUsername: %s\nEmail: %s\nAddress: %s\nPhone: %s\nWebsite: %s\nCompany: %s\n",
		u.Id, u.Name, u.Username, u.Email, u.Address, u.Phone, u.Website, u.Company)
}

func main() {
	client := http.Client{}

	url := "https://jsonplaceholder.typicode.com/users/1"

	resp, err := client.Get(url)

	if err != nil {
		log.Fatal(err.Error())
	}

	if resp.StatusCode != http.StatusOK {
		log.Fatal(err.Error())
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		log.Fatal(err.Error())
	}

	var user user
	if err := json.Unmarshal(body, &user); err != nil {
		log.Fatal(err.Error())
	}

	fmt.Println(user)
}
