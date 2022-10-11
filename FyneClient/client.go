package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"

	"fyne.io/fyne/v2/app"
	"fyne.io/fyne/v2/container"
	"fyne.io/fyne/v2/widget"
)

func main() {
	myApp := app.New()
	myWindow := myApp.NewWindow("Entry Widget")

	inputA := widget.NewEntry()
	inputB := widget.NewEntry()
	result := ""
	out := widget.NewLabel(result)

	inputA.SetPlaceHolder("Enter text...")
	inputB.SetPlaceHolder("Enter text...")

	content := container.NewHBox(inputA, inputB, out, widget.NewButton("Save", func() {
		log.Println("Content was:", inputA.Text, inputB.Text)
		result = Sum(inputA.Text, inputB.Text)
		out.SetText(result)
	}))

	myWindow.SetContent(content)

	myWindow.ShowAndRun()
}

func Sum(a string, b string) string {

	url := fmt.Sprintf("http://127.0.0.1:3000/sum/%s/%s", a, b)

	resp, err := http.Get(url)
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

	return fmt.Sprintf("%s", sb)

}
