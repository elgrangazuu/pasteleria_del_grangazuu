# Mascotas
## Funciones
### Publicar
´´´sh
sui client call --package 0x9d754460b44c7b67705612d523716ccff54f1d1a7246e9ef93b54d724a665579 --module practica_sui --function crear_veterinaria --args "Mascotas Exoticas de gazuu"
### Crear veterinaria
´´´sh
sui client call --package 0x9d754460b44c7b67705612d523716ccff54f1d1a7246e9ef93b54d724a665579 --module practica_sui --function crear_veterinaria --args "Mascotas Exoticas de gazuu"
´´´
### Agregar mascota
´´´sh
$ sui client call --package 0x9d754460b44c7b67705612d523716ccff54f1d1a7246e9ef93b54d724a665579 --module practica_sui --function agregar_mascota --args 0x888fbe014667435e3b165ce93f7ba197dae272f497ba2171255526815b89c3ac "Taquito" 7 "Chihuhua" "https://mx.pinterest.com/pin/4081455892278020/"
´´´
### Eliminar ultima mascota
´´´´sh
$ sui client call --package 0x9d754460b44c7b67705612d523716ccff54f1d1a7246e9ef93b54d724a665579 --module practica_sui --function eliminar_ultima_mascota --args 0x888fbe014667435e3b165ce93f7ba197dae272f497ba2171255526815b89c3ac
´´´ 
### Eliminar mascota
´´´ sh
$ sui client call --package 0x9d754460b44c7b67705612d523716ccff54f1d1a7246e9ef93b54d724a665579 --module practica_sui --function eliminar_ultima_mascota_id  --args 0x888fbe014667435e3b165ce93f7ba197dae272f497ba2171255526815b89c3ac 2
´´´´
### Editar Estado
´´´´sh
$ sui client call --package 0x9d754460b44c7b67705612d523716ccff54f1d1a7246e9ef93b54d724a665579 --module practica_sui --function editar_estado  --args 0x888fbe014667435e3b165ce93f7ba197dae272f497ba2171255526815b89c3ac 4 "Dado de alta"
´´´
### Crear Veterinaria
´´´sh
$ sui client call --package 0x9d754460b44c7b67705612d523716ccff54f1d1a7246e9ef93b54d724a665579 --module practica_sui --function crear_veterinaria --args "Mascotas Exoticas de gazuu"
´´´

