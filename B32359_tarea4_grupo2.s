#DAVID ELIZONDO GARRO
#B32359
#GRUPO 2

#Este programa implementa el algoritmo secuencial para división visto en clase, para dividir dos números enteros

#Uso de los registros temporales:
#	$t0: contador (<33)
#	$t1: dividendo/residuo (parte baja)
#	$t2: dividendo/residuo (parte alta)
#	$t3: parte baja del divisor   
#	$t4: parte alta del divisor
#	$t5: cociente
#	$t6: 
#	$t7:
#	$t8: 
#	$t9: 


.data
	#mensajes para ingresar los operandos
	inmpnd: .asciiz "Ingrese el dividendo:\n"
	inmpdr: .asciiz "Ingrese el divisor:\n"
	#mensaje para mostrar resultado
	result: .asciiz "El resultado de la división es:\n"
	cociente: .asciiz "Cociente:\n"
	residuo: .asciiz "\n Residuo:\n"
	salto:	.asciiz "\n"

.text
main:
	li $t0,0				#contador
	li $t2,0 				#parte superior del dividendo/residuo
	li $t3,0				#parte inferior del divisor
	li $t5,0				#cociente
	li $t7,0x00000001
	li $t8,0x80000000
	li $t9,0xffffffff
	
#se van a utilizar registros $s, para lo cual se van a guardar primero en stack
	addi $sp,$sp,-16	#hacer campo para 4 registros
	sw $s0,12($sp)
	sw $s1,8($sp)
	sw $s2,4($sp)
	sw $s3, 0($sp)
	
	li $s0,0
	li $s1,0
	li $s2,0
	li $s3,0
	
	ingr1:	la $a0, inmpnd		#pide ingresar dividendo 
			li $v0, 4			
			syscall
	leer1:	li $v0, 5			#leer valor ingresado
			syscall
			move $t1,$v0 		#parte inf de dividendo se guarda en t1
	
	ingr2:	la $a0, inmpdr		#pide ingresar divisor
			li $v0, 4
			syscall
	leer2:	li $v0, 5			#leer valor ingresado
			syscall
			move $t4,$v0		#parte sup del divisor se guarda en $t4
			
	loop:	
	
	resta:	
			li $s0,0			#inicializar acarreo
			nor $s1,$t3,$zero	#compl. a 1 de divisor (parte baja) se guarda en $s1
			bne $s1,$t9,L		#evaluar si habrá acarreo entre parte baja y parte alta: solo si $s1 = 0xffffffff
			addi $s0,$s0,1		#se cumplió condición -> acarreo=1
			
		L:	addi $s1,$s1,1		#compl. a 2 de divisor (parte baja) se guarda en $s1
			nor $s2,$t4,$zero	#compl. a 2 de divisor (parte alta) se guarda en $s2
			add $s2,$s2,$s0		#como s2 es parte del mismo numero que s1, no sumo 1 siempre, sino que sumo el acarreo que se generó anteriormente
		
			add $t1,$t1,$s1		#efectúo la resta (parte baja)
			add $t2,$t2,$s2		#efectúo la resta (parte alta)
			
			and $s3,$t2,$t8		#evaluar si residuo < 0
			bne $s3,$t8,rc		#si residuo > 0 saltar a rc: rotar cociente con LSB=1
			
			add $t1,$t1,$t3		#res = res + div
			add $t2,$t2,$t4		#res = res + div
			
			sll $t5,$t5,1		#rotar cociente
			j rd				#saltar a rd: rotar divisor
			
		rc:	sll $t5,$t5,1		#rotar cociente
			or $t5,$t5,$t7		#poner LSB de cociente en 1
			
		rd:	and $s2,$t4,$t7		#mascara para ver si LSB de parte alta de divisor es 1
			srl $t4,$t4,1		#rotar a der. parte alta
			srl $t3,$t3,1		#rotar a der. parte baja
			bne $s2,$t7,incr	#si LSB de parte alta de divisor es 1,se debe poner en MSB de parte baja
			or $t3,$t3,$t8		#poner MSB de parte baja en 1
			
	incr:	addi $t0,$t0,1		#incrementar contador
			sltiu $t6,$t0,33	#revisar numero de repeticiones
			bne $t6,$zero,loop	#si cont < 33, repetir
			
	impres:	la $a0,result		#mostrar mensaje de resultado
			li $v0,4
			syscall
			la $a0,cociente
			syscall
			move $a0,$t5		#mostrar resultado (cociente)
			li $v0,1
			syscall
			la $a0,residuo
			li $v0,4
			syscall
			move $a0,$t2		#mostrar resultado (residuo, parte alta)
			li $v0,1
			syscall
			move $a0,$t1		#mostrar resultado (residuo, parte baja)
			syscall

	#restaurar stack	
	lw $s3,0($sp)
	lw $s2,4($sp)
	lw $s1,8($sp)
	lw $s0,12($sp)
	addi $sp,$sp,16

	fin:	li $v0,10
			syscall
		