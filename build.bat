go env -w CGO_ENABLED=0
@REM darwin386
set GOOS=darwin
set GOARCH=386
go build -o build/yakusiinL2S_%GOOS%_%GOARCH%
@REM darwinamd64
set GOOS=darwin
set GOARCH=amd64
go build -o build/yakusiinL2S_%GOOS%_%GOARCH%
@REM darwinarm
set GOOS=darwin
set GOARCH=arm
go build -o build/yakusiinL2S_%GOOS%_%GOARCH%
@REM darwinarm64
set GOOS=darwin
set GOARCH=arm64
go build -o build/yakusiinL2S_%GOOS%_%GOARCH%
@REM freebsdamd64
set GOOS=freebsd
set GOARCH=amd64
go build -o build/yakusiinL2S_%GOOS%_%GOARCH%
@REM linux
set GOOS=linux
set GOARCH=amd64
go build -o build/yakusiinL2S_%GOOS%_%GOARCH%
@REM linux386
set GOOS=linux
set GOARCH=386
go build -o build/yakusiinL2S_%GOOS%_%GOARCH%
@REM linuxarm64
set GOOS=linux
set GOARCH=arm64
go build -o build/yakusiinL2S_%GOOS%_%GOARCH%
@REM linuxppc64le
set GOOS=linux
set GOARCH=ppc64le
go build -o build/yakusiinL2S_%GOOS%_%GOARCH%
@REM linuxppc64
set GOOS=linux
set GOARCH=ppc64
go build -o build/yakusiinL2S_%GOOS%_%GOARCH%
@REM linuxmips
set GOOS=linux
set GOARCH=mips
go build -o build/yakusiinL2S_%GOOS%_%GOARCH%
@REM linuxmipsle
set GOOS=linux
set GOARCH=mipsle
go build -o build/yakusiinL2S_%GOOS%_%GOARCH%
@REM linuxmips64
set GOOS=linux
set GOARCH=mips64
go build -o build/yakusiinL2S_%GOOS%_%GOARCH%
@REM linuxmips64le
set GOOS=linux
set GOARCH=mips64le
go build -o build/yakusiinL2S_%GOOS%_%GOARCH%
@REM openbsd
set GOOS=openbsd
set GOARCH=amd64
go build -o build/yakusiinL2S_%GOOS%_%GOARCH%
@REM openbsd
set GOOS=openbsd
set GOARCH=arm
go build -o build/yakusiinL2S_%GOOS%_%GOARCH%
@REM Windows386
set GOOS=windows
set GOARCH=386
go build -o build/yakusiinL2S_%GOOS%_%GOARCH%.exe
@REM Windowsamd64
set GOOS=windows
set GOARCH=amd64
go build -o build/yakusiinL2S_%GOOS%_%GOARCH%.exe
go env -w CGO_ENABLED=1