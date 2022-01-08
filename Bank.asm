; Bank the 8086 Edition
; authors: Parsa KamaliPour 97149081, Hosein Ahmadi 97149003

.MODEL SMALL

.DATA

    INTRO_MSG DB 'Bank The 8086 Edition$'

    CREATE_MSG DB 'CREATE ACCOUNT$'

    DEPO_MSG DB 'DEPOSIT MONEY$'

    WITHDRAW_MSG DB 'WITHDRAW MONEY$'

    ACC_INFO_MSG DB 'ACCOUNT INFORMATION$'

    CHANGE_ACC_INFO_MSG DB 'CHANGE YOUR ACCOUNT INFORMATION$'

    QUESTION_MSG DB 'Choose your next option: $'

    INPUT DB ?

    ACC_NAME DB 50 DUP('$')

    ACC_PASSWORD DB 50 DUP('$')

    PASSWORD_SIZE DW 0

    ACC_BALANCE DW 0

    ; CREATE ACCOUNT SECTION

    SEC1_ENTER_MSG DB 'ENTER YOUR NAME: $'
    SEC1_PASS_MSG DB 'ENTER YOUR PASSWORD: $'
    SEC1_DONE_MSG DB 'YOUR ACCOUNT WAS CREATED SUCCSESSFULLY. $'

    ;MONEY SECTION 
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
            PRINTSTRING 'PROJECT BY PARSA & HOSEIN. SEE YOU LATER!'
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
        RET

    CLEAR_CONSOLE ENDP

    ;----------------------------------------------------------SHOW_OPTIONS------------------------------------------------------

    SHOW_OPTIONS PROC NEAR

        PRINTSTRING INTRO_MSG
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

    INPUT_CHEK_ENTER PROC
        CHECK_ENTER_LOOP:
            MOV AH,1
            INT 21H
            CMP AL,13
            JE SELECT_OPTION_LOOP
            JMP CHECK_ENTER_LOOP
        RET
    INPUT_CHEK_ENTER ENDP
    


END MAIN



        

