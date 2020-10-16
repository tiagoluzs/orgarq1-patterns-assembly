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

contabilizaLoop:
	la $t1, posicaoDados
	lw $t1, 0($t1) # posicao dados atual

	la $t4, TamVetorDados
	lw $t4, 0($t4)
	la $t5, TamVetorPadrao
	lw $t5, 0($t5)

	li $a0, 2
	jal printnum

	addu $t3, $t1, $t5 	# $t3 = posicaoDados + tamanhoVetorPadrao

	bgt $t3, $t4, contabilizaLoopFinalizado # sai do loop


	# logica da contabilização dos padrões

	la $t6, VetorDados	# endereço do VetorDados
	la $t7, VetorPadrao	# endereço do VetorPadrão

	addi $sp, $sp, -24	# cria 6 entradas na pilha
	sw $t1, 0($sp)
	sw $t6, 4 ($sp)		# define endereco do vetor de dados
	sw $t1, 8 ($sp)		# define posicaoDados
	sw $t7, 12 ($sp)		# define endereco do vetor de padrao
	sw $zero, 16 ($sp)	# define como zero a posição inicial da chamada
	sw $t5, 20 ($sp)	# define o tamanho do vetor padrao
	jal encontraPadrao	# chamada para encontraPadrao

	# fim da logica da contabilização dos padrões


	addi $sp, $sp, 8
	lw $t1, 0($sp) #recupera retorno de posicaoDados anterior
	lw $t2, 4($sp) #recupera retorno de encontraPadrao

	la $t3, contabilizaPadrao # enredeço de contabilizaPadrao
	lw $t4, 0($t3) # valor de contabilizaPadrao

	add $t4 , $t4, $t2 # soma

	sw  $t4, 0($t3) # salva na memória o valor de contabilizaPadrao

	addiu $t1, $t1, 1	# incrementa contador $t1 posicaoDados

	la $t2, posicaoDados 	# endereco de memoria de posicaoDados
	sw $t1, ($t2)		# salva valor de posicaoDados

	j contabilizaLoop


encontraPadrao:
	lw $t3, 0 ($sp)   # endereco do vetor de dados
	lw $t4, 4 ($sp)   # posicaoDados
	lw $t5, 8 ($sp)   # endereco do vetor de padrao
	lw $t6, 12 ($sp)   # posição da chamada
	lw $t7, 16 ($sp)   # tamanho do vetor padrao
	addi $sp, $sp, 20  # reposiciona $sp

	addi $sp, $sp, -4	# cria uma entrada na pilha
	sw $ra, 0 ($sp)		# salva na pilha endereço de retorno do ra

	# busca valor do vetorDados na posicao posDados
	li $t1, 4
	mul $t9, $t1, $t4 	# $t2 <- i*4
	addu $t9, $t9 , $t3
	lw $t9,0($t9) # valor do vetor na posicao posicaoDados

	# busca valor do verPadrao na posicao posPadrao
	mul $t8, $t1, $t6 	# $t2 <- i*4
	addu  $t8, $t8 , $t5
	lw $t8,0($t8) # valor do vetor na posicao da chamada

	bne $t9, $t8, retornaZero
	addiu $t1, $t7, -1
	beq $t6, $t1, retornaUm

	addi $sp, $sp, -20	# cria 5 entradas na pilha
	sw $t3, 0 ($sp)		# define endereco do vetor de dados
	addiu  $t4, $t4, 1
	sw $t4, 4 ($sp)		# define posicaoDados
	sw $t5, 8 ($sp)		# define endereco do vetor de padrao
	addiu $t6, $t6, 1
	sw $t6, 12 ($sp)	# define como zero a posição inicial da chamada
	sw $t7, 16 ($sp)	# define o tamanho do vetor padrao
	jal encontraPadrao	# chamada para encontraPadrao
	lw $t1, 0 ($sp)		# carrega último $ra da pilha
	addi $sp, $sp, 4
	jr $t1			# retorna

retornaZero:
	lw $t1, 0 ($sp)		# carrega último $ra da pilha
#	addi $sp, $sp, 4 	# reposiciona $sp
#	addi $sp, $sp, -4 	# reposiciona $sp
	li $t2, 0		# cria um valor zero em $t2
	sw $t2, 0($sp)		# adiciona valor zero à pilha
	jr $t1			# retorna

retornaUm:
	lw $t1, 0 ($sp)		# carrega último $ra da pilha
#	addi $sp, $sp, 4 	# reposiciona $sp
#	addi $sp, $sp, -4 	# reposiciona $sp
	li $t2, 1		# cria um valor um em $t2
	sw $t2, 0($sp)		# adiciona valor zero à pilha
	jr $t1			# retorna

contabilizaLoopFinalizado:

	la  $a0, F5
	jal print

	la $a0 , 0($t0)
	jal printnum

	j encerra



carregavetor:

	lw $t4, 0 ($sp)   # le endereco inicial do vetor
#	addi $sp, $sp, 4  # reposiciona $sp
#	addi $sp, $sp, -4	# cria uma entrada na pilha
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
#	addi $sp, $sp, 4	# reposiciona $sp
#	addi $sp, $sp, -4	# cria uma posicao na pilha
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

nl:
	li  	$v0, 4
	la	$a0, NL
	syscall
	jr $ra

bar:
	li $v0, 4
	la $a0, NL
	syscall
	la $a0, BREAK
	syscall
	la $a0, NL
	syscall
	jr $ra

encerra:
	li 	$v0, 10
	syscall

.data
VetorPadrao: .space 20		# vetor com 5 posicoes de 4 bytes => 5 * 4 bytes = 20
TamVetorPadrao: .word 0
VetorDados: .space 200		# vetor com 50 posicoes de 4 bytes => 50 * 4 bytes = 200
TamVetorDados: .word 0
posicaoDados: .word 0		# variavel de controle
contabilizaPadrao: .word 0	# contador de padroes localizados
BREAK: .asciiz "======"
NL: .asciiz "\n"
F1: .asciiz "\n ========================================== \n\n\nVetor de dados \n"
F2: .asciiz "\nVetor de padrao \n"
F3: .asciiz "Informe o numero de dados a serem inseridos no vetor: "
F4: .asciiz "Informe um dado a ser inserido no vetor: "
F5: .asciiz "\nQuantidade de padroes encontrados: "

DEBUG: .asciiz "\n ====> DEBUG <===== \n"
