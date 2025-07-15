package main

import (
	_ "embed"
	"fmt"
	"net/http"
)

//go:embed index.html
var indexHTML []byte

func main() {
	fmt.Println("🚀 Running terramock-app-frontend on :8080 ...")
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		w.Write(indexHTML)
	})
	http.ListenAndServe(":8080", nil)
}