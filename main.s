	PRESERVE8							; 8-битное выравнивание стека
	THUMB								; Режим Thumb (AUL) инструкций

	GET	config.s						; include-файлы
	GET	stm32f10x.s	

	AREA RESET, CODE, READONLY

	; Таблица векторов прерываний
	DCD STACK_TOP						; Указатель на вершину стека
	DCD Reset_Handler					; Вектор сброса

	ENTRY								; Точка входа в программу

Reset_Handler	PROC					; Вектор сброса
	EXPORT  Reset_Handler				; Делаем Reset_Handler видимым вне этого файла

main									; Основная подпрограмма
	MOV32	R0, PERIPH_BB_BASE + \
			RCC_APB2ENR * 32 + \
			2 * 4
	MOV		R1, #1						; включаем тактирование порта D (в 5-й бит RCC_APB2ENR пишем '1`)
	STR 	R1, [R0]					; загружаем это значение
	
	MOV32	R0, PERIPH_BB_BASE + \
			RCC_APB2ENR * 32 + \
			3 * 4
	MOV		R1, #1						; включаем тактирование порта D (в 5-й бит RCC_APB2ENR пишем '1`)
	STR 	R1, [R0]

	MOV32	R0, GPIOA_CRL				; адрес порта
	MOV		R1, #0x03					; 4-битная маска настроек для Output mode 50mHz, Push-Pull ("0011")
	LDR		R2, [R0]					; считать порт
	BFI		R2, R1, #4, #4    			; скопировать биты маски в позицию PIN1
	BFI		R2, R1, #8, #4    			; скопировать биты маски в позицию PIN2
	BFI		R2, R1, #12, #4    			; скопировать биты маски в позицию PIN3
	BFI		R2, R1, #16, #4    			; скопировать биты маски в позицию PIN4
	BFI		R2, R1, #20, #4    			; скопировать биты маски в позицию PIN5
	BFI		R2, R1, #24, #4    			; скопировать биты маски в позицию PIN6
	BFI		R2, R1, #28, #4    			; скопировать биты маски в позицию PIN7
    STR		R2, [R0]					; загрузить результат в регистр настройки порта

	MOV32	R0, GPIOB_CRL				; адрес порта
	MOV		R1, #0x03					; 4-битная маска настроек для Output mode 50mHz, Push-Pull ("0011")
	LDR		R2, [R0]					; считать порт
    BFI		R2, R1, #0, #4    			; скопировать биты маски в позицию PIN0
	BFI		R2, R1, #4, #4
    STR		R2, [R0]
	
	MOV		R4, #0
	
mainLoop
	CMP 	R4, #0
	BEQ		case0
	CMP 	R4, #1
	BEQ		case1
    CMP     R4, #2
    BEQ     case2
    CMP     R4, #3
    BEQ     case3
    CMP     R4, #4
    BEQ     case4
    CMP     R4, #5
    BEQ     case5
    CMP     R4, #6
    BEQ     case6
    CMP     R4, #7
    BEQ     case7
    CMP     R4, #8
    BEQ     case8
    CMP     R4, #9
    BEQ     case9
    CMP     R4, #10
    BEQ     case10
    CMP     R4, #11
    BEQ     case11
    CMP     R4, #12
    BEQ     case12
    CMP     R4, #13
    BEQ     case13
    CMP     R4, #14
    BEQ     case14
    CMP     R4, #15
    BEQ     case15
    CMP     R4, #16
    BEQ     case16
    CMP     R4, #17
    BEQ     case17
    CMP     R4, #18
    BEQ     case18
    CMP     R4, #19
    BEQ     case19
    CMP     R4, #20
    BEQ     case20

	LDR		R5, =DELAY_VAL

