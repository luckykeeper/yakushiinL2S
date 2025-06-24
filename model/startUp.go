/*
 *  Powered By Luckykeeper <luckykeeper@luckykeeper.site | https://luckykeeper.site | https://github.com/luckykeeper>
 *  @CreateTime   : 2025-6-16 10:34
 *  @Author       : Luckykeeper
 *  @Contact      : https://github.com/luckykeeper | https://luckykeeper.site
 *  @Email        : luckykeeper@luckykeeper.site
 *  @project      : yakushiinL2S
 */

package model

import (
	"fmt"
	"os"
)

func StartUpMessage() {
	var count []rune
	fmt.Println(YakushiinLogo)
	fmt.Printf("\t\t\t\t\t\t\t%v\n", StartUpString)
	fmt.Printf("\t\t\t\t\t\t\t=========>Version:%v\n", AppVersion)
	for _, i := range YakushiinLogo {
		count = append(count, i)
	}
	for _, i := range StartUpString {
		count = append(count, i)
	}
	if !YakushiinConfig.DebugMode {
		startUpProtector(count)
	}
	fmt.Println("Powered By Luckykeeper <luckykeeper@luckykeeper.site | https://luckykeeper.site | https://github.com/luckykeeper>")
}

func startUpProtector(count []rune) {
	if len(count) != 1348 {
		os.Exit(1145141919810)
	}
}
