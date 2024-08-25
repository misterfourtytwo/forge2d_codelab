package main

import (
	"github.com/gin-contrib/cors"
	"github.com/gin-contrib/static"
	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	r.Use(func() gin.HandlerFunc {
		return func(context *gin.Context) {
			context.Writer.Header().Set("Cross-Origin-Embedder-Policy", "credentialless")
			context.Writer.Header().Set("Cross-Origin-Opener-Policy", "same-origin")
		}
	}())

	r.Use(cors.Default())
	r.Use(static.Serve("/", static.LocalFile("./static", false)))
	println("visit app at http://localhost:4242")
	r.Run(":4242")
}
