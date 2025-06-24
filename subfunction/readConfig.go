/*
 *  Powered By Luckykeeper <luckykeeper@luckykeeper.site | https://luckykeeper.site | https://github.com/luckykeeper>
 *  @CreateTime   : 2025-6-16 10:40
 *  @Author       : Luckykeeper
 *  @Contact      : https://github.com/luckykeeper | https://luckykeeper.site
 *  @Email        : luckykeeper@luckykeeper.site
 *  @project      : yakushiinL2S
 */

package subfunction

import (
	"github.com/sirupsen/logrus"
	"github.com/spf13/viper"
	"yakushiinL2S/model"
)

func ReadConfig() {
	viper.SetConfigName("config")
	viper.SetConfigType("yaml")
	viper.AddConfigPath(".")
	if err := viper.ReadInConfig(); err != nil {
		if _, ok := err.(viper.ConfigFileNotFoundError); ok {
			logrus.Infoln("没有找到本地配置文件，从环境变量获取配置信息")
			bindEnv()
		} else {
			logrus.Infoln("配置文件校验失败，从环境变量获取配置信息")
			bindEnv()
		}
	}
	viper.SetDefault("DebugMode", false)
	viper.SetDefault("LogLevel", 4)
	viper.SetDefault("ApiPort", "44443")
	err := viper.Unmarshal(&model.YakushiinConfig)
	if err != nil {
		logrus.Warnln("配置文件解析失败:", err)
	}
	logrus.Infoln("配置文件读取完成")
}

func bindEnv() {
	viper.AllowEmptyEnv(false)
	viper.AutomaticEnv()
	viper.BindEnv("debugMode", "debugMode")
	viper.BindEnv("logLevel", "logLevel")
	viper.BindEnv("apiPort", "apiPort")
}
