100 OUT 80,1 : REM Switch to font mode
200 TEXT$ = "Love, love me"
300 GOSUB 600
400 OUT 80,0 : REM Switch to bus mode
500 END
600 LENGTH% = LEN(TEXT$)
700 IF LENGTH% = 0 THEN RETURN
800 FOR INDEX% = 1 TO LENGTH%
900 PRINT MID$(TEXT$, INDEX%, 1)
1000 OUT 85, ASC(MID$(TEXT$, INDEX%, 1)) : REM Write character to display
1100 OUT 29, 250 : WAIT 29, 1, 1
1200 NEXT INDEX%
1300 RETURN

