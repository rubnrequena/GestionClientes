GestionClientes
===============

Sistema de gestión de clientes

TODO
	Estadisticas
	Ingresos: Visualizar monto ingresado por registros de clientes en un rango de fecha
	Clases: Editar clase
	Grupos: Editar Grupo
	Finanzas: Reporte por categoria, MENSUALIDAD, SERVICIOS, PRODUCTOS, MISC
	Tarea: Clientes suspendidos por x dias de ausencia
	Clientes: asignar a multiples grupos
	Clientes,Tareas: no cobrar mensualidad el mismo dia que se inscribe
	Clientes: Foto del cliente
	
TODO BASE DATOS
- config
	inasistencias_alerta
	inasisencias_maximas
- clases
	auto_registro		boolean
- clientes
	exonerado			boolean
- grupos
	inscripcion				boolean

[29-10-14]
	Config: nuevo campo empleado_credito
	NuevoPago: Pago a credito
	Cliente: Crear tarea de cobro según fecha de inscripcion
	Cliente: Crear nuevo pago basado en la inscripción del grupo
	Cliente: Al guardar cliente se sugiere facturar.
	Cumpleaños: Ver ficha de cliente seleccionado
	Grupos: Nuevo campo inscripcion
	Tareas: Nueva tarea TPagoCliente
	Tareas: Nuevo tipo de tarea Diario
	Corrección de error al cambiar de estado
	
[22-10-14]
	Inicio: Listado rapido de morosos
	Config: Propiedad mostrar morosos en inicio
	Facturas: Validar rangos de fecha
	FichaCliente: Iconos añadidos a botones
	Cliente: Campo de observacion añadido
[10-10-14]
	Asistencias: Tarea que cree las clases para asistencia automaticamente
	Clientes: mostrar cedula del cliente en los pickerList, usar ItemRenderer
	Config: nuevos campos inasistencias_alerta,inasistencias_maximas
	Asistencias: Solicitar permiso del administrador si exede el maximo de inasistencias consecutivas
[09-10-14]
	Nuevo sistema de formularios y validación
	Clientes: Exoneración de pago
	Finanzas: Selección de productos registrados
	Finanzas: Activación del proceso de inventario
	Productos: Editar información del producto
	Productos: Agregar stock al producto
[04-10-14]
	Nueva Factura: Facturas grupales
	Nueva Factura: Remuneraciones
	Nuevo cliente: colocar iconos en los botones
	Buscar cliente: colocar iconos en los botones
	Cumpleaños: colocar iconos en los botones
	Facturas: colocar iconos en los botones
	Clases: remover clase (preguntar antes de eliminar)
	Grupos: validar campos antes de insertar	
	Instructores: validar campos antes de insertar
	Salones: validar campos antes de insertar
	Facturacion: validar campos antes de agregar articulo
	Tareas: actualizar lista de tareas al registrar nueva tarea
	Tareas: corregir los campos del datagrid
	Productos: validar campos antes de insertar
	Productos: Remover productos (preguntar antes de eliminar)
	Agregar sonido al registrar y rechazar asistencia 
	Nueva propiedad: Direccion del audio a sonar al registrar asistencia
	Nueva propiedad: Direccion del audio a sonar al rechazar asistencia
	Nueva propiedad: Sonar audio al registrar y rechazar audio
	Agregar facturar con copia
	Mostrar versión de aplicación en panel Acerca De
[03-10-14]
	Registrar inasistencia a clases 
	Grupos Remover campo instructor de grupos
	Clases: añadir campo descripcion