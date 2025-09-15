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