	.data
SSS_0:  .asciiz     "MENU\n           1 - Inserir\n           2 - Remover por indice\n           3 - Remover por valor\n           4 - Listar todos\n           5 - Sair\n"
SSS_1:  .asciiz     "Digite o item que voce quer inserir na lista\n"
SSS_2:  .asciiz     "--Lista Vazia\n"


	.text
main:

	add  $9, $0, $0 #ATRIBUI O CONTADOR DE ITENS NA LISTA PARA ZERO
	PRINTA_MENU:
	li	$v0, 4			#Imprimindo o Menu
	la	$a0, SSS_0
	syscall
	#FIM DA IMPRESSÃO DO MENU

