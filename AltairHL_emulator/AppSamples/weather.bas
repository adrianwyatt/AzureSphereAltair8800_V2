100 WIDTH 150
200 PRINT "===================================================="
300 PRINT "OPEN WEATHER MAP IOT APP"
400 DELAY% = 4
500 WEATHERPORT = 35
600 LOCATIONPORT = 37
700 POLLUTIONPORT = 39
800 PRINT "SEND WEATHER DATA TO IOT CENTRAL EVERY";DELAY%;"SECONDS"
900 RCOUNT# = 0
1000 WHILE 1
1100 PRINT "===================================================="
1200 PRINT CHR$(27) + "[33;22;24m" + "Reading:"; RCOUNT#; "| BASIC free memory:"; FRE(0); CHR$(27) + "[0m"
1300 RCOUNT# = RCOUNT# + 1
1400 REM GET TIME AS STRING
1500 PORT = 43 : GOSUB 4100 : PRINT "Time (local): ";RSTRING$
1600 PORT = WEATHERPORT : PDATA = 0 : GOSUB 4100 : TEMPERATURE$ = RSTRING$
1700 PORT = WEATHERPORT : PDATA = 1 : GOSUB 4100 : PRESSURE$ = RSTRING$
1800 PORT = WEATHERPORT : PDATA = 2 : GOSUB 4100 : HUMIDITY$ = RSTRING$
1900 PORT = POLLUTIONPORT : PDATA = 0 : GOSUB 4100 : AIRQUALITYINDEX$ = RSTRING$
2000 PORT = LOCATIONPORT : PDATA = 0 : GOSUB 4100 : LATITUDE$ = RSTRING$
2100 PORT = LOCATIONPORT : PDATA = 1 : GOSUB 4100 : LONGITUDE$ = RSTRING$
2200 PRINT : PRINT "Celsius", "Millibars", "Humidity %", "AQI (CAQI)", "Latitude", "Longitude"
2300 PRINT TEMPERATURE$, PRESSURE$, HUMIDITY$, AIRQUALITYINDEX$, LATITUDE$, LONGITUDE$
2400 PRINT
2500 GOSUB 3100 : REM Generate JSON
2600 GOSUB 5300 : REM Publish JSON
2700 PRINT: PRINT CHR$(27) + "[31;22;24m" + "Sleep for";DELAY%;"seconds." + CHR$(27) + "[0m"
2800 GOSUB 4800
2900 WEND
3000 END
3100 REM BUILD JSON STRING
3200 RJSON$ = "{"
3300 RJSON$ = RJSON$ + CHR$(34) + "temperature" + CHR$(34) + ":" + TEMPERATURE$ + ","
3400 RJSON$ = RJSON$ + CHR$(34) + "pressure" + CHR$(34) + ":" +  PRESSURE$ + ","
3500 RJSON$ = RJSON$ + CHR$(34) + "humidity" + CHR$(34) + ":" +  HUMIDITY$ + ","
3600 RJSON$ = RJSON$ + CHR$(34) + "latitude" + CHR$(34) + ":" +  LATITUDE$ + ","
3700 RJSON$ = RJSON$ + CHR$(34) + "longitude" + CHR$(34) + ":" +  LONGITUDE$ + ","
3800 RJSON$ = RJSON$ + CHR$(34) + "aqi" + CHR$(34) + ":" +  AIRQUALITYINDEX$
3900 RJSON$ = RJSON$ + "}"
4000 RETURN
4100 REM SUBROUTINE READS STRING DATA FROM PORT UNTIL NULL CHARACTER
4200 OUT PORT, PDATA
4300 RSTRING$ = ""
4400 C=INP(200)
4500 IF C = 0 THEN RETURN
4600 RSTRING$ = RSTRING$ + CHR$(C)
4700 GOTO 4400
4800 REM SUBROUTINE DELAYS PROGRAM EXECUTION BY DELAY% SECONDS
4900 OUT 30, DELAY% : REM SET DELAY WAIT TIMER
5000 WAIT 31, 1, 1 : REM WAIT FOR PUBLISH JSON PENDING TO GO FALSE
5100 WAIT 30, 1, 1 : REM WAIT FOR DELAY TIMER TO EXPIRE
5200 RETURN
5300 REM SUBROUTINE PUBLISHES JSON TO AZURE IOT
5400 LENGTH% = LEN(RJSON$)
5500 IF LENGTH% = 0 THEN RETURN
5600 IF LENGTH% > 256 THEN RETURN
5700 PRINT CHR$(27) + "[94;22;24m" + "PUBLISHING JSON TO AZURE IOT" + CHR$(27) + "[0m"
5800 PRINT RJSON$
5900 FOR DATAINDEX% = 1 TO LENGTH%
6000 OUT 31, ASC(MID$(RJSON$, DATAINDEX%, 1))
6100 NEXT DATAINDEX%
6200 OUT 31, 0 : REM TERMINATING NULL CAUSE PUBLISH TO AZURE IOT
6300 RETURN
