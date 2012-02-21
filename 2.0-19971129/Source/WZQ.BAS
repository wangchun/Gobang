' Important Information:
'
' WZQ Version 2.00
' November 29 1997
' Designed by Wang Chun
'
' EMAIL: wcwcwwc@263.net
' HOMEPAGE: http://wcwcwwc.yeah.net
'
' To run this program in Quick Basic 4.5 Programming Interface, please type:
' QB /L QB.QLB WZQ.BAS
' To start Quick Basic.
'
' If you don't load QB.QLB, an error will be found.
'
' If you got an error when the program try to save data,
' please create a file named WZQ.DAT in the same directory which only include
' a space character.

REM $DYNAMIC 'Use dynamic array
TYPE RegType 'Declare interrupt registers type
    ax AS INTEGER
    bx AS INTEGER
    cx AS INTEGER
    dx AS INTEGER
    bp AS INTEGER
    si AS INTEGER
    di AS INTEGER
    flags AS INTEGER
END TYPE
TYPE DataFile 'Declare data file type
    PlayerName AS STRING * 25
    TotalTimes AS INTEGER
    WinTimes AS INTEGER
END TYPE
DECLARE SUB Main () 'Main function
DECLARE SUB DrawScreen () 'Draw main interface of this program
DECLARE SUB DrawTable () 'Draw mark table which can tell you the history
DECLARE SUB GetPlayerName () 'Get the player(s)'s name
DECLARE SUB CheckMouseInstall () 'Check if the mouse driver is installed
DECLARE SUB DisplayData () 'Display the history in a table which be drawn in function DrawTable
DECLARE SUB Save (Win%) 'Save the mark into the data file
DECLARE SUB Interrupt (intnum%, Inreg AS RegType, Outreg AS RegType) 'A procedure that be loaded in QB.QLB
DECLARE FUNCTION PlayGame% () 'A function that be used at the play time
DECLARE FUNCTION CheckWin% (Playing%, X%, Y%) 'Check if the player win
DIM SHARED Inreg AS RegType
DIM SHARED Outreg AS RegType
DIM SHARED PlayerName$(1 TO 2)
DIM SHARED Red%(127), Green%(127)
DIM SHARED QP%(-1 TO 17, -1 TO 17)
DIM SHARED Noname%
DIM SHARED Win%
CALL Main
END

REM $STATIC
SUB CheckMouseInstall
Inreg.ax = 0
Interrupt &H33, Inreg, Outreg
IF Outreg.ax = 0 THEN
    PRINT "Mouse not installed."
    END
END IF
END SUB

