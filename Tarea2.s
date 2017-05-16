.text
.globl main
main:	
		la $t0,Data		#direccion del arreglo
		li $t1,0		#direccion variable 4++
		li $t2,0		#contador j
		li $t3,25		#longitud del arreglo
		li $t4,0
		li $t5,0
		li $t6,0		#indice para evaluar swap
		la $t7,cont		#si tuve que hacer swap, me hago 1
		li $t8,0
		
		jal impr
		move $t1,$t0		
		j loop
		
	loop:	lw $t4,0($t1)	#$t4 = Data[i]
			lw $t5,4($t1)	#$t5 = Data[i+1]
			slt $t6,$t4,$t5	#COMPARACION
			#si t6=1 no hago swap; si t6=0 hago swap
			beq $t6,$zero,swap
			j incr
			
	incr:	addi $t1,$t1,4	#incremento t1, para evaluar siguientes dos elementos
			addi $t2,$t2,1	#incremento t2 para ver si ya cubri todos los elementos
			beq $t2,$t3,repet	#si t2=25, termine la pasada, voy a repet para ver si requiero otra
			j loop
			
	swap:	sw $t5,0($t1)	#hago el swap
			sw $t4,4($t1)	#hago el swap
			beq $t8,$zero,subt8	#t8=1 si hice swap al menos una vez
			j incr
			subt8:	addi $t8,$t8,1
					addi $ra,$ra,4
					jr $ra
		
	repet:	#tengo o no tengo que repetir?
			bne $t8,$zero,otra
			jal impr
			j exit
			otra:	move $t1,$t0
					j loop
			
	impr:	
			inic:	li $t9,0
					move $t9,$t0
					li $v0,4
					add $a0,$zero,$t0
					syscall
			beq $t9,$t3,salt
			
			salt: jr $ra
			
	exit:	li $v0,10
			syscall







.data
	Data:
		.word 87, 216, -54, 751, 1, 36, 1225, -446, -6695, -8741, 101, 9635, -9896, 4, 2008, -99, -6, 1, 544, 6, 0, 7899, 74, -42, -9
	cont:
		.word 1
	longitud:
		.word 25