package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
)

func main() {
	a := 1
	b := 2
	resp, err := http.Get(fmt.Sprintf("http://127.0.0.1:3000/sum/%d/%d", a, b))
	if err != nil {
		log.Fatalln(err)
	}
	//We Read the response body on the line below.
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Fatalln(err)
	}
	//Convert the body to type string
	sb := string(body)
	fmt.Printf("%s\n", sb)
}
