/*
 *  Powered By Luckykeeper <luckykeeper@luckykeeper.site | https://luckykeeper.site | https://github.com/luckykeeper>
 *  @CreateTime   : 2025-6-16 15:35
 *  @Author       : Luckykeeper
 *  @Contact      : https://github.com/luckykeeper | https://luckykeeper.site
 *  @Email        : luckykeeper@luckykeeper.site
 *  @project      : yakushiinL2S
 */

package model

type LrcToSrtAppRequest struct {
	OriginLrc string `json:"originLrc"` // LRC 歌词，前端转成 String
	StartLine int    `json:"startLine"` // 从第几行开始，从 1 开始计算。默认 1
	// 三选一开关，如果都是 false ，保留双语。默认：保留双语
	PersevereOnlyFirstLanguage  bool `json:"persevereOnlyFirstLanguage"`  // 只保留第一种语言
	PersevereOnlySecondLanguage bool `json:"persevereOnlySecondLanguage"` // 只保留第二种语言
	// 三选一开关，模式：相同时间轴合并，相邻时间轴合并，如果都是 false ，不要合并。默认：相邻时间轴合并
	MergeSameDuration    bool `json:"mergeSameDuration"`    // 相同时间轴合并
	MergeNearestDuration bool `json:"mergeNearestDuration"` // 相邻时间轴合并
}

type LrcToSrtServerReturn struct {
	TargetSrtContent string `json:"targetSrtContent"` // 转换好的 SRT 歌词
	StatusCode       int    `json:"statusCode"`
	StatusMessage    string `json:"statusMessage"`
}
