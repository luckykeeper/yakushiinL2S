/*
 *  Powered By Luckykeeper <luckykeeper@luckykeeper.site | https://luckykeeper.site | https://github.com/luckykeeper>
 *  @CreateTime   : 2025-6-16 10:24
 *  @Author       : Luckykeeper
 *  @Contact      : https://github.com/luckykeeper | https://luckykeeper.site
 *  @Email        : luckykeeper@luckykeeper.site
 *  @project      : yakushiinL2S
 */

package main

import (
	"github.com/gofiber/fiber/v2"
	"github.com/sirupsen/logrus"
	"os"
	"time"
	"yakushiinL2S/model"
	"yakushiinL2S/router"
	"yakushiinL2S/subfunction"
)

func init() {
	logrus.SetOutput(os.Stdout)
	logrus.SetLevel(logrus.Level(5))
	logrus.SetFormatter(&model.YakushiinFormatter{
		BaseFormatter: logrus.TextFormatter{
			DisableColors:   false,
			TimestampFormat: time.RFC3339,
			ForceColors:     true,
			FullTimestamp:   true,
		},
		Prefix: "※ L2S ※ " + model.LogMarkIsChild(),
	})
	logrus.Infoln("Project YakushiinL2S Start Initializing...")
	if !fiber.IsChild() {
		model.StartUpMessage()
	}
	subfunction.ReadConfig()
	if model.YakushiinConfig.DebugMode {
		logrus.Warnln("Start As Debug Mode! DO NOT USE THIS IN PRODUCTION ENVIRONMENT!!!")
	}
	logrus.Infoln("Project YakushiinL2S Has Been Initialized!")
}

func main() {
	router.StartApiServer()
}
