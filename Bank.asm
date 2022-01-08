; Bank the 8086 Edition
; authors: Parsa KamaliPour 97149081, Hosein Ahmadi 97149003

.MODEL SMALL

.DATA

    INTRO_MSG DB 'Bank The 8086 Edition$'

    CREATE_MSG DB '1. CREATE ACCOUNT$'

    DEPO_MSG DB '2. DEPOSIT MONEY$'

    WITHDRAW_MSG DB '3. WITHDRAW MONEY$'

    ACC_INFO_MSG DB '4. ACCOUNT INFORMATION$'

    CHANGE_ACC_INFO_MSG DB '5. CHANGE YOUR ACCOUNT INFORMATION$'

    QUESTION_MSG DB 'Choose your next option: (PRESS 0 TO EXIT)$'

    INPUT DB ?

    ACC_NAME DB 50 DUP('$')

    ACC_PASSWORD DB 50 DUP('$')

    PASSWORD_SIZE DW 0

    ACC_BALANCE DW 0
    SELECT_MONEY_VAL DB ?

    ; CREATE ACCOUNT SECTION

    SEC1_ENTER_MSG DB 'ENTER YOUR NAME: $'
    SEC1_PASS_MSG DB 'ENTER YOUR PASSWORD: $'
    SEC1_DONE_MSG DB 'YOUR ACCOUNT WAS CREATED SUCCSESSFULLY. $'

    SEC2_ONE DB 'TOMAN 1000 $'
    SEC2_TWO DB 'TOMAN 5000 $'
    SEC2_THREE DB 'TOMAN 10000 $'
    SEC2_FOUR DB 'TOMAN 50000 $'
    SEC2_SELECT_MONEY DB 'WHICH ONE DO YOU WANT $'
    SEC2_BALANCE_OVERFLOW DB 'THE AMOUNT OF MONEY YOU WANT HAS PASS ACCOUNT BALANCE $'

    ;DISPLAY  ACCOUNT INFO

    SEC3_PRINT_ACC_NAME DB 'ACCOUNT NAME: $'
    SEC3_PRINT_ACC_PASS DB 'PASSWORD YOUR ACCOUNT: $'
    SEC3_PRINT_NO_ACC DB 'THERE IS NO ACCOUNT $'
    SEC3_PRINT_REMAINING_BALANCE DB 'YOUR REMAINING BALANCE: $'
    SEC3_PRINT_NO_MONEY DB 'YOUR ACCOUNT IS EMPTY $' 


    ;CHANGE INFO
    SEC4_CHANGE_NAME DB 'YOUR NEW ACCOUNT NAME$'
    SEC4_CHANGE_PASS DB 'YOUR NEW PASSWORD $'
    SEC4_DONE_MSG DB 'YOUR ACCOUNT INFO HAS CHANGE SUCCSESSFULLY $'


    ;PIN 
    ENTER_PASS_MSG DB 'ENTER YOUR PASSWORD $'
    NO_ACC_MSG DB 'ACCOUNT DOES NOT EXIST $'

    GOODBYE DB 'PROJECT BY PARSA & HOSEIN. SEE YOU LATER! $'