FUNCTION CheckWin% (Playing%, X%, Y%)
    PLAYED% = Playing% MOD 2 + 1
    S% = 1
    L% = 1
    R% = 1
    DO
        IF L% > 0 THEN
            IF QP%(X% - L%, Y%) = PLAYED% THEN
                S% = S% + 1
                L% = L% + 1
            ELSE
                L% = 0
            END IF
        END IF
        IF R% > 0 THEN
            IF QP%(X% + R%, Y%) = PLAYED% THEN
                S% = S% + 1
                R% = R% + 1
            ELSE
                R% = 0
            END IF
        END IF
        IF X% + R% > 16 THEN R% = 0
        IF X% - L% < 0 THEN L% = 0
    LOOP UNTIL L% = 0 AND R% = 0
    IF S% = 5 THEN CheckWin% = PLAYED%
    IF S% > 5 THEN CheckWin% = Playing%
    IF S% >= 5 THEN EXIT FUNCTION
    S% = 1
    L% = 1
    R% = 1
    DO
        IF L% > 0 THEN
            IF QP%(X% - L%, Y% - L%) = PLAYED% THEN
                S% = S% + 1
                L% = L% + 1
            ELSE
                L% = 0
            END IF
        END IF
        IF R% > 0 THEN
            IF QP%(X% + R%, Y% + R%) = PLAYED% THEN
                S% = S% + 1
                R% = R% + 1
            ELSE
                R% = 0
            END IF
        END IF
        IF X% + R% > 16 THEN R% = 0
        IF X% - L% < 0 THEN L% = 0
    LOOP UNTIL L% = 0 AND R% = 0
    IF S% = 5 THEN CheckWin% = PLAYED%
    IF S% > 5 THEN CheckWin% = Playing%
    IF S% >= 5 THEN EXIT FUNCTION
    S% = 1
    L% = 1
    R% = 1
    DO
        IF L% > 0 THEN
            IF QP%(X% - L%, Y% + L%) = PLAYED% THEN
                S% = S% + 1
                L% = L% + 1
            ELSE
                L% = 0
            END IF
        END IF
        IF R% > 0 THEN
            IF QP%(X% + R%, Y% - R%) = PLAYED% THEN
                S% = S% + 1
                R% = R% + 1
            ELSE
                R% = 0
            END IF
        END IF
        IF X% + R% > 16 OR Y% - R% < 0 THEN R% = 0
        IF X% - L% < 0 OR Y% + R% > 16 THEN L% = 0
    LOOP UNTIL L% = 0 AND R% = 0
    IF S% = 5 THEN CheckWin% = PLAYED%
    IF S% > 5 THEN CheckWin% = Playing%
    IF S% >= 5 THEN EXIT FUNCTION
    S% = 1
    L% = 1
    R% = 1
    DO
        IF L% > 0 THEN
            IF QP%(X%, Y% - L%) = PLAYED% THEN
                S% = S% + 1
                L% = L% + 1
            ELSE
                L% = 0
            END IF
        END IF
        IF R% > 0 THEN
            IF QP%(X%, Y% + R%) = PLAYED% THEN
                S% = S% + 1
                R% = R% + 1
            ELSE
                R% = 0
            END IF
        END IF
        IF Y% + R% > 16 THEN R% = 0
        IF Y% - L% < 0 THEN L% = 0
    LOOP UNTIL L% = 0 AND R% = 0
    IF S% = 5 THEN CheckWin% = PLAYED%
    IF S% > 5 THEN CheckWin% = Playing%
    IF S% >= 5 THEN EXIT FUNCTION
    CheckWin% = 0
END FUNCTION

SUB DisplayData
    DIM Temp AS DataFile
    OPEN "WZQ.DAT" FOR RANDOM AS #1
    Record% = 1
    DO UNTIL EOF(1)
        GET #1, Record%, Temp
        Record% = Record% + 1
    LOOP
    TotalRecord% = Record% - 2
    DIM Display(TotalRecord% - 1) AS DataFile
    DIM Average(TotalRecord% - 1) AS INTEGER
    FOR Record% = 1 TO TotalRecord%
        GET #1, Record%, Temp
        Display(Record% - 1) = Temp
        Average(Record% - 1) = Temp.WinTimes * 100 / Temp.TotalTimes
    NEXT
    DO
        IsSwap% = 0
        FOR Record% = 0 TO TotalRecord% - 2
            IF Average(Record%) < Average(Record% + 1) THEN
                SWAP Average(Record%), Average(Record% + 1)
                SWAP Display(Record%), Display(Record% + 1)
                IsSwap% = 1
            END IF
        NEXT
    LOOP WHILE IsSwap%
    Page% = 0
    FOR Record% = 0 TO TotalRecord% - 1
        IF Record% MOD 18 = 0 THEN
            IF Page% THEN
                DO
                LOOP UNTIL INKEY$ <> ""
            END IF
            Page% = Page% + 1
            DrawTable
        END IF
        LOCATE Record% + 24 - Page% * 18, 7 - LEN(STR$(Record% + 1))
        PRINT LTRIM$(STR$(Record% + 1))
        LOCATE Record% + 24 - Page% * 18, 23 - LEN(LTRIM$(RTRIM$(Display(Record%).PlayerName))) \ 2
        PRINT LTRIM$(RTRIM$(Display(Record%).PlayerName))
        LOCATE Record% + 24 - Page% * 18, 45 - LEN(LTRIM$(STR$(Display(Record%).TotalTimes))) \ 2
        PRINT LTRIM$(STR$(Display(Record%).TotalTimes))
        LOCATE Record% + 24 - Page% * 18, 58 - LEN(LTRIM$(STR$(Display(Record%).WinTimes))) \ 2
        PRINT LTRIM$(STR$(Display(Record%).WinTimes))
        LOCATE Record% + 24 - Page% * 18, 73 - LEN(LTRIM$(STR$(Average(Record%))))
        PRINT LTRIM$(STR$(Average(Record%))) + "%"
    NEXT
    DO
    LOOP UNTIL INKEY$ <> ""
    CLS
