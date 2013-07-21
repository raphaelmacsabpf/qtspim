	.data
SSS_0:  .asciiz     "MENU\n           1 - Inserir\n           2 - Remover por indice\n           3 - Remover por valor\n           4 - Listar todos\n           5 - Sair\n"
SSS_1:  .asciiz     "Digite o item que voce quer inserir na lista\n"
SSS_2:  .asciiz     "--Lista Vazia\n"
#TEMPORARIOS
SSS_T1:  .asciiz     "Entrou na função\n"


	.text
main:

	add  $9, $0, $0 #//ATRIBUI O CONTADOR DE ITENS NA LISTA PARA ZERO
	PRINTA_MENU:
	#IMPRIMINDO O MENU
	li	$v0, 4			
	la	$a0, SSS_0
	syscall
	#FIM DA IMPRESSÃO DO MENU
	#LE A OPÇÃO QUE FOI DIGITADA
	li	$v0, 5
	syscall
	add	$10, $zero, $v0      #//$10 É ONDE FICA ARMAZENADO A OPÇÃO QUE O USUÁRIO ESCOLHEU
	#FIM DE LEITURA DA OPÇÃO DIGITADA
	addi $11, $0, 1 #//COLOCA NO REGISTRADOR 11 O NUMERO PARA A COMPARAÇÃO
    beq $10,$11, OPCAO_1
    addi $11, $0, 2 #//COLOCA NO REGISTRADOR 11 O NUMERO PARA A COMPARAÇÃO
    beq $10,$11, OPCAO_2
    addi $11, $0, 3 #//COLOCA NO REGISTRADOR 11 O NUMERO PARA A COMPARAÇÃO
    beq $10,$11, OPCAO_3
    addi $11, $0, 4 #//COLOCA NO REGISTRADOR 11 O NUMERO PARA A COMPARAÇÃO
    beq $10,$11, OPCAO_4
    addi $11, $0, 5 #//COLOCA NO REGISTRADOR 11 O NUMERO PARA A COMPARAÇÃO
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
		add	$4, $zero, $v0 		#//O REGISTRADOR 4 JÁ VAI SERVIR COMO PASSAGEM DE PARÂMETROS
		jal FUNCAO_INSERIR 		#//Chama a função para inserir o elemento
		
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
	bne $9,$0, DESVIO_OPC1_IF1
	    #debug
	    li	$v0, 4
		la	$a0, SSS_T1
		syscall
		#fim do debug SÓ PARA SABER SE ENTROU NA FUNÇÃO
		#COMEÇA A ALOCAR
		li $v0, 9
		li $a0, 8
		syscall
		#AQUI JÁ TENHO ELE ALOCADO E O ENDEREÇO EM $v0
		add $8, $zero, $v0 	#//COPIO O ENDEREÇO QUE FOI ALOCADO PARA O INICIO DA LISTA QUE É $8
        sw $4, 0($8)		#//COLOCA O VALOR ESCOLHIDO COMO PRIMEIRO ELEMENTO DA LISTA
        sw $zero,4($8) 		#//O PRÓXIMO ELEMENTO DA LISTA É NULO QUE NESTE CASO É ZERO
        addi $9,$9,1		#//ATUALIZA O CONTADOR DE QUANTOS ELEMENTOS NA LISTA
        j FINAL_DOS_IFS_OPC1
	DESVIO_OPC1_IF1:
	lw $12, 0($8)			#//MESMO QUE NÃO EXISTA INFORMAÇÕES ELE CARREGA NO REGISTRADOR 12 O VALOR CONTIDO NO PRIMEIRO ELEMENTO DA LISTA
	slt $12, $4, $12 		#//SETA O REGISTRADOR 12 COMO 1 SE O PRIMEIRO ELEMENTO DA LISTA FORMENOR QUE ELE
	beq $12, $zero, DESVIO_OPC1_IF2         #//SE O SLT DEU FALSO ELE DESVIA
	    #COMEÇA A ALOCAR
		li $v0, 9
		li $a0, 8
		syscall
		#AQUI JÁ TENHO ELE ALOCADO E O ENDEREÇO EM $v0
		add $13, $zero, $v0 	#//COPIO O ENDEREÇO QUE FOI ALOCADO PARA MEU NODO TEMPORARIO REG 13
	    sw $4,0($13)            #//GUARDA O ELEMENTO NO NODO TEMPORARIO 13
        sw $8, 4($13)           #//COLOCA O ANTIGO PRIMEIRO ELEMENTO DA LISTA COMO PRÓXIMO DO NOVO PRIMEIRO
        add $8, $zero, $13		#//ATUALIZA O NOVO PRIMEIRO ELEMENTO
        addi $9, $9, 1			#//ATUALIZA O CONTADOR DE QUANTOS ELEMENTOS NA LISTA
	DESVIO_OPC1_IF2:

	FINAL_DOS_IFS_OPC1:
    jr $ra
	
	
	
	
