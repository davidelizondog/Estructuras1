#IE0321 - TAREA 3
#DAVID ELIZONDO GARRO
#B32359
#GRUPO 2

#Este programa implementa el algoritmo secuencial para multiplicación visto en clase, para multiplicar dos números enteros

#Uso de los registros temporales:
#	$t0: contador (<32)
#	$t1: multiplicando (parte baja)
#	$t2: multiplicando (parte alta)
#	$t3: multiplicador
#	$t4: auxiliar para hacer máscara
#	$t5: máscara: 0x00000001
#	$t6: máscara: 0x80000000
#	$t7: auxiliar para saltos
#	$t8: parte baja del producto
#	$t9: parte alta del producto


.data
	#mensajes para ingresar los operandos
	inmpnd: .asciiz "Ingrese el multiplicando:\n"
	inmpdr: .asciiz "Ingrese el multiplicador:\n"
	#mensaje para mostrar resultado
	result: .asciiz "El resultado de la multiplicación es:\n"

.text
main:
	li $t8,0				#32 bits bajos del producto
	li $t9,0				#32 bits altos del producto
	li $t2,0 				#el registro $t2 será la parte superior del multiplicando
	li $t0,0				#contador
	li $t7,0
	li $t5,1
	li $t6,0x80000000
	
	ingr1:	la $a0, inmpnd		#pide ingresar multiplicando 
			li $v0, 4			
			syscall
	leer1:	li $v0, 5			#leer valor ingresado
			syscall
			move $t1,$v0 		#el registro $t1 será el dato del multiplicando (parte inferior)
	
	ingr2:	la $a0, inmpdr		#pide ingresar multiplicador
			li $v0, 4
			syscall
	leer2:	li $v0, 5			#leer valor ingresado
			syscall
			move $t3,$v0		#el registro $t3 será el dato del multiplicador
			
	loop:	and $t4,$t3,$t5		#mascara: si ult. digito de mpdr es 1, se procede a suma
			li $t7,1
			bne $t4,$t7,shiftl	#si no se cumple dicha condicion, saltamos a las rotaciones
	
	sumpr:	add $t8,$t8,$t1		#sumpr: prod = prod + multiplicando
			add $t9,$t9,$t2		#sumpr: se suman los otros 32b de prod y mpnd
	
	shiftl:	sll $t2,$t2,1		#rotar parte alta de mpnd a la izq
	
			#quiero ver si el msb de la parte baja de mpnd es 1, para sumarlo la parte alta y tener el efecto de rotar. Luego roto la parte baja de mpnd
			and $t4,$t1,$t6		#se aplica máscara
			bne $t4,$t6,et		#si no se cumple la condicion, salto a et
			addi $t2,$t2,1
		et:	sll $t1,$t1,1		#rotar parte baja de mpnd a la izq
	
	shiftr:	srl $t3,$t3,1		#rotar multiplicador a la der
	addi $t0,$t0,1				#incrementar contador
	sltiu $t7,$t0,32			#si contador <32, repetir ciclo
	bne $t7,$zero,loop
	
	la $a0, result		#imprime mensaje para dar el resultado
	li $v0, 4			
	syscall
	
	move $a0,$t9		#imprime parte alta del producto
	li $v0, 1
	syscall
	move $a0,$t8		#imprime parte baja del producto
	li $v0, 1
	syscall
	
	exit:	li $v0,10
			syscall