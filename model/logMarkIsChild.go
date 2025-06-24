/*
 *  Powered By Luckykeeper <luckykeeper@luckykeeper.site | https://luckykeeper.site | https://github.com/luckykeeper>
 *  @CreateTime   : 2025-6-16 10:27
 *  @Author       : Luckykeeper
 *  @Contact      : https://github.com/luckykeeper | https://luckykeeper.site
 *  @Email        : luckykeeper@luckykeeper.site
 *  @project      : yakushiinL2S
 */

package model

import "github.com/gofiber/fiber/v2"

func LogMarkIsChild() string {
	if !fiber.IsChild() {
		return "[YakushiinSelf]"
	} else {
		return "[YakushiinFork]"
	}
}
