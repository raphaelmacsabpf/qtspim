	.data
SSS_0:  .asciiz     "MENU\n           1 - Inserir\n           2 - Remover por indice\n           3 - Remover por valor\n           4 - Listar todos\n           5 - Sair\n"
SSS_1:  .asciiz     "Digite o item que voce quer inserir na lista\n"
SSS_2:  .asciiz     "--Lista Vazia\n"
SSS_3:  .asciiz     "Elemento "
SSS_4:  .asciiz     "\n"
SSS_5:  .asciiz     "Elemento inserido no indice "
SSS_6:  .asciiz     "Digite o indice do item que voce quer remover da lista\n"
#TEMPORARIOS
SSS_T1:  .asciiz     "Entrou na função\n"


	.text
main:

	add  $9, $0, $0 #//ATRIBUI O CONTADOR DE ITENS NA LISTA PARA ZERO
	
	#COMEÇA A ALOCAR O ELEMENTO DE TESTE
	li $v0, 9
	li $a0, 8
	syscall
	#AQUI JÁ TENHO ELE ALOCADO E O ENDEREÇO EM $v0
	la $8, ($v0)	 	#//COPIO O ENDEREÇO QUE FOI ALOCADO PARA O INICIO DA LISTA QUE É $8
    sw $zero, 0($8)		#//COLOCA O VALOR ESCOLHIDO COMO PRIMEIRO ELEMENTO DA LISTA
    sw $zero,4($8) 		#//O PRÓXIMO ELEMENTO DA LISTA É NULO QUE NESTE CASO É ZERO
	
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
    
    OPCAO_1:#//Inserir
        #IMPRIME MENSAGEM PEDINDO ELEMENTO
        li	$v0, 4
		la	$a0, SSS_1
		syscall
		#LE O ITEM DA LISTA A SER INSERIDO E GUARDA NO REGISTRADOR $4
		li	$v0, 5
		syscall
		add	$24, $zero, $v0 		#//O REGISTRADOR 4 JÁ VAI SERVIR COMO PASSAGEM DE PARÂMETROS
        la $25,($8)				#//O REGISTRADOR 5 RECEBERÁ UM APONTAMENTO PARA O PRIMEIRO ELEMENTO DA LISTA (PASSAGEM DE PARAMETRO)
		jal FUNCAO_INSERIR 		#//Chama a função para inserir o elemento
		bne $19, $0, DESVIA_ALTERA_PRIMEIRO
		    la $8, ($25)
		DESVIA_ALTERA_PRIMEIRO:
		#IMPRIME MENSAGEM PEDINDO ELEMENTO
        li	$v0, 4
		la	$a0, SSS_5
		syscall
		#IMPRIME O INDICE
        li	$v0, 1
		add $a0, $19 ,$0                        #//COPIA PARA O $a0 o inteiro a ser imprimido
		syscall
		#IMPRIME o \n APÓS O ELEMENTO (APENAS FORMATAÇÃO)
        li	$v0, 4
		la	$a0, SSS_4
		syscall
		
		
		j PRINTA_MENU
    OPCAO_2:#//Remover por índice
		#IMPRIME MENSAGEM PEDINDO INDICE
        li	$v0, 4
		la	$a0, SSS_6
		syscall
		#LE O ITEM DA LISTA A SER INSERIDO E GUARDA NO REGISTRADOR $4
		li	$v0, 5
		syscall
		add	$24, $zero, $v0 		#//O REGISTRADOR 4 JÁ VAI SERVIR COMO PASSAGEM DE PARÂMETROS
        la $25,($8)				#//O REGISTRADOR 5 RECEBERÁ UM APONTAMENTO PARA O PRIMEIRO ELEMENTO DA LISTA (PASSAGEM DE PARAMETRO)
        jal FUNCAO_REMOVER_INDICE
		j PRINTA_MENU
    OPCAO_3:#//REmover por valor
		#code
		j PRINTA_MENU
    OPCAO_4:#//Imprimir
		la	$25, ($8)
		jal FUNCAO_IMPRIMIR
		j PRINTA_MENU
    OPCAO_5:#//Sair do programa
		li	$v0, 10								#//Finaliza o programa
		syscall
	
	
	
	FUNCAO_INSERIR:
	la $14, ($24)#//INFORMAÇÃO
	la $15, ($25)#//ENDEREÇO DA LISTA
	#SE FOR O PRIMEIRO A SER INSERIDO
	bne $9,$0, DESVIO_OPC1_IF1
		#COMEÇA A ALOCAR
		li $v0, 9
		li $a0, 8
		syscall
		#AQUI JÁ TENHO ELE ALOCADO E O ENDEREÇO EM $v0
		la $23, ($v0)	 	#//COPIO O ENDEREÇO QUE FOI ALOCADO PARA O INICIO DA LISTA QUE É $8
        sw $14, 0($23)		#//COLOCA O VALOR ESCOLHIDO COMO PRIMEIRO ELEMENTO DA LISTA
        sw $zero,4($23) 	#//O PRÓXIMO ELEMENTO DA LISTA É NULO QUE NESTE CASO É ZERO
        addi $9,$9,1		#//ATUALIZA O CONTADOR DE QUANTOS ELEMENTOS NA LISTA
        la $25, ($23)
        add $19, $0,$0      #//O INDICE DE RETORNO INSERIDO É 0 NESTE CASO
        j FINAL_DOS_IFS_OPC1
	DESVIO_OPC1_IF1:
	#SE FOR MENOR QUE O PRIMEIRO
	lw $12, 0($15)			#//MESMO QUE NÃO EXISTA INFORMAÇÕES ELE CARREGA NO REGISTRADOR 12 O VALOR CONTIDO NO PRIMEIRO ELEMENTO DA LISTA
	slt $12, $14, $12 		#//SETA O REGISTRADOR 12 COMO 1 SE O PRIMEIRO ELEMENTO DA LISTA FORMENOR QUE ELE
	beq $12, $zero, DESVIO_OPC1_IF2         #//SE O SLT DEU FALSO ELE DESVIA
	    #COMEÇA A ALOCAR
		li $v0, 9
		li $a0, 8
		syscall
		#AQUI JÁ TENHO ELE ALOCADO E O ENDEREÇO EM $v0
		bne $v0, $zero, POS_VERFICACAO
		    addi $19, $23, -1 #retorna -1
			j FINAL_DOS_IFS_OPC1
		POS_VERFICACAO:
		la $17, ($15)
		la $13, ($v0)			 #//COPIO O ENDEREÇO QUE FOI ALOCADO PARA MEU NODO TEMPORARIO REG 13
	    sw $14,0($13)            #//GUARDA O ELEMENTO NO NODO TEMPORARIO 13
        
        la $15, ($13)            #//ATUALIZA O NOVO PRIMEIRO ELEMENTO
        sw $17, 4($15)           #//COLOCA O ANTIGO PRIMEIRO ELEMENTO DA LISTA COMO PRÓXIMO DO NOVO PRIMEIRO
        addi $9, $9, 1			#//ATUALIZA O CONTADOR DE QUANTOS ELEMENTOS NA LISTA
        add $19, $0,$0      	#//O INDICE DE RETORNO INSERIDO É 0 NESTE CASO
        la $25, ($15)
        j FINAL_DOS_IFS_OPC1
	DESVIO_OPC1_IF2:
	#SE FOR MAIOR QUE O PRIMEIRO AI JA ENSERE ORDENADO
    	#COMEÇA A ALOCAR
		li $v0, 9
		li $a0, 8
		syscall
		#AQUI JÁ TENHO ELE ALOCADO E O ENDEREÇO EM $v0
		la $13, ($v0)			 #//COPIO O ENDEREÇO QUE FOI ALOCADO PARA MEU NODO TEMPORARIO REG 13
		sw $14, 0($13)           #//INSERE A INFORMAÇÃO
		sw $zero, 4($13)         #//COLOCA O PROXIMO ELEMENTO COMO ZERO PARA QUE NÃO DE ERRO QUANDO FOR O ÚLTIMO
		la $18, ($15)            #//CARREGA PARA O REG 18 UMA CÓPIA DO PRIMEIRO ELEMENTO DA LISTA
		add $19, $zero, $zero    #//ESTE REGISTRADOR GUARDA O NÚMERO DE ITERAÇÕES
		add $23, $zero, $zero
