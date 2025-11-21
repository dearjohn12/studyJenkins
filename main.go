package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func main() {
	engine := gin.Default()
	engine.Handle(http.MethodGet, "/hello", func(c *gin.Context) {
		c.JSON(200, "你好吧")
	})
	engine.Run(":8181")
}
