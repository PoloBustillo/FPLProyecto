# Fase 3: Base de Conocimiento y Resolucion SLD en Prolog

## Objetivo

Implementar una base de conocimiento en Prolog (clausulas de Horn) para:

- Diagnosticar fallos de acceso en infraestructura TI.
- Responder consultas complejas con resolucion SLD.
- Optimizar la busqueda con corte (`!`).
- Entregar causas probables o confirmacion de cumplimiento.

## Archivo de implementacion

- `src/auditoria_ti.pl`
- `src/main.pl` (punto de ejecucion de ejemplo)

## 1) Base de conocimiento (Horn clauses)

La base contiene:

- **Hechos**: usuarios, grupos, servidores, ambientes, zonas, servicios, estados de seguridad.
- **Reglas**: permisos por rol/ambiente, controles de acceso y diagnostico.

Predicados principales:

- `acceso_permitido(Usuario, Servidor, Puerto)`
- `diagnostico_fallo(Usuario, Servidor, Puerto, Causas)`
- `diagnostico_rapido(Usuario, Servidor, Puerto, CausaPrincipal)`
- `evaluar_acceso(Usuario, Servidor, Puerto, Resultado)`

## 2) Resolucion SLD (consulta compleja)

Consulta ejemplo del enunciado:

`?- evaluar_acceso(admin, s1, 443, R).`

Resultado esperado con la configuracion actual:

- `R = resultado(no_cumple_politicas, [cuenta_bloqueada, puerto_bloqueado_en_firewall]).`

Interpretacion:

- El motor de inferencia prueba los objetivos contra reglas y hechos.
- Al no poder demostrar `acceso_permitido/3`, deriva causas via `diagnostico_fallo/4`.

## 3) Control de eficiencia con corte (`!`)

Se implementa en `primera_falla_critica/4` para detener la busqueda al detectar la primera falla de alta prioridad:

1. `cuenta_bloqueada`
2. `puerto_bloqueado_en_firewall`
3. `credenciales_incompletas_en_prod`
4. `permiso_insuficiente`

Esto evita recorridos innecesarios en el arbol de resolucion cuando ya existe una causa critica suficiente para accion operativa inmediata.

## 4) Resultados del sistema

El sistema puede retornar:

- **Cumplimiento**:  
  `resultado(cumple_politicas, acceso_autorizado)`

- **No cumplimiento con causas**:  
  `resultado(no_cumple_politicas, ListaDeCausas)`

## 5) Ejecucion

Desde la raiz del proyecto:

`swipl -q -f "mi-proyecto-prolog/src/main.pl"`

Salida actual de ejemplo:

- Consulta: `admin` sobre `s1:443`
- Resultado: `resultado(no_cumple_politicas,[cuenta_bloqueada,puerto_bloqueado_en_firewall])`
- Primera falla critica: `cuenta_bloqueada`

## 6) Ver el trace (unificacion y backtracking)

### Opcion A: interactiva (paso a paso)

1. `swipl`
2. `?- [ 'mi-proyecto-prolog/src/auditoria_ti.pl' ].`
3. `?- trace_evaluar(admin, s1, 443, R).`

En pantalla veras puertos del depurador:

- `Call` (llamada de objetivo)
- `Unify` (unificacion de terminos)
- `Exit` (objetivo satisfecho)
- `Redo` (backtracking para buscar alternativas)
- `Fail` (falla de una rama)

### Opcion B: trace sin pausa (salida continua)

`swipl -q -g "consult('mi-proyecto-prolog/src/auditoria_ti.pl'), trace_evaluar_sin_pausa(admin,s1,443,R), writeln(R), halt."`

Esta modalidad imprime la traza completa sin pedir confirmacion en cada paso.