FOR_1:  slt $20, $19, $9         #//SETA REG 20 COMO 1 CASO O REGISTRADOR 19 SEJA MENOR QUE 9 (PARA CHECAR DESVIO DO FOR)
		beq $20, $zero, DESVIO_OPC1_FOR
			lw $10, 0($18)
			slt $20, $10, $14
			
			beq $20, $zero, DESVIO_OPC1_SET
			    addi $23, $23, 1
				la $11, ($18)
			DESVIO_OPC1_SET:
			lw $21, 4($18)
			beq $21, $zero, DESVIO_OPC1_PROXIMO_ZERADO
			lw $18, 4($18)
			DESVIO_OPC1_PROXIMO_ZERADO:
			addi $19,$19, 1
			j FOR_1
        DESVIO_OPC1_FOR:
        lw $12, 4($11)
		sw $12, 4($13)
		sw $13, 4($11)
		addi $9, $9, 1
		add $19, $23, $zero
		j FINAL_DOS_IFS_OPC1
	FINAL_DOS_IFS_OPC1:
    jr $ra
	#FINAL DA FUNÇÃO DE INSERIR
	
	FUNCAO_REMOVER_INDICE:
	    la $21, ($24)#//INDICE
		la $22, ($25)#//ENDEREÇO DA LISTA
		
		beq $9, $zero, PRINTA_LISTA_VAZIA      #//DESVIA PARA IMPRIMIR A LISTA SE A QUANTIDADE DE ELEMENTOS FOR 0
		la $13, ($22)		                   #//COPIA O INICIO DA LISTA PARA O REG AUXILIAR 13
		add $17, $zero, $zero                 #//Registrador 17 será o contador de iteradas
		addi $12, $zero, 1                      #//CARREGA VALOR 1 PARA VERIFICAR SE SO TEM UMELEMTO
	    bne $9, $12,FIM_BNE_OPC2_1           #//VERIFICA SE A LISTA SO TEM UM ELEMENTO
			sw $zero, 0($22)                        #//COLOCA 0 COMO INFORMAÇÃO DA LISTA
			sw $zero, 4($22)                        #//COLOCA 0 COMO PROXIMO DALISTA DA LISTA
			addi $9, $9, -1                         #//DECREMENTA O CONTADOR DE ITENS
			j FIM_REMOCAO
        FIM_BNE_OPC2_1:
		LACO_OPC2:
			lw $14, 0($13)                          #//CARREGA A INFORMAÇÃO DO NODO PARA O REG 14
		    lw $15, 4($13)                          #//CARREGA O ENDEREÇO DO PROXIMO PARA O REG 15
			
		    
		    	beq $21, $17 FINAL_DA_PESQUISA          #//ENCONTROU O ENDEREÇO DESEJADO
			FIM_ELSE:
			beq $15, $zero, FINAL_DA_PESQUISA      #//SE O ENDEREÇO DO PROXIMO ELEMENTO FOR 0 ELE DESVIARÁ
			la $13, ($15)		                    #//COPIA O ELEMENTO PARA O PROXIMO PAR AO REG AUXILIAR 13
			addi $17, $17, 1
			j LACO_OPC2                             #//RETORNA PARA O INICIO DO LACO
	FINAL_DA_PESQUISA:

	FIM_REMOCAO:
		
	jr $ra
	
	
	FUNCAO_IMPRIMIR:
	la $16, ($25)#//ENDEREÇO DA LISTA
	                            #debug
							    li	$v0, 4
								la	$a0, SSS_T1
								syscall
								#fim do debug SÓ PARA SABER SE ENTROU NA FUNÇÃO
	beq $9, $zero, PRINTA_LISTA_VAZIA      #//DESVIA PARA IMPRIMIR A LISTA SE A QUANTIDADE DE ELEMENTOS FOR 0
	la $13, ($16)		                   #//COPIA O INICIO DA LISTA PARA O REG AUXILIAR 13
	LACO_OPC4:
		lw $14, 0($13)                          #//CARREGA A INFORMAÇÃO DO NODO PARA O REG 14
	    lw $15, 4($13)                          #//CARREGA O ENDEREÇO DO PROXIMO PARA O REG 15
	    #IMPRIME MENSAGEM DE ELEMENTO
        li	$v0, 4
		la	$a0, SSS_3
		syscall
		#IMPRIME O ELEMENTO
        li	$v0, 1
		add $a0, $14 ,$0                        #//COPIA PARA O $a0 o inteiro a ser imprimido
		syscall
		#IMPRIME o \n APÓS O ELEMENTO (APENAS FORMATAÇÃO)
        li	$v0, 4
		la	$a0, SSS_4
		syscall
		beq $15, $zero, FINAL_DO_IMPRIMIR       #//SE O ENDEREÇO DO PROXIMO ELEMENTO FOR 0 ELE DESVIARÁ
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
	#FINAL DA FUNÇÃO DE IMPRIMIR
