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
1. Estructuras principales 

MateriaPrima

Contiene UID como identificador único.

Almacena nombre, cantidad, unidad y proveedor.

No tiene drop, lo cual es correcto porque UID no permite la habilidad drop.

Inventario

Tiene UID y un VecMap<u64, MateriaPrima>.

Esto permite buscar, insertar y eliminar materias por un id_materia.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
2. Funciones
a) crear_inventario
pub fun crear_inventario(ctx: &mut TxContext): Inventario


Inicializa un inventario vacío.

Uso correcto de vec_map::empty() y object::new(ctx).

b) agregar_materia
pub fun agregar_materia(
    inventario: &mut Inventario,
    id_materia: u64,
    nombre: String,
    cantidad: u64,
    unidad: String,
    proveedor: String,
    ctx: &mut TxContext
)


Verifica que id_materia no exista: assert!(!inventario.materias.contains(&id_materia), ID_YA_EXISTE); ✅

Crea un objeto MateriaPrima nuevo y lo inserta correctamente.

Buen manejo de UID con object::new(ctx).

c) actualizar_cantidad
pub fun actualizar_cantidad(inventario: &mut Inventario, id_materia: u64, nueva_cantidad: u64)


Verifica que la materia sí exista antes de actualizar.

Usa get_mut para obtener una referencia mutable.

Muy directo y seguro.

d) eliminar_materia
pub fun eliminar_materia(inventario: &mut Inventario, id_materia: u64)


Verifica existencia.

El remove retorna (clave, valor); asignar valor a _consume es necesario para evitar el error de “unused value without drop” en Move.

Correcto.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
3. Buenas prácticas

Uso de constantes ID_YA_EXISTE y ID_NO_EXISTE para códigos de error: 👍

Uso de VecMap en lugar de vector simple permite búsquedas rápidas por id_materia.

Documentación mínima en el código es clara; agregar comentarios sobre errores y uso de UID es útil.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
4. Sugerencias

Posible mejora de errores: en lugar de solo códigos numéricos, podrías usar structs o enums para mensajes más claros:

const ERROR_ID_YA_EXISTE: &str = "La materia prima ya existe";


Funciones de consulta: podrías agregar funciones como:

public fun obtener_materia(inventario: &Inventario, id_materia: u64): &MateriaPrima


para obtener referencias sin mutar el inventario.

Evitar duplicación de IDs: si id_materia viene de otra fuente, podrías generar un hash de nombre+proveedor para asegurar unicidad automática.

Eventos: si planeas usar esto en un entorno con Sui Move, publicar eventos cuando se agregan o eliminan materias puede ayudar a la trazabilidad.
----------------------------------------------------------------------------------------------------------------------------------------------
CODIGO
#[allow(duplicate_alias)]
module 0xDEADBEEF::materias_primas {
    use sui::object;
    use sui::tx_context::TxContext;
    use sui::vec_map::{Self, VecMap};
    use std::string::String;

    // CÓDIGOS DE ERROR
    const ID_YA_EXISTE: u64 = 1;
    const ID_NO_EXISTE: u64 = 2;

    // ESTRUCTURAS PRINCIPALES
    // -------------------------------------------------
    // Estructura que representa una materia prima
    public struct MateriaPrima has key, store {
        id: UID,
        nombre: String,
        cantidad: u64,
        unidad: String,
        proveedor: String,
    }

    // Estructura que representa un inventario de materias primas
    public struct Inventario has key, store {
        id: UID,
        materias: VecMap<u64, MateriaPrima>,
    }

    // FUNCIONES PRINCIPALES
    // -------------------------------------------------
    // CREA UN NUEVO INVENTARIO VACÍO
    #[allow(lint(self_transfer))]
    public fun crear_inventario(ctx: &mut TxContext): Inventario {
        Inventario {
            id: object::new(ctx),
            materias: vec_map::empty(),
        }
    }

    // AGREGA UNA NUEVA MATERIA PRIMA AL INVENTARIO
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

    // ACTUALIZA LA CANTIDAD DE UNA MATERIA PRIMA EXISTENTE
    public fun actualizar_cantidad(inventario: &mut Inventario, id_materia: u64, nueva_cantidad: u64) {
        assert!(inventario.materias.contains(&id_materia), ID_NO_EXISTE);
        let materia = inventario.materias.get_mut(&id_materia);
        materia.cantidad = nueva_cantidad;
    }

    // ELIMINA UNA MATERIA PRIMA DEL INVENTARIO
    public fun eliminar_materia(inventario: &mut Inventario, id_materia: u64) {
        assert!(inventario.materias.contains(&id_materia), ID_NO_EXISTE);
        let (_clave, valor) = inventario.materias.remove(&id_materia);
        // CONSUMIMOS 'valor' PARA EVITAR ERROR DE "UNUSED VALUE WITHOUT DROP"
        let _consume = valor;
    }
}