.CODE

    ; -----------------------------------------------------------MACROS--------------------------------------------------------------
     
    ;  -----------------------------------------------------------PRINT STRING------------------------------------------------------

    MACRO PRINTSTRING STRING 

        MOV AH,9
        LEA DX,STRING
        INT 21H

    ENDM

    ; -----------------------------------------------------------INPUT STRING FOR CREATE ACCOUNT-------------------------------------
     
    MACRO INPUT_STR_CRT_ACC_USER STRING

        LEA SI,STRING
        GET_INPUT: 
            MOV AH,1
            INT 21H
            CMP AL,13
            JE CRT_ACC_GET_PASS_LOOP
            MOV [SI],AL
            INC SI
            JMP GET_INPUT

        EXIT_MACRO:
            RET

    ENDM

    ; ----------------------------------------------------------------INPUTSTRING CEATE ACCOUNT PASSWORD------------------------------

    MACRO  INPUT_STR_CRT_ACC_PASS STRING

        LEA SI,STRING
        GET_INPUT_PASS:
            MOV AH,1
            INT 21H
            CMP AL,13
            JE CRT_ACC_DONE
            INC PASSWORD_SIZE
            MOV [SI],AL
            INC SI
            JMP GET_INPUT_PASS

        EXIT_PASS:
            RET

    ENDM

    ; ---------------------------------------------------INPUT_STR_CHANGE_ACC_NAME--------------------------------------------------

    MACRO INPUT_STR_CHANGE_ACC_NAME STRING

        LEA SI, STRING
        CHANGE_NAME:
            MOV AH, 1
            INT 21H
            CMP AL, 13
            JE CONTINUE_TO_CHANGE_PASS
            MOV [SI], AL
            INC SI
            JMP CHANGE_NAME

    ENDM

    ; ---------------------------------------------------INPUT_STR_CHANGE_ACC_PASS--------------------------------------------------


    MACRO INPUT_STR_CHANGE_ACC_PASS STRING

        LEA SI, STRING
        MOV PASSWORD_SIZE, 0
        CHANGE_PASS:
            MOV AH, 1
            INT 21H
            CMP AL, 13
            JE CONTINUE_TO_FINISH
            INC PASSWORD_SIZE
            MOV [SI], AL
            INC SI
            JMP CHANGE_PASS
            
    ENDM

    ;-----------------------------------------------------------MAIN---------------------------------------------------------------

    MAIN PROC

        MOV AX, @DATA
        MOV DS, AX

        SELECT_OPTION_LOOP:

            CALL CLEAR_CONSOLE
            CALL SHOW_OPTIONS
            CALL INPUT_FOR_OPTIONS

            CMP INPUT, '0'
            JE EXIT

            CMP INPUT, '1'
            JE CREATE_ACC

            CMP INPUT, '2'
            JE DEPOSIT_MONEY

            CMP INPUT, '3'
            JE WITHDRAW_MONEY

            CMP INPUT, '4'
            JE SHOW_ACC_INFO

            CMP INPUT, '5'
            JE CHANGE_ACC_INFO

            JMP SELECT_OPTION_LOOP
        
        EXIT:

            CALL NEWLINE
            PRINTSTRING GOODBYE
            CALL NEWLINE

            MOV AH, 4CH
            INT 21H
    
    MAIN ENDP

    ; -----------------------------------------------------------NEW LINE----------------------------------------------------------

     NEWLINE PROC NEAR

        MOV AH,2
        MOV DL,10
        INT 21H
        MOV DL,13
        INT 21H
        RET

    NEWLINE ENDP

    ;----------------------------------------------------------CLEAR_CONSOLE------------------------------------------------------

    CLEAR_CONSOLE PROC NEAR

        CALL NEWLINE
        CALL NEWLINE
        RET

    CLEAR_CONSOLE ENDP

    ;----------------------------------------------------------SHOW_OPTIONS------------------------------------------------------

    SHOW_OPTIONS PROC NEAR

        PRINTSTRING INTRO_MSG
        CALL NEWLINE
        CALL NEWLINE

        PRINTSTRING CREATE_MSG
        CALL NEWLINE

        PRINTSTRING DEPO_MSG
        CALL NEWLINE

        PRINTSTRING WITHDRAW_MSG
        CALL NEWLINE

        PRINTSTRING ACC_INFO_MSG
        CALL NEWLINE

        PRINTSTRING CHANGE_ACC_INFO_MSG
        CALL NEWLINE

        RET
    
    SHOW_OPTIONS ENDP

    ;----------------------------------------------------------INPUT_FOR_OPTIONS------------------------------------------------------

    INPUT_FOR_OPTIONS PROC NEAR

        CALL NEWLINE
        PRINTSTRING QUESTION_MSG
        MOV AH, 1
        INT 21H
        MOV INPUT, AL
        RET

    INPUT_FOR_OPTIONS ENDP

    ;----------------------------------------------------------CREATE ACCOUNT------------------------------------------------------
    
    CREATE_ACC PROC 

        CALL CLEAR_CONSOLE
        PRINTSTRING CREATE_MSG
        CALL NEWLINE
        CALL NEWLINE
        PRINTSTRING SEC1_ENTER_MSG
        INPUT_STR_CRT_ACC_USER ACC_NAME

        CRT_ACC_GET_PASS_LOOP:
            CALL NEWLINE
            PRINTSTRING SEC1_PASS_MSG
            INPUT_STR_CRT_ACC_PASS ACC_PASSWORD

        CRT_ACC_DONE:
            CALL NEWLINE
            PRINTSTRING SEC1_DONE_MSG
            CALL INPUT_CHEK_ENTER
        
        RET

    CREATE_ACC ENDP

    ;----------------------------------------------------------INPUT_CHEK_ENTER------------------------------------------------------

    INPUT_CHEK_ENTER PROC

        CHECK_ENTER_LOOP:
            MOV AH,1
            INT 21H
            CMP AL,13
            JE SELECT_OPTION_LOOP
            JMP CHECK_ENTER_LOOP
        RET

    INPUT_CHEK_ENTER ENDP
    
    ;------------------------------------------------------------DEPOSIT_MONEY------------------------------------------------------

    DEPOSIT_MONEY PROC

        CALL CHECK_ACC_CREATED
        CALL GET_PASSWORD
        CALL CLEAR_CONSOLE

        PRINTSTRING DEPO_MSG
        CALL NEWLINE
        CALL NEWLINE
        
        PRINTSTRING SEC2_ONE
        CALL NEWLINE
        PRINTSTRING SEC2_TWO
        CALL NEWLINE
        PRINTSTRING SEC2_THREE
        CALL NEWLINE
        PRINTSTRING SEC2_FOUR
        CALL NEWLINE

        CALL SELECT_MONEY

        CMP SELECT_MONEY_VAL, '1'
        JE ONE_TOMAN

        CMP SELECT_MONEY_VAL, '2'
        JE FIVE_TOAMN

        CMP SELECT_MONEY_VAL, '3'
        JE TEN_TOMAN

        CMP SELECT_MONEY_VAL, '4'
        JE FIFTY_TOMAN

        ONE_TOMAN:

            ADD ACC_BALANCE, 1000
            JMP SELECT_OPTION_LOOP

        FIVE_TOAMN:

            ADD ACC_BALANCE, 5000
            JMP SELECT_OPTION_LOOP

        TEN_TOMAN:

            ADD ACC_BALANCE, 10000
            JMP SELECT_OPTION_LOOP

        FIFTY_TOMAN:

            ADD ACC_BALANCE, 50000
            JMP SELECT_OPTION_LOOP

        RET

    DEPOSIT_MONEY ENDP
    ; -------------------------------------------------------------WITHDRAW_MONEY----------------------------------------------------
    WITHDRAW_MONEY PROC 

       CALL CHECK_ACC_CREATED
       CALL GET_PASSWORD
       CALL CLEAR_CONSOLE

        PRINTSTRING WITHDRAW_MSG
        CALL NEWLINE
        CALL NEWLINE
        
        PRINTSTRING SEC2_ONE
        CALL NEWLINE
        PRINTSTRING SEC2_TWO
        CALL NEWLINE
        PRINTSTRING SEC2_THREE
        CALL NEWLINE
        PRINTSTRING SEC2_FOUR
        CALL NEWLINE

        CALL SELECT_MONEY

        CMP SELECT_MONEY_VAL, '1'
        JE SUB_ONE_TOMAN

        CMP SELECT_MONEY_VAL, '2'
        JE SUB_FIVE_TOAMN

        CMP SELECT_MONEY_VAL, '3'
        JE SUB_TEN_TOMAN

        CMP SELECT_MONEY_VAL, '4'
        JE SUB_FIFTY_TOMAN

        SUB_ONE_TOMAN:
            MOV DX,ACC_BALANCE
            CMP DX,1000
            JB NOT_ENOUGH
            SUB ACC_BALANCE, 1000
            JMP SELECT_OPTION_LOOP

        SUB_FIVE_TOAMN:
            MOV DX,ACC_BALANCE
            CMP DX,5000
            JB NOT_ENOUGH
            SUB ACC_BALANCE, 5000
            JMP SELECT_OPTION_LOOP

        SUB_TEN_TOMAN:
            MOV DX,ACC_BALANCE
            CMP DX,10000
            JB NOT_ENOUGH
            SUB ACC_BALANCE, 10000
            JMP SELECT_OPTION_LOOP

        SUB_FIFTY_TOMAN:
            MOV DX,ACC_BALANCE
            CMP DX,50000
            JB NOT_ENOUGH
            SUB ACC_BALANCE, 50000
            JMP SELECT_OPTION_LOOP

        NOT_ENOUGH:
            CALL NEWLINE
            PRINTSTRING SEC2_BALANCE_OVERFLOW
            CALL CHECK_ENTER_LOOP
        RET

    
    WITHDRAW_MONEY ENDP

    ; ------------------------------------------------------------SHOW_ACC_INFO--------------------------------------------------------
        SHOW_ACC_INFO PROC

            CALL CHECK_ACC_CREATED
            CALL GET_PASSWORD
            CALL CLEAR_CONSOLE

            PRINTSTRING ACC_INFO_MSG
            CALL NEWLINE
            CALL NEWLINE

            PRINTSTRING SEC3_PRINT_ACC_NAME
            CALL NEWLINE

            PRINTSTRING ACC_NAME
            CALL NEWLINE

            PRINTSTRING SEC3_PRINT_ACC_PASS
            CALL NEWLINE

            PRINTSTRING ACC_PASSWORD
            CALL NEWLINE

            PRINTSTRING SEC3_PRINT_REMAINING_BALANCE
            CALL NEWLINE

            MOV AX,ACC_BALANCE
            CMP AX,0
            JE NO_MONEY
            CALL SHOW_NUMBER_IN_DECIMAL
            CALL NEWLINE

        CALL INPUT_CHEK_ENTER


        NO_MONEY:
            PRINTSTRING SEC3_PRINT_NO_MONEY
            CALL NEWLINE
            CALL INPUT_CHEK_ENTER

        RET

        SHOW_ACC_INFO ENDP

    ;------------------------------------------------------------CHECK_ACC_CREATED------------------------------------------------------

    CHECK_ACC_CREATED PROC

        CMP PASSWORD_SIZE, 0
        JE ACC_NOT_CREATED
        RET

        ACC_NOT_CREATED:

            CALL CLEAR_CONSOLE
            PRINTSTRING NO_ACC_MSG
            CALL INPUT_CHEK_ENTER

    CHECK_ACC_CREATED ENDP

    ;------------------------------------------------------------GET_PASSWORD------------------------------------------------------

    GET_PASSWORD PROC

        CALL CLEAR_CONSOLE
        PRINTSTRING ENTER_PASS_MSG

        LEA SI, ACC_PASSWORD
        MOV CX, PASSWORD_SIZE

        INPUT_PASS_LOOP:
            MOV AH, 7
            INT 21H

            CMP AL, [SI]

            MOV DL, '*'
            MOV AH, 2
            INT 21H

            JNE SELECT_OPTION_LOOP

            INC SI
        LOOP INPUT_PASS_LOOP

    RET

    GET_PASSWORD ENDP

    ;----------------------------------------------------------SELECT_MONEY------------------------------------------------------

    SELECT_MONEY PROC

        CALL NEWLINE
        PRINTSTRING SEC2_SELECT_MONEY
        MOV AH, 1
        INT 21H
        MOV SELECT_MONEY_VAL, AL
        RET

    SELECT_MONEY ENDP

    ;----------------------------------------------------------SHOW_NUMBER_IN_DECIMAL------------------------------------------------------

    SHOW_NUMBER_IN_DECIMAL PROC

        MOV CX, 0
        MOV DX, 0

        PART1:

            CMP AX, 0
            JE PART2

            MOV BX, 10
            DIV BX
            PUSH DX

            INC CX

            XOR DX, DX
            JMP PART1

        PART2:

            CMP CX, 0
            JE EXIT_NUMBER_PRINT

            POP DX
            ADD DX, 48

            MOV AH, 02H
            INT 21H

            DEC CX
            JMP PART2
        
        EXIT_NUMBER_PRINT:
            RET


    SHOW_NUMBER_IN_DECIMAL ENDP


    ;----------------------------------------------------------CHANGE_ACC_INFO------------------------------------------------------

    CHANGE_ACC_INFO PROC

        CALL CHECK_ACC_CREATED
        CALL GET_PASSWORD
        CALL CLEAR_CONSOLE

        PRINTSTRING CHANGE_ACC_INFO_MSG
        CALL NEWLINE
        CALL NEWLINE

        PRINTSTRING SEC4_CHANGE_NAME
        INPUT_STR_CHANGE_ACC_NAME ACC_NAME

        CONTINUE_TO_CHANGE_PASS:
            CALL NEWLINE
            PRINTSTRING SEC4_CHANGE_PASS
            INPUT_STR_CHANGE_ACC_PASS ACC_PASSWORD

        CONTINUE_TO_FINISH:
            CALL NEWLINE
            PRINTSTRING SEC4_DONE_MSG
            CALL INPUT_CHEK_ENTER
    
        RET

    CHANGE_ACC_INFO ENDP

END MAIN



        

