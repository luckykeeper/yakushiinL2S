/*
 *  Powered By Luckykeeper <luckykeeper@luckykeeper.site | https://luckykeeper.site | https://github.com/luckykeeper>
 *  @CreateTime   : 2025-6-16 10:50
 *  @Author       : Luckykeeper
 *  @Contact      : https://github.com/luckykeeper | https://luckykeeper.site
 *  @Email        : luckykeeper@luckykeeper.site
 *  @project      : yakushiinL2S
 */

package checkPoints

import (
	"github.com/gofiber/fiber/v2"
	"net/http"
	"yakushiinL2S/model"
)

func ServiceReady(ctx *fiber.Ctx) error {
	var serviceStatus model.CheckPoint
	serviceStatus.AppName = "YakushiinL2S - Powered By Luckykeeper <https://github.com/luckykeeper | https://luckykeeper.site>"
	serviceStatus.Version = model.AppVersion
	serviceStatus.ServerMessage = model.StartUpString
	serviceStatus.StatusCode = http.StatusOK
	return ctx.Status(http.StatusOK).JSON(serviceStatus)

}
