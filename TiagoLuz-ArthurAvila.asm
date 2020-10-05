.text
.globl main
main:
	# vetor de dados
	la  $a0, F1
	jal print
	la $t0, VetorDados	# endereço da posicao inicial do vetor de dados
	addi $sp, $sp, -4	# cria uma entrada na pilha
	sw $t0, 0 ($sp)		# endereço da posicao inicial do vetor de dados na pilha
	jal carregavetor	# chama funcao para carrega vetor

	lw $t0, 0 ($sp)       # le tamanho do vetor informado
	addi $sp, $sp, 4      # reposiciona $sp
	la $t1, TamVetorDados # endereço do TamVetorDados
	sw $t0, 0($t1)          # salva na memória

	la  $a0, F2 		# vetor de padrao
	jal print

	la $t0, VetorPadrao	# endereço da posicao inicial do vetor de dados
	addi $sp, $sp, -4	# cria uma entrada na pilha
	sw $t0, 0 ($sp)		# endereço da posicao inicial do vetor de dados na pilha
	jal carregavetor	# chama funcao para carrega vetor

	lw $t0, 0 ($sp)       # le tamanho do vetor informado
	addi $sp, $sp, 4      # reposiciona $sp
	la $t1, TamVetorPadrao # endereço do TamVetorDados
	sw $t0, 0($t1)          # salva na memória

  	# INICIA O PROCEDIMENTO DE CONTAGEM PADRAO
  	li $t0, 0 	# define contabilizaPadrao = 0
  	li $t1, 0 	# define posicaoDados = 0

	la $t4, TamVetorDados
	lw $t4, 0($t4)

	la $t5, TamVetorPadrao
	lw $t5, 0($t5)

contabilizaLoop:

	addu $t3, $t1, $t5 	# $t3 = posicaoDados + tamanhoVetorPadrao

	move  $a0, $t3
	jal printnum

	bgt $t3, $t4, contabilizaLoopFinalizado # sai do loop


	# logica da contabilização dos padrões



	# fim da logica da contabilização dos padrões


	addiu $t1, $t1, 1	# incrementa contador $t1 posicaoDados

	j contabilizaLoop

contabilizaLoopFinalizado:

	la  $a0, F5
	jal print

	la $a0 , 0($t0)
	jal printnum

	j encerra

carregavetor:

	lw $t4, 0 ($sp)   # le endereco inicial do vetor
	addi $sp, $sp, 4  # reposiciona $sp
	addi $sp, $sp, -4	# cria uma entrada na pilha
	sw $ra, 0 ($sp)		# salva na pilha endereço de retorno do ra

	la  $a0, F3		# imprime F3
	jal print		# chama funcao de impressão
	li $v0, 5 		# lê do console
	syscall
	move $t2, $v0 # tamanho do vetor em $t2
	li $t1, 0 # define contador $t1 = 0

carregadado:
  	beq $t1, $t2, vetorcarregado
  	addiu $t1, $t1, 1	# i++
  	la  $a0, F4
  	jal print
  	li $v0, 5 		# lê do console
  	syscall
	sw $v0, 0($t4)	# salva o valor informado na posicao atual do vetor
	addi $t4, $t4, 4	# move o pontero do vetor para a próxima posicao
	j carregadado

vetorcarregado:
	la  $a0, DEBUG
	jal print
	lw $t5, 0 ($sp)		# lê o endereço de retorno da pilha
	addi $sp, $sp, 4	# reposiciona $sp
	addi $sp, $sp, -4	# cria uma posicao na pilha
	sw $t2, 0($sp)  	# adiciona à pilha o tamanho do vetor
	jr $t5 		# retorna para a chamada original

print: 			# funcao auxiliar para imprimir no console
	li  	$v0, 4
	add 	$a0, $a0, $zero
	syscall
	jr $ra

printnum: 			# funcao auxiliar para imprimir numeros no console
	li  	$v0, 1
	add 	$a0, $a0, $zero
	syscall
	jr $ra

encerra:
	li 	$v0, 10
	syscall

.data

VetorDados: .word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
TamVetorDados: .word 0
VetorPadrao: .word 0 0 0 0 0
TamVetorPadrao: .word 0

F1: .asciiz "\n ========================================== \n\n\nVetor de dados \n"
F2: .asciiz "\nVetor de padrao \n"
F3: .asciiz "Informe o numero de dados a serem inseridos no vetor: "
F4: .asciiz "Informe um dado a ser inserido no vetor: "
F5: .asciiz "\nQuantidade de padroes encontrados: "

DEBUG: .asciiz "\n ====> DEBUG <===== \n"
