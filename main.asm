	.data
SSS_0:  .asciiz     "MENU\n           1 - Inserir\n           2 - Remover por indice\n           3 - Remover por valor\n           4 - Listar todos\n           5 - Sair\n"
SSS_1:  .asciiz     "Digite o item que voce quer inserir na lista\n"
SSS_2:  .asciiz     "--Lista Vazia\n"
#TEMPORARIOS
SSS_T1:  .asciiz     "Entrou na fun��o\n"


	.text
main:

	add  $9, $0, $0 #ATRIBUI O CONTADOR DE ITENS NA LISTA PARA ZERO
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
		add	$4, $zero, $v0 #O REGISTRADOR 4 J� VAI SERVIR COMO PASSAGEM DE PAR�METROS
		jal FUNCAO_INSERIR
		
		j PRINTA_MENU
    OPCAO_2:
		#code
    OPCAO_3:
		#code
    OPCAO_4:
		#code
    OPCAO_5:
		#code
	
	
	
	FUNCAO_INSERIR:
    #debuguer
    li	$v0, 4
	la	$a0, SSS_T1
	syscall
	
	
	
	
	
