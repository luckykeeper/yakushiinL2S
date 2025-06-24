/*
 *  Powered By Luckykeeper <luckykeeper@luckykeeper.site | https://luckykeeper.site | https://github.com/luckykeeper>
 *  @CreateTime   : 2025-6-16 10:44
 *  @Author       : Luckykeeper
 *  @Contact      : https://github.com/luckykeeper | https://luckykeeper.site
 *  @Email        : luckykeeper@luckykeeper.site
 *  @project      : yakushiinL2S
 */

package router

import (
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/compress"
	"github.com/gofiber/fiber/v2/middleware/etag"
	"github.com/gofiber/fiber/v2/middleware/filesystem"
	"github.com/gofiber/fiber/v2/middleware/helmet"
	"github.com/sirupsen/logrus"
	"net/http"
	"os"
	"os/signal"
	"time"
	"yakushiinL2S/assets"
	"yakushiinL2S/handler/apiV1"
	"yakushiinL2S/handler/checkPoints"
	"yakushiinL2S/model"
)

var (
	YakushiinServer *fiber.App
)

func StartApiServer() {
	YakushiinServer = fiber.New(fiber.Config{
		ServerHeader:          "YakushiinServer By Luckykeeper<https://github.com/luckykeeper>",
		StrictRouting:         false,
		CaseSensitive:         false,
		UnescapePath:          true,
		BodyLimit:             512 * 1024 * 1024,
		ReadBufferSize:        4 * 1024,
		WriteBufferSize:       4 * 1024,
		AppName:               "YakushiinL2S " + model.AppVersion,
		EnableIPValidation:    true,
		DisableStartupMessage: false,
		EnablePrintRoutes:     model.YakushiinConfig.DebugMode,
		Prefork:               !model.YakushiinConfig.DebugMode,
	})

	YakushiinServer.Use(etag.New())

	YakushiinServer.Use(compress.New(compress.Config{
		Level: compress.LevelBestSpeed,
	}))

	YakushiinServer.Use(helmet.New(helmet.Config{
		XSSProtection: "1; mode=block",
	}))

	YakushiinServer.Get("/", func(ctx *fiber.Ctx) error {
		var err error
		err = ctx.Redirect("/l2s")
		if err != nil {
			logrus.Errorln("Redirect error:", err)
			return ctx.Status(fiber.StatusBadGateway).SendString("Failed to Redirect")
		}
		return nil
	})

	checkPointRouter := YakushiinServer.Group("/checkPoint")
	checkPointRouter.Get("/ready", checkPoints.ServiceReady)
	checkPointRouter.Get("/liveness", checkPoints.ServiceReady)

	YakushiinServer.Use("/l2s", filesystem.New(filesystem.Config{
		Root:       http.FS(assets.WebappFiles),
		PathPrefix: "webapp",
	}))

	apiRouter := YakushiinServer.Group("/api")
	apiV1Router := apiRouter.Group("/v1")
	apiV1Router.Post("/lrcToSrt", apiV1.LrcToSrt)

	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)
	go func() {
		_ = <-c
		logrus.Warnln("Shutting Down YakushiinServer Gracefully With Max Lifetime 15 Seconds...")
		err := YakushiinServer.ShutdownWithTimeout(15 * time.Second)
		if err != nil {
			logrus.Errorln("YakushiinServer Gracefully Shutting Down ==> ", err)
		} else {
			logrus.Infoln("YakushiinServer Has Gracefully Shutdown")
		}
	}()

	err := YakushiinServer.Listen(":" + model.YakushiinConfig.ApiPort)
	if err != nil {
		logrus.Fatalln("YakushiinServer ListenAndServe @:", model.YakushiinConfig.ApiPort, " err:", err)
	}
	logrus.Infoln("Has Completed!")
}
