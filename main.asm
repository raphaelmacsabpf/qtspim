#TRABALHO FEITO POR RAPHAEL MACHADO DOS SANTOS
#E-MAIL raphaelmacsa@gmail.com

	.data
SSS_0:  .asciiz     "MENU\n           1 - Inserir\n           2 - Remover por indice\n           3 - Remover por valor\n           4 - Listar todos\n           5 - Sair\n"
SSS_1:  .asciiz     "Digite o item que voce quer inserir na lista\n"
SSS_2:  .asciiz     "--Lista Vazia\n"
SSS_3:  .asciiz     "Elemento "
SSS_4:  .asciiz     "\n"
SSS_5:  .asciiz     "Elemento inserido no indice "
SSS_6:  .asciiz     "Digite o indice do item que voce quer remover da lista\n"
SSS_7:  .asciiz     "Digite o valor do item que voce quer remover da lista\n"
SSS_8:  .asciiz     "Nao foi possivel inserir\n"
SSS_9:  .asciiz     "Indice removido: "
SSS_10:  .asciiz     "Elemento removido: "
SSS_11:  .asciiz     "Numero de Insercoes: "
SSS_12:  .asciiz     "Numero de Remocoes: "
SSS_13:  .asciiz     "Programa Encerrado, ate a proxima\n"

	.text
