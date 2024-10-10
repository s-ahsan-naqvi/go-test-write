package main

import (
    "database/sql"
    "fmt"
    "log"
    "net/http"
    "time"
    _ "github.com/lib/pq"
)

const (
    host     = "localhost"
    port     = 5432
    user     = "myuser"
    password = "mypassword"
    dbname   = "testdb"
)

func main() {
    connStr := fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=disable",
        host, port, user, password, dbname)
    db, err := sql.Open("postgres", connStr)
    if err != nil {
        log.Fatal(err)
    }
    defer db.Close()

    http.HandleFunc("/write", func(w http.ResponseWriter, r *http.Request) {
        start := time.Now()
        content := "Hello from Go"
        _, err := db.Exec("INSERT INTO test_table (content) VALUES ($1)", content)
        if err != nil {
            log.Fatal(err)
        }
        duration := time.Since(start)
        fmt.Fprintf(w, "Write completed in %v", duration)
    })

    log.Println("Server is listening on http://localhost:3001")
    log.Fatal(http.ListenAndServe(":3001", nil))
}
