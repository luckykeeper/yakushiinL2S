/*
 *  Powered By Luckykeeper <luckykeeper@luckykeeper.site | https://luckykeeper.site | https://github.com/luckykeeper>
 *  @CreateTime   : 2025-6-16 15:3
 *  @Author       : Luckykeeper
 *  @Contact      : https://github.com/luckykeeper | https://luckykeeper.site
 *  @Email        : luckykeeper@luckykeeper.site
 *  @project      : yakushiinL2S
 */

package apiV1

import (
	"fmt"
	"github.com/gofiber/fiber/v2"
	"github.com/luckykeeper/ltc"
	"github.com/luckykeeper/ltc/glist"
	"net/http"
	"yakushiinL2S/model"
)

func LrcToSrt(ctx *fiber.Ctx) error {
	var (
		appRequest   model.LrcToSrtAppRequest
		serverReturn model.LrcToSrtServerReturn
	)
	if err := ctx.BodyParser(&appRequest); err != nil {
		serverReturn.StatusCode = http.StatusBadRequest
		serverReturn.StatusMessage = "请求参数有误"
		return ctx.Status(http.StatusOK).JSON(serverReturn)
	}
	lrc := ltc.ParseLRC(appRequest.OriginLrc)
	startLine := 0
	newLRC := ltc.LRC{LrcList: glist.NewLinkedList[*ltc.LRCNode]()}
	for it := lrc.LrcList.Iterator(); it.Has(); {
		startLine++
		// 当指定了 StartLine 时，从指定位置之后再开始双语（开头编曲，歌手等情况）
		if appRequest.StartLine != 0 {
			if startLine < appRequest.StartLine {
				lrcNode := it.Next()
				newLRC.LrcList.PushBack(lrcNode)
				//logrus.Debugln(lrcNode.Time, lrcNode.Content)
				//logrus.Println("===")
				// 只有单行，不再向下处理
				continue
			}
		}
		// 双语歌词处理逻辑 Start
		lrcNode := it.Next()
		//logrus.Debugln(lrcNode.Time, lrcNode.Content)

		// 合并歌词 Start
		// 1、如果本行没有歌词，直接换行
		// 2、如果有歌词，1先处理保留语言，2再处理时间轴合并
		//    1-①默认情况：保留双语
		//    1-②只保留第一种语言
		//    1-③只保留第二种语言
		//    --- 当只保留一种语言时，只能选择不要合并 ---
		//    2-①默认情况：相邻时间轴合并
		//    2-②相同时间轴合并
		//    2-③不要合并

		if len(lrcNode.Content) > 0 {
			if it.Has() {
				startLine++
				//    1-①默认情况：保留双语
				if !appRequest.PersevereOnlyFirstLanguage && !appRequest.PersevereOnlySecondLanguage {
					//    2-①默认情况：相邻时间轴合并
					if appRequest.MergeNearestDuration {
						nextLrcNode := it.Next()
						if len(nextLrcNode.Content) > 0 {
							mergeLrcNode := ltc.LRCNode{Time: lrcNode.Time, Content: lrcNode.Content + "\r\n" + nextLrcNode.Content}
							newLRC.LrcList.PushBack(&mergeLrcNode)
						} else {
							newLRC.LrcList.PushBack(lrcNode)
						}
					}
					//    2-②相同时间轴合并
					if appRequest.MergeSameDuration {
						nextLrcNode := it.Next()
						if len(nextLrcNode.Content) > 0 {
							if lrcNode.Time == nextLrcNode.Time {
								mergeLrcNode := ltc.LRCNode{Time: lrcNode.Time, Content: lrcNode.Content + "\r\n" + nextLrcNode.Content}
								newLRC.LrcList.PushBack(&mergeLrcNode)
							} else {
								newLRC.LrcList.PushBack(lrcNode)
								newLRC.LrcList.PushBack(nextLrcNode)
							}
						} else {
							newLRC.LrcList.PushBack(lrcNode)
						}
					}
					//    2-③不要合并
					if !appRequest.MergeSameDuration && !appRequest.MergeNearestDuration {
						nextLrcNode := it.Next()
						if len(nextLrcNode.Content) > 0 {
							newLRC.LrcList.PushBack(lrcNode)
							newLRC.LrcList.PushBack(nextLrcNode)
						} else {
							newLRC.LrcList.PushBack(lrcNode)
						}
					}
				}
				//    1-②只保留第一种语言
				if appRequest.PersevereOnlyFirstLanguage {
					newLRC.LrcList.PushBack(lrcNode)
					it.Next()
				}
				//    1-③只保留第二种语言
				if appRequest.PersevereOnlySecondLanguage {
					nextLrcNode := it.Next()
					if len(nextLrcNode.Content) > 0 {
						newLRC.LrcList.PushBack(nextLrcNode)
					}
				}
			}
		} else {
			newLRC.LrcList.PushBack(lrcNode)
		}
	}
	// 验证处理结果
	for it := newLRC.LrcList.Iterator(); it.Has(); {
		lrcNode := it.Next()
		if model.YakushiinConfig.DebugMode {
			fmt.Println("时间轴:", lrcNode.Time)
			fmt.Println("歌词:")
			fmt.Println(lrcNode.Content)
			fmt.Println("===")
		}
	}
	srt := ltc.LrcToSrt(&newLRC)

	index := 1
	for it := srt.Content.Iterator(); it.Has(); {
		content := it.Next()
		content.Index = index
		index++
		if model.YakushiinConfig.DebugMode {
			fmt.Println(content)
		}
		serverReturn.TargetSrtContent = serverReturn.TargetSrtContent + fmt.Sprint(content)
	}
	serverReturn.StatusMessage = "转换成功！"
	serverReturn.StatusCode = http.StatusOK
	return ctx.Status(http.StatusOK).JSON(serverReturn)
}

// https://blog.csdn.net/bawomingtian123/article/details/121678099
