:: Programmed by hXR16F
:: hXR16F.ar@gmail.com

@echo off
setlocal EnableDelayedExpansion EnableExtensions
title BetHard
color 07

set "theme=1"
	:: Changes colors of text in two boxes
	
	:: 1	0xF0
	:: 2	0xC0 | 0x90
	:: 3	0x4F | 0xB0

set "font=9"
	:: Changes font resolution in game window
	
	:: 0	4x6		Tiny
	:: 1	6x8		Small
	:: 2	8x8
	:: 3	16x8
	:: 4	5x12
	:: 5	7x12	Medium
	:: 6	8x12
	:: 7	16x12
	:: 8	12x16
	:: 9	10x18	Large

:reset
	set "colums=80"
	set "rows=30"
	_bg.dll font %font%
	mode %colums%,%rows%
	_cmdfocus.dll /center
	color F0
	(
		set "__rand_a__=4"
		set "his=2"
		set "red_his=0"
		set "blue_his=0"
		set "balance=5000"
		set "second_balance=%balance%"
		set "prize=0"
	)
	
	if "%theme%" EQU "1" set color_1=0xF0 & set color_2=0xF0
	if "%theme%" EQU "2" set color_1=0xC0 & set color_2=0x90
	if "%theme%" EQU "3" set color_1=0x4F & set color_2=0xB0
	
	cls
	_draw.dll 0 0 sprites\ui1.spr
	
	goto main

:draw
	if %his% EQU 78 (
		_draw.dll 0 0 sprites\ui1.spr
		set /A balance=%balance%+%balance%/5
		set "his=2"
	)
	if %red_his% EQU 1 (
		_draw.dll 1 %his% sprites\c_red.spr
		set /A his+=1
		set "red_his=0"
	)
	if %blue_his% EQU 1 (
		_draw.dll 1 %his% sprites\c_blue.spr
		set /A his+=1
		set "blue_his=0"
	)
	_draw.dll 0 0 sprites\ui0.spr
	_batbox.dll /c 0xF0 /g 67 12 /d "by hXR16F" /g 4 12 /d "Bet" /g 4 25 /d "Prize" /g 4 26 /d "Balance" /g 10 12 /d "$%bet%" /g 14 25 /d "$%prize%" /g 14 26 /d "$%balance%" /g 12 18 /c %color_1% /d "Click here to bet" /g 14 19 /d "on this color" /g 50 18 /c %color_2% /d "Click here to bet" /g 52 19 /d "on this color" /g 0 0 /c 0xF0
	
	exit /B

:random_
	if !__rand_a__! EQU 14 set "__rand_a__=4"
	for /L %%n in (1,1,!__rand_a__!) do (
		set /A __rand__=!random!*4/32768
	)
	if !__rand__! EQU 0 set "__rand_result__=Blue"
	if !__rand__! EQU 1 set "__rand_result__=Red"
	if !__rand__! EQU 2 set "__rand_result__=Blue"
	if !__rand__! EQU 3 set "__rand_result__=Red"
	
	set /A __rand_a__+=1
	
	exit /B

:add
	set "prize=!bet!"
	set /A balance+=!prize!
	
	exit /B

:main
	set "bet="
	call :draw
	
	:bet
		set "second_balance=!balance!"
		if %balance% EQU 0 goto reset
		_batbox.dll /g 11 12
		_bg.dll cursor 25
		set /P "bet="
		if "%bet%" EQU "" goto main
		if %bet% GTR %balance% (
			goto main
		) else (
			_bg.dll cursor 0
			_batbox.dll /g 0 0
			for /F "TOKENS=1,2,3 DELIMS=:" %%a in ('_batbox.dll /m') do (
				set "type=%%c" & set "y=%%b" & set "x=%%a"
				for /L %%y in (15,1,22) do (
					if !y! EQU %%y if !type! EQU 1 (
						for /L %%x in (2,1,39) do (
							if !x! EQU %%x (
								set "bet_on=Red"
								call :random_
								if /I "!__rand_result__!" EQU "Red" set red_his=1
								if /I "!__rand_result__!" EQU "Blue" set blue_his=1
								if /I "!bet_on!" EQU "!__rand_result__!" (
									set /A __rand_a__+=1
									call :add
								) else (
									set /A balance-=!bet!
									set prize=0
								)
							)
						)
						for /L %%x in (40,1,77) do (
							if !x! EQU %%x if !type! EQU 1 (
								set "bet_on=Blue"
								call :random_
								if /I "!__rand_result__!" EQU "Red" set red_his=1
								if /I "!__rand_result__!" EQU "Blue" set blue_his=1
								if /I "!bet_on!" EQU "!__rand_result__!" (
									set /A __rand_a__+=1
									call :add
								) else (
									set /A balance-=!bet!
									set prize=0
								)
							)
						)
					)
				)
			)
		)
		goto main
		