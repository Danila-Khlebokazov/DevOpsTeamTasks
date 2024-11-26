package main

import (
	"context"
	"flag"
	"log"
	"math/rand"
	"net/http"
	"os"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5"
	"github.com/joho/godotenv"
)

type User struct {
	UserID   string
	DeviceID string
}

type Movie struct {
	MovieID     string    `json:"movie_id"`
	Title       string    `json:"title"`
	Genre       string    `json:"genre"`
	ReleaseDate time.Time `json:"release_date"`
}

var users []User
var DB_URL string

func GetAllUsers() {
	conn, err := pgx.Connect(context.Background(), DB_URL)
	if err != nil {
		log.Fatal("Error connecting to DB at startup: ", err)
	}
	defer conn.Close(context.Background())
	rows, err := conn.Query(context.Background(), "select user_id, device_id from public.user")
	if err != nil {
		log.Fatal("Error getting all users at startup: ", err)
	}
	defer rows.Close()
	for rows.Next() {
		var user User
		err := rows.Scan(&user.UserID, &user.DeviceID)
		if err != nil {
			log.Fatal("Error scanning user at startup: ", err)
		}
		users = append(users, user)
	}
}

func GetRandomRecs(ctx *gin.Context, by_device_id bool) {
	conn, err := pgx.Connect(ctx, DB_URL)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	defer conn.Close(ctx)
	user := users[rand.Intn(len(users))]
	var rows pgx.Rows
	if by_device_id {
		rows, err = conn.Query(ctx, "select * from get_recommendations_by_device_id($1)", user.DeviceID)
	} else {
		rows, err = conn.Query(ctx, "select * from get_recommendations_by_user_id($1)", user.UserID)
	}
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	defer rows.Close()
	movies := make([]Movie, 0)
	for rows.Next() {
		var movie Movie
		err := rows.Scan(&movie.MovieID, &movie.Title, &movie.Genre, &movie.ReleaseDate)
		if err != nil {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		movies = append(movies, movie)
	}
	ctx.JSON(http.StatusOK, gin.H{
		"user_id":        user.UserID,
		"device_id":      user.DeviceID,
		"recomendations": movies,
	})
}

func main() {
	if err := godotenv.Load(".env"); err != nil {
		log.Println("Error loading .env file\n" + err.Error())
	}
	DB_URL = os.Getenv("DATABASE_URL")
	// var err error
	// dbconn, err = pgxpool.New(context.Background(), os.Getenv("DATABASE_URL"))
	// if err != nil {
	// 	log.Fatal("Unable to create connection: ", err)
	// }
	GetAllUsers()

	if os.Getenv("RELEASE") == "true" {
		gin.SetMode(gin.ReleaseMode)
	}

	r := gin.New()

	r.GET("by_device_id/", func(ctx *gin.Context) {
		GetRandomRecs(ctx, true)
	})
	r.GET("by_user_id/", func(ctx *gin.Context) {
		GetRandomRecs(ctx, false)
	})
	log.Println("Server started")

	//obtaining port from env
	flag.Parse()
	log.Println(flag.Args())
	port := "8000"
	if len(flag.Args()) == 1 {
		port = flag.Args()[0]
	}
	if err := r.Run(":" + port); err != nil {
		log.Fatal(err)
	}
}