END SUB

SUB DrawScreen
    SCREEN 12
    CLS
    FOR i = 50 TO 450 STEP 25
        LINE (120, i)-(519, i), 14
        LINE (i + 70, 50)-(i + 70, 449), 14
    NEXT
    CIRCLE (280, 20), 10, 6
    CIRCLE (360, 20), 10, 2
    PAINT (280, 20), 6, 6
    PAINT (360, 20), 2, 2
    LINE (270, 35)-(290, 37), 14, BF
    LOCATE 2, 39
    PRINT "<-->"
    LOCATE 2, 30 - LEN(PlayerName$(1))
    PRINT PlayerName$(1)
    LOCATE 2, 50
    PRINT PlayerName$(2)
END SUB

SUB DrawTable
    CLS
    PRINT "ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป";
    PRINT "บ                                     List                                     บ";
    PRINT "วฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ";
    PRINT "บPlaceณ             Name             ณ    Total    ณ    Win    ณ    Average    บ";
    PRINT "วฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ";
    PRINT "บ     ณ                              ณ             ณ           ณ               บ";
    PRINT "บ     ณ                              ณ             ณ           ณ               บ";
    PRINT "บ     ณ                              ณ             ณ           ณ               บ";
    PRINT "บ     ณ                              ณ             ณ           ณ               บ";
    PRINT "บ     ณ                              ณ             ณ           ณ               บ";
    PRINT "บ     ณ                              ณ             ณ           ณ               บ";
    PRINT "บ     ณ                              ณ             ณ           ณ               บ";
    PRINT "บ     ณ                              ณ             ณ           ณ               บ";
    PRINT "บ     ณ                              ณ             ณ           ณ               บ";
    PRINT "บ     ณ                              ณ             ณ           ณ               บ";
    PRINT "บ     ณ                              ณ             ณ           ณ               บ";
    PRINT "บ     ณ                              ณ             ณ           ณ               บ";
    PRINT "บ     ณ                              ณ             ณ           ณ               บ";
    PRINT "บ     ณ                              ณ             ณ           ณ               บ";
    PRINT "บ     ณ                              ณ             ณ           ณ               บ";
    PRINT "บ     ณ                              ณ             ณ           ณ               บ";
    PRINT "บ     ณ                              ณ             ณ           ณ               บ";
    PRINT "บ     ณ                              ณ             ณ           ณ               บ";
    PRINT "ศอออออฯออออออออออออออออออออออออออออออฯอออออออออออออฯอออออออออออฯอออออออออออออออผ";
END SUB

SUB GetPlayerName
    CLS
    FOR i = 1 TO 2
    LOCATE i * 2 + 6, 15
    PRINT "Name of Player"; STR$(i); ": ";
    LINE INPUT ; PlayerName$(i)
    IF PlayerName$(i) = "" THEN
        PlayerName$(i) = "Player" + STR$(i)
        Noname% = 1
    ELSE
        PlayerName$(i) = LEFT$(LTRIM$(RTRIM$(PlayerName$(i))), 25)
    END IF
    NEXT
    IF PlayerName$(1) = PlayerName$(2) THEN Noname% = 1
END SUB

SUB Main
    CALL CheckMouseInstall
    CALL GetPlayerName
    CALL DrawScreen
    GET (270, 10)-(290, 30), Red%
    GET (350, 10)-(370, 30), Green%
    Inreg.ax = 4
    Inreg.cx = 0
    Inreg.dx = 0
    Interrupt &H33, Inreg, Outreg
    Inreg.ax = 1
    Interrupt &H33, Inreg, Outreg
    FOR i = -1 TO 17
        QP%(i, -1) = 3
        QP%(-1, i) = 3
        QP%(i, 17) = 3
        QP%(17, i) = 3
    NEXT
    Win% = PlayGame%
    LOCATE 30, 27
    PRINT "Press any key to continue ...";
    DO WHILE INKEY$ = ""
    LOOP
    Inreg.ax = 2
    Interrupt &H33, Inreg, Outreg
    SCREEN 0
    CLS
    IF Win% = 0 THEN
        CALL DisplayData
        END
    ELSE
        PRINT PlayerName$(Win%); " WIN!"
    END IF
    IF Noname% = 0 THEN
        INPUT "Do you want to save(Y/N)"; t$
        t$ = UCASE$(t$)
        IF t$ = "Y" THEN Save Win%
    END IF
    CALL DisplayData