main:

	add  $9, $zero, $zero #//ATRIBUI O CONTADOR DE ITENS NA LISTA PARA ZERO
	#ALOCA OS BYTES DE INFORMAÇÕES GERAIS
	    #DESLOCAMENTO 0 = NUMERO DE INSERÇÕES
	    #DESLOCAMENTO 4 = NUMERO DE REMOÇÕES
		li $v0, 9
		li $a0, 8
		syscall
	    la $20 ($v0)        #//ESTE ENDEREÇO É SALVO NO REG 20
	
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
	addi $11, $zero, 1 #//COLOCA NO REGISTRADOR 11 O NUMERO PARA A COMPARAÇÃO
    beq $10,$11, OPCAO_1
    addi $11, $zero, 2 #//COLOCA NO REGISTRADOR 11 O NUMERO PARA A COMPARAÇÃO
    beq $10,$11, OPCAO_2
    addi $11, $zero, 3 #//COLOCA NO REGISTRADOR 11 O NUMERO PARA A COMPARAÇÃO
    beq $10,$11, OPCAO_3
    addi $11, $zero, 4 #//COLOCA NO REGISTRADOR 11 O NUMERO PARA A COMPARAÇÃO
    beq $10,$11, OPCAO_4
    addi $11, $zero, 5 #//COLOCA NO REGISTRADOR 11 O NUMERO PARA A COMPARAÇÃO
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
		addi $18, $zero, -1
		bne $19, $18, NAO_IMPRIME_MENOS_1
		    #IMPRIME MENSAGEM QUE NÃO FOI POSSÍVEL INSERIR
        	li	$v0, 4
			la	$a0, SSS_8
			syscall
			j PRINTA_MENU
		NAO_IMPRIME_MENOS_1:
		jal FUNCAO_INCREMENTA_INSERCOES     #//INCREMENTA O NUMERO DE ITENS QUE FORAM INSERIDOS
		bne $19, $zero, DESVIA_ALTERA_PRIMEIRO
		    la $8, ($25)
		DESVIA_ALTERA_PRIMEIRO:
		#IMPRIME MENSAGEM ELEMENTO
        li	$v0, 4
		la	$a0, SSS_5
		syscall
		#IMPRIME O INDICE
        li	$v0, 1
		add $a0, $19 ,$zero                        #//COPIA PARA O $a0 o inteiro a ser imprimido
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
		#LE O INDICE DA LISTA A SER REMOVIDO E GUARDA NO REGISTRADOR $4
		li	$v0, 5
		syscall
		add	$24, $zero, $v0 		#//O REGISTRADOR 4 JÁ VAI SERVIR COMO PASSAGEM DE PARÂMETROS
        la $25,($8)				#//O REGISTRADOR 5 RECEBERÁ UM APONTAMENTO PARA O PRIMEIRO ELEMENTO DA LISTA (PASSAGEM DE PARAMETRO)
        jal FUNCAO_REMOVER_INDICE
		addi $17, $zero, -1
		beq $17, $24, REMOVEU_2
		    lw $11, 0($20)
		    lw $12, 4($20)
			beq $11, $12, NAO_DEIXA_ULTRAPASSAR_2
            	jal FUNCAO_INCREMENTA_REMOCOES
            NAO_DEIXA_ULTRAPASSAR_2:
		REMOVEU_2:
        #IMPRIME MENSAGEM ELEMENTO
        li	$v0, 4
		la	$a0, SSS_10
		syscall
		#IMPRIME O INDICE
        li	$v0, 1
		add $a0, $24 ,$zero                        #//COPIA PARA O $a0 o inteiro a ser imprimido
		syscall
		#IMPRIME o \n APÓS O ELEMENTO (APENAS FORMATAÇÃO)
        li	$v0, 4
		la	$a0, SSS_4
		syscall
        
		j PRINTA_MENU
    OPCAO_3:#//REmover por valor
		#IMPRIME MENSAGEM PEDINDO VALOR
        li	$v0, 4
		la	$a0, SSS_7
		syscall
		#LE O ITEM DA LISTA A SER REMOVIDO E GUARDA NO REGISTRADOR $4
		li	$v0, 5
		syscall
		add	$24, $zero, $v0 		#//O REGISTRADOR 4 JÁ VAI SERVIR COMO PASSAGEM DE PARÂMETROS
        la $25,($8)				#//O REGISTRADOR 5 RECEBERÁ UM APONTAMENTO PARA O PRIMEIRO ELEMENTO DA LISTA (PASSAGEM DE PARAMETRO)
        jal FUNCAO_REMOVER_VALOR
        addi $17, $zero, -1
		beq $17, $24, REMOVEU_3
		    lw $11, 0($20)
		    lw $12, 4($20)
			beq $11, $12, NAO_DEIXA_ULTRAPASSAR_3
            	jal FUNCAO_INCREMENTA_REMOCOES
            NAO_DEIXA_ULTRAPASSAR_3:

		REMOVEU_3:
         #IMPRIME MENSAGEM ELEMENTO
        li	$v0, 4
		la	$a0, SSS_9
		syscall
		#IMPRIME O INDICE
        li	$v0, 1
		add $a0, $24 ,$zero                        #//COPIA PARA O $a0 o inteiro a ser imprimido
		syscall
		#IMPRIME o \n APÓS O ELEMENTO (APENAS FORMATAÇÃO)
        li	$v0, 4
		la	$a0, SSS_4
		syscall
		j PRINTA_MENU
    OPCAO_4:#//Imprimir
		la	$25, ($8)
		jal FUNCAO_IMPRIMIR
		j PRINTA_MENU
    OPCAO_5:#//Sair do programa
		lw $11, 0($20)
		lw $12, 4($20)
        #IMPRIME MENSAGEM INSERCOES
        li	$v0, 4
		la	$a0, SSS_11
		syscall
		#IMPRIME O INDICE
        li	$v0, 1
		add $a0, $11 ,$zero                        #//COPIA PARA O $a0 o inteiro a ser imprimido
		syscall
		#IMPRIME o \n APÓS O ELEMENTO (APENAS FORMATAÇÃO)
        li	$v0, 4
		la	$a0, SSS_4
		syscall
		
		#IMPRIME MENSAGEM REMOCOES
        li	$v0, 4
		la	$a0, SSS_12
		syscall
		#IMPRIME O INDICE
        li	$v0, 1
		add $a0, $12 ,$zero                        #//COPIA PARA O $a0 o inteiro a ser imprimido
		syscall
		#IMPRIME o \n APÓS O ELEMENTO (APENAS FORMATAÇÃO)
        li	$v0, 4
		la	$a0, SSS_4
		syscall
    
        #IMPRIME MENSAGEM DE SAIDA
        li	$v0, 4
		la	$a0, SSS_13
		syscall
    
		li	$v0, 10								#//Finaliza o programa
		syscall
	
	
	
	FUNCAO_INSERIR:
	la $14, ($24)#//INFORMAÇÃO
	la $15, ($25)#//ENDEREÇO DA LISTA
	#SE FOR O PRIMEIRO A SER INSERIDO
	bne $9,$zero, DESVIO_OPC1_IF1
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
        add $19, $zero,$zero      #//O INDICE DE RETORNO INSERIDO É 0 NESTE CASO
        j FINAL_DOS_IFS_OPC1
	DESVIO_OPC1_IF1:
	#SE FOR MENOR QUE O PRIMEIRO
	lw $13, 0($15)			#//MESMO QUE NÃO EXISTA INFORMAÇÕES ELE CARREGA NO REGISTRADOR 12 O VALOR CONTIDO NO PRIMEIRO ELEMENTO DA LISTA
	slt $12, $14, $13 		#//SETA O REGISTRADOR 12 COMO 1 SE O PRIMEIRO ELEMENTO DA LISTA FORMENOR QUE ELE
	bne $13, $14, OU_EH_IGUAL
	    addi $12, $zero, 1
	OU_EH_IGUAL:
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
        add $19, $zero,$zero      	#//O INDICE DE RETORNO INSERIDO É 0 NESTE CASO
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
FOR_1:  slt $12, $19, $9         #//SETA REG 20 COMO 1 CASO O REGISTRADOR 19 SEJA MENOR QUE 9 (PARA CHECAR DESVIO DO FOR)
		beq $12, $zero, DESVIO_OPC1_FOR
			lw $10, 0($18)
			slt $12, $10, $14
			beq $12, $zero, DESVIO_OPC1_SET
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
		addi $13, $21, -1
		slt $13, $21, $9                        #//COMPARAÇÃO SE O INDICE FOR MAIOR QUE O NUMERO DE ITENS
		bne $13, $zero, NAO_MAIOR
			addi $24, $zero, -1
			jr $ra
		NAO_MAIOR:
		slt $13, $21, $zero                        #//COMPARAÇÃO SE O INDICE FOR MENOR QUE ZERO
		beq $13, $zero, NAO_NEGATIVO
			addi $24, $zero, -1
			jr $ra
		NAO_NEGATIVO:
		beq $9, $zero, PRINTA_LISTA_VAZIA      #//DESVIA PARA IMPRIMIR A LISTA SE A QUANTIDADE DE ELEMENTOS FOR 0
		la $13, ($22)		                   #//COPIA O INICIO DA LISTA PARA O REG AUXILIAR 13
		add $17, $zero, $zero                 #//Registrador 17 será o contador de iteradas
		addi $12, $zero, 1                      #//CARREGA VALOR 1 PARA VERIFICAR SE SO TEM UMELEMTO
	    bne $9, $12,FIM_BNE_OPC2_1           #//VERIFICA SE A LISTA SO TEM UM ELEMENTO
	    bne $21, $zero, FIM_BNE_OPC2_1       #//E VERIFICA TAMBÉM SE O INDICE É ZERO
			sw $zero, 0($22)                        #//COLOCA 0 COMO INFORMAÇÃO DA LISTA
			sw $zero, 4($22)                        #//COLOCA 0 COMO PROXIMO DALISTA DA LISTA
			addi $9, $9, -1                         #//DECREMENTA O CONTADOR DE ITENS
			j FIM_REMOCAO
        FIM_BNE_OPC2_1:
		LACO_OPC2:
			lw $14, 0($13)                          #//CARREGA A INFORMAÇÃO DO NODO PARA O REG 14
		    lw $15, 4($13)                          #//CARREGA O ENDEREÇO DO PROXIMO PARA O REG 15
	    	beq $21, $17 FINAL_DA_PESQUISA          #//ENCONTROU O ENDEREÇO DESEJADO
			beq $15, $zero, FINAL_DA_PESQUISA      #//SE O ENDEREÇO DO PROXIMO ELEMENTO FOR 0 ELE DESVIARÁ
			la $13, ($15)		                    #//COPIA O ELEMENTO PARA O PROXIMO PAR AO REG AUXILIAR 13
			addi $17, $17, 1
			j LACO_OPC2                             #//RETORNA PARA O INICIO DO LACO
		FINAL_DA_PESQUISA:
		beq $13,$22, DESVIO_REMOVE_FIRST            #//DESVIA PARA A OPÇÃO DE REMOVER O PRIMEIRO DA LISTA
		lw $17, 4($13)
		beq $17, $zero, DESVIO_REMOVE_LAST          #//DESVIA PARA A OPÇÃO DE REMOVER O ULTIMO DA LISTA
		#//AQUI É O ELSE OU SEJA REMOVER DOMEIO
		j ELSE_OPC2
		
		DESVIO_REMOVE_FIRST:
		lw $17, 4($22)
		la $8, ($17)
		addi $9, $9 -1
        j FIM_IFS_OPC2
		
		DESVIO_REMOVE_LAST:
			la $12, ($22)
            LACO_OPC2_REMOVE_LAST:
		    lw $15, 4($12)                          #//CARREGA O ENDEREÇO DO PROXIMO PARA O REG 15
	    	beq $15, $13 FINAL_DA_PESQUISA_REMOVE_LAST          #//ENCONTROU O ENDEREÇO DESEJADO
			la $12, ($15)		                    #//COPIA O ELEMENTO PARA O PROXIMO PAR AO REG AUXILIAR 13
			j LACO_OPC2_REMOVE_LAST                             #//RETORNA PARA O INICIO DO LACO
			FINAL_DA_PESQUISA_REMOVE_LAST:
			sw $zero, 4($12)
			addi $9, $9 -1
		j FIM_IFS_OPC2
		
		ELSE_OPC2: #//É PARA REMOVER QUALQUER OUTRO NÃO SENDO O PRIMEIRO E NEM O ÚLTIMO
        	la $12, ($22)
            LACO_OPC2_REMOVE_OUTRO:
		    lw $15, 4($12)                          #//CARREGA O ENDEREÇO DO PROXIMO PARA O REG 15
	    	beq $15, $13 FINAL_DA_PESQUISA_REMOVE_OUTRO          #//ENCONTROU O ENDEREÇO DESEJADO
			la $12, ($15)		                    #//COPIA O ELEMENTO PARA O PROXIMO PAR AO REG AUXILIAR 13
			j LACO_OPC2_REMOVE_OUTRO                             #//RETORNA PARA O INICIO DO LACO
			FINAL_DA_PESQUISA_REMOVE_OUTRO:
			lw $23, 4($13)
			sw $23, 4($12)										#//ATUALIZA NODO->PREVIOUS->NEXT
			addi $9, $9 -1
		FIM_IFS_OPC2:

		
	FIM_REMOCAO:
		la $24, ($14)
	jr $ra
	
	
	FUNCAO_IMPRIMIR:
	la $16, ($25)#//ENDEREÇO DA LISTA
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
		add $a0, $14 ,$zero                        #//COPIA PARA O $a0 o inteiro a ser imprimido
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
	
	
	
	FUNCAO_REMOVER_VALOR:
		addi $17, $zero, -1          #//APENAS PARA SABER SE HOUVE REMOÇÃO
	    la $21, ($24)#//INFO
		la $22, ($25)#//ENDEREÇO DA LISTA
		add $11, $zero, $zero                  #//CONTADOR DE ITERADAS
		beq $9, $zero, PRINTA_LISTA_VAZIA      #//DESVIA PARA IMPRIMIR A LISTA SE A QUANTIDADE DE ELEMENTOS FOR 0
		la $13, ($22)		                   #//COPIA O INICIO DA LISTA PARA O REG AUXILIAR 13
        FIM_BNE_OPC3_1:
		LACO_OPC3:
			lw $14, 0($13)                          #//CARREGA A INFORMAÇÃO DO NODO PARA O REG 14
		    lw $15, 4($13)                          #//CARREGA O ENDEREÇO DO PROXIMO PARA O REG 15
	    	beq $21, $14 FINAL_DA_PESQUISA_OPC3          #//ENCONTROU O ENDEREÇO DESEJADO
			addi $11, $11, 1
			beq $15, $zero, FIM_REMOCAO_OPC3      #//SE O ENDEREÇO DO PROXIMO ELEMENTO FOR 0 ELE DESVIARÁ
			la $13, ($15)		                    #//COPIA O ELEMENTO PARA O PROXIMO PAR AO REG AUXILIAR 13
			j LACO_OPC3                             #//RETORNA PARA O INICIO DO LACO
		FINAL_DA_PESQUISA_OPC3:
		beq $13,$22, DESVIO_REMOVE_FIRST_OPC3            #//DESVIA PARA A OPÇÃO DE REMOVER O PRIMEIRO DA LISTA
		lw $17, 4($13)
		beq $17, $zero, DESVIO_REMOVE_LAST_OPC3          #//DESVIA PARA A OPÇÃO DE REMOVER O ULTIMO DA LISTA
		#//AQUI É O ELSE OU SEJA REMOVER DOMEIO
		j ELSE_OPC3

		DESVIO_REMOVE_FIRST_OPC3:
		lw $26, 4($22)
		la $8, ($26)
		addi $9, $9 -1
		add $17, $zero, $zero          #//APENAS PARA SABER SE HOUVE REMOÇÃO
        j FIM_IFS_OPC3

		DESVIO_REMOVE_LAST_OPC3:
			la $12, ($22)
            LACO_OPC3_REMOVE_LAST:
		    lw $15, 4($12)                          #//CARREGA O ENDEREÇO DO PROXIMO PARA O REG 15
	    	beq $15, $13 FINAL_DA_PESQUISA_REMOVE_LAST_OPC3          #//ENCONTROU O ENDEREÇO DESEJADO
			la $12, ($15)		                    #//COPIA O ELEMENTO PARA O PROXIMO PAR AO REG AUXILIAR 13
			j LACO_OPC3_REMOVE_LAST                             #//RETORNA PARA O INICIO DO LACO
			FINAL_DA_PESQUISA_REMOVE_LAST_OPC3:
			sw $zero, 4($12)
			addi $9, $9 -1
			add $17, $zero, $zero          #//APENAS PARA SABER SE HOUVE REMOÇÃO
		j FIM_IFS_OPC3

		ELSE_OPC3: #//É PARA REMOVER QUALQUER OUTRO NÃO SENDO O PRIMEIRO E NEM O ÚLTIMO
        	la $12, ($22)
            LACO_OPC3_REMOVE_OUTRO:
		    lw $15, 4($12)                          #//CARREGA O ENDEREÇO DO PROXIMO PARA O REG 15
	    	beq $15, $13 FINAL_DA_PESQUISA_REMOVE_OUTRO_OPC3          #//ENCONTROU O ENDEREÇO DESEJADO
			la $12, ($15)		                    #//COPIA O ELEMENTO PARA O PROXIMO PAR AO REG AUXILIAR 13
			j LACO_OPC3_REMOVE_OUTRO                             #//RETORNA PARA O INICIO DO LACO
			FINAL_DA_PESQUISA_REMOVE_OUTRO_OPC3:
			lw $23, 4($13)
			sw $23, 4($12)										#//ATUALIZA NODO->PREVIOUS->NEXT
			addi $9, $9 -1
			add $17, $zero, $zero          #//APENAS PARA SABER SE HOUVE REMOÇÃO
		FIM_IFS_OPC3:
	FIM_REMOCAO_OPC3:
	beq $17, $zero, HOUVE_REMOCAO
	    addi $11, $zero, -1
	HOUVE_REMOCAO:
	la $24, ($11)
	jr $ra
	
	
	
	
	FUNCAO_INCREMENTA_INSERCOES:
	    lw $12 0($20)
	    addi $12, $12, 1
	    sw $12, 0($20)
	jr $ra
	
	FUNCAO_INCREMENTA_REMOCOES:
	    lw $12 4($20)
	    addi $12, $12, 1
	    sw $12, 4($20)
	jr $ra
	
