/*
 *  Powered By Luckykeeper <luckykeeper@luckykeeper.site | https://luckykeeper.site | https://github.com/luckykeeper>
 *  @CreateTime   : 2025-6-16 10:31
 *  @Author       : Luckykeeper
 *  @Contact      : https://github.com/luckykeeper | https://luckykeeper.site
 *  @Email        : luckykeeper@luckykeeper.site
 *  @project      : yakushiinL2S
 */

package model

import (
	"bytes"
	"github.com/sirupsen/logrus"
)

type YakushiinFormatter struct {
	BaseFormatter logrus.TextFormatter
	Prefix        string
}

func (f *YakushiinFormatter) Format(entry *logrus.Entry) ([]byte, error) {
	baseOutput, err := f.BaseFormatter.Format(entry)
	if err != nil {
		return nil, err
	}

	var buffer bytes.Buffer
	buffer.WriteString(f.Prefix)
	buffer.WriteString(" ")
	buffer.Write(baseOutput)

	return buffer.Bytes(), nil
}