END SUB

FUNCTION PlayGame%
    Playing% = 1
    Times% = 0
    DO WHILE INKEY$ <> CHR$(27) AND Win% = 0 AND Times% < 289
        Inreg.ax = 5
        Inreg.bx = 0
        Interrupt &H33, Inreg, Outreg
        ClickX% = Outreg.cx
        ClickY% = Outreg.dx
        IF ClickX% > 109 AND ClickY% > 39 AND ClickX% < 530 AND ClickY% < 460 THEN
            X% = (ClickX% - 110) \ 25
            Y% = (ClickY% - 40) \ 25
            IF QP%(X%, Y%) > 0 THEN GOTO NEXTLOOP
            IF Playing% = 1 THEN
                Inreg.ax = 2
                Interrupt &H33, Inreg, Outreg
                PUT (X% * 25 + 110, Y% * 25 + 40), Red%, PSET
                Inreg.ax = 1
                Interrupt &H33, Inreg, Outreg
                Times% = Times% + 1
                QP%(X%, Y%) = Playing%
                Playing% = 2
                LINE (350, 35)-(370, 37), 14, BF
                LINE (270, 35)-(290, 37), 0, BF
            ELSE
                Inreg.ax = 2
                Interrupt &H33, Inreg, Outreg
                PUT (X% * 25 + 110, Y% * 25 + 40), Green%, PSET
                Inreg.ax = 1
                Interrupt &H33, Inreg, Outreg
                Times% = Times% + 1
                QP%(X%, Y%) = Playing%
                Playing% = 1
                LINE (270, 35)-(290, 37), 14, BF
                LINE (350, 35)-(370, 37), 0, BF
            END IF
        END IF
        Win% = CheckWin%(Playing%, X%, Y%)
NEXTLOOP:
    LOOP
    PlayGame% = Win%
END FUNCTION

SUB Save (Win%)
    PRINT "Saving ..."
    DIM SaveData AS DataFile
    OPEN "WZQ.DAT" FOR RANDOM AS #1
    Record% = 1
    DO UNTIL EOF(1)
        GET #1, Record%, SaveData
        IF RTRIM$(SaveData.PlayerName) = PlayerName$(Win%) THEN
            SaveData.TotalTimes = SaveData.TotalTimes + 1
            SaveData.WinTimes = SaveData.WinTimes + 1
            PUT #1, Record%, SaveData
            Saved% = Saved% + 1
        END IF
        IF RTRIM$(SaveData.PlayerName) = PlayerName$(Win% MOD 2 + 1) THEN
            SaveData.TotalTimes = SaveData.TotalTimes + 1
            PUT #1, Record%, SaveData
            Saved% = Saved% + 2
        END IF
        IF Saved% = 3 THEN
            CLOSE #1
            EXIT SUB
        END IF
        Record% = Record% + 1
    LOOP
    SELECT CASE Saved%
        CASE 0
            SaveData.PlayerName = PlayerName$(Win%)
            SaveData.TotalTimes = 1
            SaveData.WinTimes = 1
            PUT #1, Record% - 1, SaveData
            SaveData.PlayerName = PlayerName$(Win% MOD 2 + 1)
            SaveData.TotalTimes = 1
            SaveData.WinTimes = 0
            PUT #1, Record%, SaveData
        CASE 1
            SaveData.PlayerName = PlayerName$(Win% MOD 2 + 1)
            SaveData.TotalTimes = 1
            SaveData.WinTimes = 0
            PUT #1, Record% - 1, SaveData
        CASE 2
            SaveData.PlayerName = PlayerName$(Win%)
            SaveData.TotalTimes = 1
            SaveData.WinTimes = 1
            PUT #1, Record% - 1, SaveData
    END SELECT
    CLOSE #1
END SUB

