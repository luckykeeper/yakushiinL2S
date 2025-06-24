/*
 *  Powered By Luckykeeper <luckykeeper@luckykeeper.site | https://luckykeeper.site | https://github.com/luckykeeper>
 *  @CreateTime   : 2025-6-16 10:39
 *  @Author       : Luckykeeper
 *  @Contact      : https://github.com/luckykeeper | https://luckykeeper.site
 *  @Email        : luckykeeper@luckykeeper.site
 *  @project      : yakushiinL2S
 */

package model

var YakushiinConfig Config

type Config struct {
	DebugMode bool   `json:"debugMode" yaml:"DebugMode"`
	LogLevel  uint32 `json:"logLevel" yaml:"LogLevel"` // Debug:5 | Info:4 | Warn: 3 | Error:2 | Fatal:1
	ApiPort   string `json:"apiPort" yaml:"ApiPort"`
}
