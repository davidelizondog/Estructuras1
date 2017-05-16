.text
.align 2

main:
	li $t0, 0	#contador 
	li $t4, 0	#evaluador de error
	li $t5, 0	#número ingresado
	li $t9, 44	#límite
	
	ing:	la $a0, ingr	#pide ingresar int 
			li $v0, 4
			syscall
	
	scan:	li $v0, 5	#leer valor ingresado
			syscall
			move $t5,$v0
	
	eval: sltiu $t4,$t5,1	# $t4=1 si num ingresado <= 0
		  sgt $t4,$t5,$t9	# $t4=1 si num ingresado > 44
	      beq $t4,$0,L2		# si $t4=0 no hay error, pasar a L1
		  
	      la $a0, error		# si $t4=1 hay error, mostrar mensaje de error
	      li $v0, 4
	      syscall
	      j ing			# se mostró el msj de error y se pide ingresar número de nuevo
	
	#L1:	bne $t0,$0,L2		#si $t0 es 0 se debe imprimir "1" por defecto, si no, pasar a L2
	#	li $v0, 1
	#	li $a0, 1
	#	syscall
		
	#	addi $t2,$t2,1		#ahora b debe valer 1
	#	addi $t0,$t0,1		#se incrementa el contador
	#	j loop
		
	L1:	#add $t3,$t1,$t2	#c=a+b, proced. para generar sucesión 
		#li $t1, 0	#a
		#li $t2, 0	#b
		li $t3, 1	#c
	L2:	#li $v0, 4
		#la $a0, coma		#desplegar en pantalla la coma
		#syscall
		li $v0, 4
		li $a0, 0
		add $a0,$a0,$t3		#desplegar en pantalla al valor de c
		syscall
		
		li $t1,0
		add $t1,$0,$t2		#ahora a=b
		li $t2,0
		add $t2,$0,$t3		#y b=c
		li $t3,0
		add $t3,$t1,$t2		#c=a+b
		addi $t0,$t0,1		#y se incrementa el contador
		j loop
	loop:
		bne $t0,$t5,L2
		
	exit:
	.end main
		
.data
ingr: 
	.asciiz "Ingrese un número mayor a 0 y menor a 45\n"

error: 
	.asciiz "Error: número debe ser mayor a 0 y menor a 45\n"
	
coma: 
	.asciiz ", "
	
	