case0
    BL turnOnZeroKatodAndTurnOffSecondKatod

	MOV32	R1, GPIOA_BSRR				; адрес порта выходных сигналов
	MOV		R2, #(PIN4 << 16 | PIN5 << 16)
	STR 	R2, [R1]
	MOV 	R2, #(PIN1)					; устанавливаем вывод в '1'
	STR 	R2, [R1]					; загружаем в порт
	MOV 	R2, #(PIN2)					; устанавливаем вывод в '1'
	STR 	R2, [R1]
	MOV 	R2, #(PIN3)					; устанавливаем вывод в '1'
	STR 	R2, [R1]
	MOV 	R2, #(PIN4)					; устанавливаем вывод в '1'
	STR 	R2, [R1]
	MOV 	R2, #(PIN5)					; устанавливаем вывод в '1'
	STR 	R2, [R1]
	MOV 	R2, #(PIN6)					; устанавливаем вывод в '1'
	STR 	R2, [R1]
	BL		delay

    BL turnOffFirstCatodAndTurnONSecondKatod
	
	MOV32	R1, GPIOA_BSRR				; адрес порта выходных сигналов
	MOV		R2, #(PIN1 << 16|PIN2 << 16|PIN3 << 16|PIN4 << 16|PIN5 << 16|PIN6 << 16)
	STR 	R2, [R1]
	MOV 	R2, #(PIN4)					; устанавливаем вывод в '1'
	STR 	R2, [R1]					; загружаем в порт
	MOV 	R2, #(PIN5)					; устанавливаем вывод в '1'
	STR 	R2, [R1]
	BL		delay

	SUBS	R5, #1
	IT		NE
	BNE		case0

	MOV		R4, #1
	B		mainLoop
	LDR		R5, =DELAY_VAL

case1
    BL turnOnZeroKatodAndTurnOffSecondKatod
	
	MOV32	R1, GPIOA_BSRR				; адрес порта выходных сигналов
	MOV		R2, #(PIN2 << 16 | PIN3 << 16 | PIN5 << 16 | PIN6 << 16 | PIN7 << 16)
	STR 	R2, [R1]
	MOV 	R2, #(PIN1)					; устанавливаем вывод в '1'
	STR 	R2, [R1]					; загружаем в порт
	MOV 	R2, #(PIN2)					; устанавливаем вывод в '1'
	STR 	R2, [R1]
	MOV 	R2, #(PIN3)					; устанавливаем вывод в '1'
	STR 	R2, [R1]
	MOV 	R2, #(PIN4)					; устанавливаем вывод в '1'
	STR 	R2, [R1]
	MOV 	R2, #(PIN5)					; устанавливаем вывод в '1'
	STR 	R2, [R1]
	MOV 	R2, #(PIN6)					; устанавливаем вывод в '1'
	STR 	R2, [R1]
	BL		delay
	
    BL turnOffZeroKatodAndTurnOffSecondKatod
	
	MOV32	R1, GPIOA_BSRR				; адрес порта выходных сигналов
	MOV		R2, #(PIN1 << 16|PIN2 << 16|PIN3 << 16|PIN4 << 16|PIN5 << 16|PIN6 << 16)
	STR 	R2, [R1]
	MOV 	R2, #(PIN2)					
	STR 	R2, [R1]					
	MOV 	R2, #(PIN3)					
	STR 	R2, [R1]
	MOV 	R2, #(PIN5)					
	STR 	R2, [R1]					
	MOV 	R2, #(PIN6)					
	STR 	R2, [R1]
	MOV 	R2, #(PIN7)					
	STR 	R2, [R1]
	BL		delay

	SUBS	R5, #1
	IT		NE
	BNE		case1
	
	B		mainLoop
	ENDP
		

delay        PROC                        ; Подпрограмма задержки
                                        ; Загружаем в стек R0, т.к. его значение будем менять
    LDR     R3, =DELAY_VAL1                ; псевдоинструкция Thumb (загрузить константу в регистр)
delay_loop
    SUBS    R3, #1                        ; SUB с установкой флагов результата
    IT      NE
    BNE		delay_loop                    ; переход, если Z==0 (результат вычитания не равен нулю)
                                        ; Выгружаем из стека R0
    BX      LR                            ; выход из подпрограммы (переход к адресу в регистре LR - вершина стека)
    ENDP
		
    END

turnOnZeroKatodAndTurnOffSecondKatod    PROC
    MOV32    R1, GPIOB_BSRR
    MOV      R2, #(PIN0 << 16)
    STR      R2, [R1]
    MOV      R2, #(PIN1)
    STR      R2, [R1]
    BX       LR                            ; выход из подпрограммы (переход к адресу в регистре LR - вершина стека)
    ENDP

turnOffFirstCatodAndTurnONSecondKatod    PROC
    MOV32    R1, GPIOB_BSRR
    MOV      R2, #(PIN1 << 16)
    STR      R2, [R1]
    MOV      R2, #(PIN0)
    STR      R2, [R1]
    BX       LR                            ; выход из подпрограммы (переход к адресу в регистре LR - вершина стека)
    ENDP
