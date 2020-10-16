.text
.globl main
main:
  	# vetor de dados
	la  $a0, F1
	jal print
	la $t0, VetorDados	# endereço da posicao inicial do vetor de dados
	addiu $sp, $sp, -4	# cria uma entrada na pilha
	sw $t0, 0 ($sp)		# endereço da posicao inicial do vetor de dados na pilha
	jal carregavetor	# chama funcao para carrega vetor

	lw $t0, 0 ($sp)       # le tamanho do vetor informado
	addiu $sp, $sp, 4      # reposiciona $sp
	la $t1, TamVetorDados # endereço do TamVetorDados
	sw $t0, 0($t1)          # salva na memória
	
	# vetor de padrao
	la  $a0, F2 		
	jal print
	la $t0, VetorPadrao	# endereço da posicao inicial do vetor de dados
	addiu $sp, $sp, -4	# cria uma entrada na pilha
	sw $t0, 0 ($sp)		# endereço da posicao inicial do vetor de dados na pilha
	jal carregavetor	# chama funcao para carrega vetor
	lw $t0, 0 ($sp)       # le tamanho do vetor informado
	addiu $sp, $sp, 4      # reposiciona $sp
	la $t1, TamVetorPadrao # endereço do TamVetorDados
	sw $t0, 0($t1)          # salva na memória

contabilizaLoop:
	la $t1, posicaoDados
	lw $t1, 0($t1)
	la $t2, TamVetorDados
	lw $t2, 0($t2)
	la $t3, TamVetorPadrao
	lw $t3, 0($t3)
	add $t4, $t1, $t3 
	bgt $t4, $t2 ,  contabilizaLoopFinalizado # condicao de parada do loop
	# contabilizaPadrao = contabvilizaPAdrao + Retorno o encontraPadrao
	addiu $sp, $sp, -20 	# cria cinco itens na pilha
	la $t4, VetorDados	# ref do VetorDados
	sw $t4, 0($sp) 		# ref do VetorDados
	sw $t1, 4($sp)		# posicaoDados 
	la $t4, VetorPadrao	# ref do VetorPadrao
	sw $t4, 8($sp) 		# ref do VetorDados
	sw $zero, 12($sp) 	# posicao Padrão zero 
	sw $t3, 16($sp) 	# TamVetorPadrao
	jal encontraPadrao
	# pega retorno de encontraPadrao na pilha
	lw $t1, 0 ($sp)		# carrega último item da pilha
	addiu $sp, $sp, 4 	# reposiciona $sp
	# soma com contabilizaPadrao atual
	la $t2, contabilizaPadrao # endereço 
	lw $t3, 0($t2) # valor de contabilizaPadrao
	add $t3, $t3, $t1 
	sw $t3, ($t2)	# atualiza valor de contabilizaPadrão 
	# incrementa posicção dados
	la $t3, posicaoDados
	lw $t4, 0($t3) #valor de posicao dados 
	addiu $t4, $t4, 1
	sw  $t4, ($t3)	
	j contabilizaLoop
encontraPadrao: 
	lw $t1, 0($sp) 	 	# ref do VetorDados
	lw $t2, 4($sp) 		# posicaoDados 
	lw $t3, 8($sp) 		# ref do VetorPadrao
	lw $t4, 12($sp) 	# posicao Padrão zero 
	lw $t5, 16($sp)		# TamVetorPadrao
	addiu $sp, $sp, 20 	# reposiciona $sp
	addiu $sp, $sp, -4 	# cria um item na pilha
	sw $ra, 0($sp) 		# inclui o endeeço de retorno
	# calcula _vetDados[_posDados]
	li $t7, 4
	mul $t6, $t2, $t7
	add $s0, $t1, $t6 
	lw $s0, 0($s0)	
	# calcula _vetPadrao[_posPadrao]
	li $t7, 4
	mul $t6, $t4, $t7
	add $s1, $t3, $t6 
	lw $s1, 0($s1)	
	bne $s0, $s1, retornaZero 
	addiu $s2, $t5, -1	# calcula _tamPadrao - 1
	beq $t4, $s2, retornaUm
	addiu $sp, $sp, -20 	# cria cinco itens na pilha
	sw $t1, 0($sp) 		# ref do VetorDados
	addiu $t2, $t2, 1
	sw $t2, 4($sp)		# posicaoDados + 1
	sw $t3, 8($sp) 		# ref do VetorDados
	addiu $s5, $t4, 1
	sw $s5, 12($sp) 	# posicao Padrão $t4 + 1
	sw $t5, 16($sp) 	# TamVetorPadrao
	jal encontraPadrao
	lw $ra, 4 ($sp)	
	lw $t1, 0 ($sp)
	addiu $sp, $sp, 8
	addiu $sp, $sp -4 
	sw $t1, 0($sp)
	jr $ra
	
retornaZero: 
	lw $ra, 0 ($sp)		# carrega último $ra da pilha
	sw $zero, 0($sp)	# adiciona valor zero à pilha 
	jr $ra			# retorna
	
retornaUm: 
	lw $ra, 0 ($sp)		# carrega último $ra da pilha
	li $t2, 1		# cria um valor um em $t2
	sw $t2, 0($sp)		# adiciona valor zero à pilha 
	jr $ra			# retorna

contabilizaLoopFinalizado:
	la  $a0, F5
	jal print
	la $t2, contabilizaPadrao 
	lw $t3, 0($t2) # valor de contabilizaPadrao
	la $a0 , 0($t3)
	jal printnum
	j encerra

carregavetor:
	lw $t4, 0 ($sp)   # le endereco inicial do vetor
	addiu $sp, $sp, 4  # reposiciona $sp
	addiu $sp, $sp, -4	# cria uma entrada na pilha
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
	lw $ra, 0 ($sp)		# lê o endereço de retorno da pilha
	addiu $sp, $sp, 4	# reposiciona $sp
	addiu $sp, $sp, -4	# cria uma posicao na pilha
	sw $t2, 0($sp)  	# adiciona à pilha o tamanho do vetor
	jr $ra 		# retorna para a chamada original

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
F1: .asciiz "\nVetor de dados \n"
F2: .asciiz "\nVetor de padrao \n"
F3: .asciiz "Informe o numero de dados a serem inseridos no vetor: "
F4: .asciiz "Informe um dado a ser inserido no vetor: "
F5: .asciiz "\nQuantidade de padroes encontrados: "
