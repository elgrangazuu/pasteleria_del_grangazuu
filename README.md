📦 Descripción del Programa: Sistema de Inventario de Materias Primas para Pastelería 🧁🥐

Este programa, desarrollado en Move para la blockchain Sui ⛓️, implementa un sistema de gestión de inventario de materias primas para una pastelería. Su objetivo es permitir el registro, actualización y control de los ingredientes esenciales 🍞🧈🍫 utilizados en la producción de productos de panadería y repostería.

Funciones principales:

📝 Crear inventario: Genera un inventario vacío para almacenar todas las materias primas con un identificador único en la blockchain.

➕ Agregar materias primas: Registrar ingredientes nuevos indicando nombre, cantidad, unidad y proveedor. Ejemplos: Harina 🌾, Leche 🥛, Azúcar 🍬, Mantequilla 🧈, Huevos 🥚.

🔄 Actualizar cantidades: Modificar la cantidad disponible al recibir más stock o al consumir materias primas.

❌ Eliminar materias primas: Quitar ingredientes que se terminaron o que ya no se utilizan.

Tecnologías utilizadas:

💻 Move: Lenguaje de contratos inteligentes seguro.

⛓️ Sui Blockchain: Guarda inventarios como objetos digitales con integridad y trazabilidad.

🗂️ VecMap: Estructura para almacenar y buscar materias primas por su ID.

Ventajas del sistema:

🔒 Registro seguro y confiable de materias primas.

📈 Escalable, con posibilidad de agregar alertas de stock bajo o reportes de consumo.

🧐 Trazabilidad de ingredientes y proveedores gracias a la blockchain.

Ejemplo de uso:
1️⃣ Crear un inventario de materias primas.
2️⃣ Agregar Harina (1000g) 🌾, Leche (500ml) 🥛 y Azúcar (300g) 🍬.
3️⃣ Actualizar cantidad de Harina a 1500g 🔄.
4️⃣ Eliminar Leche cuando se termine ❌.

Este programa proporciona una base sólida para digitalizar la gestión de ingredientes 🏪, combinando las ventajas de la blockchain ⛓️ con la seguridad del lenguaje Move 💻.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------CODIGO-----------------------------------------------------------------------------------------------------------------------------------------------------------------
#[allow(duplicate_alias)]
module 0xDEADBEEF::materias_primas {
    use sui::object;
    use sui::tx_context::TxContext;
    use sui::vec_map::{Self, VecMap};
    use std::string::String;

    const ID_YA_EXISTE: u64 = 1;
    const ID_NO_EXISTE: u64 = 2;

    // Estructuras sin 'drop' ya que UID no tiene esa habilidad
    public struct MateriaPrima has key, store {
        id: UID,
        nombre: String,
        cantidad: u64,
        unidad: String,
        proveedor: String,
    }

    public struct Inventario has key, store {
        id: UID,
        materias: VecMap<u64, MateriaPrima>,
    }

    #[allow(lint(self_transfer))]
    public fun crear_inventario(ctx: &mut TxContext): Inventario {
        Inventario {
            id: object::new(ctx),
            materias: vec_map::empty(),
        }
    }

    public fun agregar_materia(
        inventario: &mut Inventario,
        id_materia: u64,
        nombre: String,
        cantidad: u64,
        unidad: String,
        proveedor: String,
        ctx: &mut TxContext
    ) {
        assert!(!inventario.materias.contains(&id_materia), ID_YA_EXISTE);
        let materia = MateriaPrima {
            id: object::new(ctx),
            nombre,
            cantidad,
            unidad,
            proveedor,
        };
        inventario.materias.insert(id_materia, materia);
    }

    public fun actualizar_cantidad(inventario: &mut Inventario, id_materia: u64, nueva_cantidad: u64) {
        assert!(inventario.materias.contains(&id_materia), ID_NO_EXISTE);
        let materia = inventario.materias.get_mut(&id_materia);
        materia.cantidad = nueva_cantidad;
    }

    // Aquí consumimos explícitamente el valor retornado para evitar el error 'unused value without drop'
    public fun eliminar_materia(inventario: &mut Inventario, id_materia: u64) {
		assert!(inventario.materias.contains(&id_materia), ID_NO_EXISTE);
		let (_, materia) = inventario.materias.remove(&id_materia);
		let MateriaPrima { id, .. } = materia;
		id.delete();
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

