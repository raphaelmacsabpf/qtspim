	.data
SSS_0:  .asciiz     "MENU\n           1 - Inserir\n           2 - Remover por indice\n           3 - Remover por valor\n           4 - Listar todos\n           5 - Sair\n"
SSS_1:  .asciiz     "Digite o item que voce quer inserir na lista\n"
SSS_2:  .asciiz     "--Lista Vazia\n"
SSS_3:  .asciiz     "\nElemento "
SSS_4:  .asciiz     "\n"
#TEMPORARIOS
SSS_T1:  .asciiz     "Entrou na fun��o\n"


	.text
main:

	add  $9, $0, $0 #//ATRIBUI O CONTADOR DE ITENS NA LISTA PARA ZERO
	PRINTA_MENU:
	#IMPRIMINDO O MENU
	li	$v0, 4			
	la	$a0, SSS_0
	syscall
	#FIM DA IMPRESS�O DO MENU
	#LE A OP��O QUE FOI DIGITADA
	li	$v0, 5
	syscall
	add	$10, $zero, $v0      #//$10 � ONDE FICA ARMAZENADO A OP��O QUE O USU�RIO ESCOLHEU
	#FIM DE LEITURA DA OP��O DIGITADA
	addi $11, $0, 1 #//COLOCA NO REGISTRADOR 11 O NUMERO PARA A COMPARA��O
    beq $10,$11, OPCAO_1
    addi $11, $0, 2 #//COLOCA NO REGISTRADOR 11 O NUMERO PARA A COMPARA��O
    beq $10,$11, OPCAO_2
    addi $11, $0, 3 #//COLOCA NO REGISTRADOR 11 O NUMERO PARA A COMPARA��O
    beq $10,$11, OPCAO_3
    addi $11, $0, 4 #//COLOCA NO REGISTRADOR 11 O NUMERO PARA A COMPARA��O
    beq $10,$11, OPCAO_4
    addi $11, $0, 5 #//COLOCA NO REGISTRADOR 11 O NUMERO PARA A COMPARA��O
    beq $10,$11, OPCAO_5
    j PRINTA_MENU
    
    OPCAO_1:
        #IMPRIME MENSAGEM PEDINDO ELEMENTO
        li	$v0, 4
		la	$a0, SSS_1
		syscall
		#LE O ITEM DA LISTA A SER INSERIDO E GUARDA NO REGISTRADOR $4
		li	$v0, 5
		syscall
		add	$4, $zero, $v0 		#//O REGISTRADOR 4 J� VAI SERVIR COMO PASSAGEM DE PAR�METROS
        la $5,($8)				#//O REGISTRADOR 5 RECEBER� UM APONTAMENTO PARA O PRIMEIRO ELEMENTO DA LISTA (PASSAGEM DE PARAMETRO)
		jal FUNCAO_INSERIR 		#//Chama a fun��o para inserir o elemento
		
		j PRINTA_MENU
    OPCAO_2:
		#code
		j PRINTA_MENU
    OPCAO_3:
		#code
		j PRINTA_MENU
    OPCAO_4:
		la	$5, ($8)
		jal FUNCAO_IMPRIMIR
		j PRINTA_MENU
    OPCAO_5:
		#code
		j PRINTA_MENU
	
	
	
	FUNCAO_INSERIR:
	add $14, $zero, $4
	add $15, $zero, $5
	bne $9,$0, DESVIO_OPC1_IF1
		#COME�A A ALOCAR
		li $v0, 9
		li $a0, 8
		syscall
		#AQUI J� TENHO ELE ALOCADO E O ENDERE�O EM $v0
		la $15, ($v0)	 	#//COPIO O ENDERE�O QUE FOI ALOCADO PARA O INICIO DA LISTA QUE � $8
        sw $14, 0($15)		#//COLOCA O VALOR ESCOLHIDO COMO PRIMEIRO ELEMENTO DA LISTA
        sw $zero,4($15) 		#//O PR�XIMO ELEMENTO DA LISTA � NULO QUE NESTE CASO � ZERO
        addi $9,$9,1		#//ATUALIZA O CONTADOR DE QUANTOS ELEMENTOS NA LISTA
        j FINAL_DOS_IFS_OPC1
	DESVIO_OPC1_IF1:
	lw $12, 0($15)			#//MESMO QUE N�O EXISTA INFORMA��ES ELE CARREGA NO REGISTRADOR 12 O VALOR CONTIDO NO PRIMEIRO ELEMENTO DA LISTA
	slt $12, $14, $12 		#//SETA O REGISTRADOR 12 COMO 1 SE O PRIMEIRO ELEMENTO DA LISTA FORMENOR QUE ELE
	beq $12, $zero, DESVIO_OPC1_IF2         #//SE O SLT DEU FALSO ELE DESVIA
	    #COME�A A ALOCAR
		li $v0, 9
		li $a0, 8
		syscall
		#AQUI J� TENHO ELE ALOCADO E O ENDERE�O EM $v0
		la $13, ($v0)			 #//COPIO O ENDERE�O QUE FOI ALOCADO PARA MEU NODO TEMPORARIO REG 13
	    sw $14,0($13)            #//GUARDA O ELEMENTO NO NODO TEMPORARIO 13
        sw $15, 4($13)           #//COLOCA O ANTIGO PRIMEIRO ELEMENTO DA LISTA COMO PR�XIMO DO NOVO PRIMEIRO
        la $15, ($13)            #//ATUALIZA O NOVO PRIMEIRO ELEMENTO
        addi $9, $9, 1			#//ATUALIZA O CONTADOR DE QUANTOS ELEMENTOS NA LISTA
	DESVIO_OPC1_IF2:
		#CONTINUAR AQUI DEPOIS
	FINAL_DOS_IFS_OPC1:
    jr $ra
	#FINAL DA FUN��O DE INSERIR
	
	
	
	
	FUNCAO_IMPRIMIR:
	la $16, ($5)
	                            #debug
							    li	$v0, 4
								la	$a0, SSS_T1
								syscall
								#fim do debug S� PARA SABER SE ENTROU NA FUN��O
	beq $9, $zero, PRINTA_LISTA_VAZIA      #//DESVIA PARA IMPRIMIR A LISTA SE A QUANTIDADE DE ELEMENTOS FOR 0
	la $13, ($16)		                   #//COPIA O INICIO DA LISTA PARA O REG AUXILIAR 13
	LACO_OPC4:
		lw $14, 0($13)                          #//CARREGA A INFORMA��O DO NODO PARA O REG 14
	    lw $15, 4($13)                          #//CARREGA O ENDERE�O DO PROXIMO PARA O REG 15
	    #IMPRIME MENSAGEM DE ELEMENTO
        li	$v0, 4
		la	$a0, SSS_3
		syscall
		#IMPRIME O ELEMENTO
        li	$v0, 1
		add $a0, $14 ,$0                        #//COPIA PARA O $a0 o inteiro a ser imprimido
		syscall
		#IMPRIME o \n AP�S O ELEMENTO (APENAS FORMATA��O)
        li	$v0, 4
		la	$a0, SSS_4
		syscall
		beq $15, $zero, FINAL_DO_IMPRIMIR       #//SE O ENDERE�O DO PROXIMO ELEMENTO FOR 0 ELE DESVIAR�
		la $13, ($15)		                    #//COPIA O ELEMENTO PARA O PROXIMO PAR AO REG AUXILIAR 13
		j LACO_OPC4                             #//RETORNA PARA O INICIO DO LACO
	FINAL_DO_IMPRIMIR:
	jr $ra
	PRINTA_LISTA_VAZIA:
 	#IMPRIME MENSAGEM DE LISTA VAZIA
        li	$v0, 4
		la	$a0, SSS_2
		syscall
		jr $ra
	#FINAL DA FUN��O DE IMPRIMIR
	
	
