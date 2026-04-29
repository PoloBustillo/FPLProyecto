# Fase 2: Auditoria de Recursos y Usuarios (Logica de Predicados)

Este documento formaliza politicas de acceso para ambientes `dev`, `test`, `stage`, `prod` y zonas `datacenter`, `local`.

## Nota de formato

Si, **Markdown es suficiente**. Puedes escribir cuantificadores y simbolos matematicos directamente (`∀, ∃, ∧, ∨, ¬, →`) y, si quieres, tambien usar bloques LaTeX:

`$$ \forall x (Usuario(x) \rightarrow Activo(x)) $$`

---

## 1) Lenguaje de Primer Orden

### 1.1 Constantes

- Ambientes: `dev`, `test`, `stage`, `prod`
- Zonas: `datacenter`, `local`
- Usuarios: `ana`, `luis`, `maria`, `sofia`
- Grupos: `admins`, `devops`, `qa`, `invitados`, `soporte`
- Recursos: `dbClientes`, `apiPagos`, `repoCore`, `vaultSecrets`

### 1.2 Funciones

- `ambiente(r)`: ambiente del recurso `r`.
- `zona(r)`: zona del recurso `r`.
- `duenio(r)`: usuario propietario de `r`.

### 1.3 Predicados

- `Usuario(x)`, `Recurso(r)`, `Grupo(g)`
- `Pertenece(x,g)`
- `TienePermiso(x,r)`
- `Accede(x,r)`
- `MFA(x)` (usuario autenticado con MFA)
- `Activo(x)` (cuenta activa)
- `Bloqueado(x)`
- `Cifrado(r)` (recurso cifrado en reposo)
- `LogCentralizado(r)`
- `Alerta(x,r)`
- `PermitidoAmbiente(g,e)` (grupo `g` habilitado en ambiente `e`)
- `PermitidoZona(g,z)` (grupo `g` habilitado en zona `z`)

---

## 2) Politicas globales cuantificadas (minimo 15)

> Convencion: `x` usuario, `r` recurso, `g` grupo, `e` ambiente, `z` zona.

1. **P1 (invitados sin prod)**  
   `∀x∀r [(Pertenece(x,invitados) ∧ ambiente(r)=prod) → ¬TienePermiso(x,r)]`

2. **P2 (invitados solo local)**  
   `∀x∀r [(Pertenece(x,invitados) ∧ zona(r)=datacenter) → ¬TienePermiso(x,r)]`

3. **P3 (admin con MFA para prod)**  
   `∀x∀r [(Pertenece(x,admins) ∧ ambiente(r)=prod ∧ MFA(x) ∧ Activo(x)) → TienePermiso(x,r)]`

4. **P4 (acceso implica permiso)**  
   `∀x∀r [Accede(x,r) → TienePermiso(x,r)]`

5. **P5 (acceso implica MFA en stage/prod)**  
   `∀x∀r [((ambiente(r)=stage ∨ ambiente(r)=prod) ∧ Accede(x,r)) → MFA(x)]`

6. **P6 (bloqueado no accede)**  
   `∀x∀r [Bloqueado(x) → ¬Accede(x,r)]`

7. **P7 (sin cuenta activa no accede)**  
   `∀x∀r [¬Activo(x) → ¬Accede(x,r)]`

8. **P8 (qa solo test/stage)**  
   `∀x∀r [(Pertenece(x,qa) ∧ ambiente(r)=prod) → ¬TienePermiso(x,r)]`

9. **P9 (devops permitido en dev/test/stage)**  
   `∀x∀r [(Pertenece(x,devops) ∧ (ambiente(r)=dev ∨ ambiente(r)=test ∨ ambiente(r)=stage) ∧ Activo(x)) → TienePermiso(x,r)]`

10. **P10 (secrets solo datacenter)**  
    `∀x∀r [(r=vaultSecrets ∧ zona(r)=local) → ¬TienePermiso(x,r)]`

11. **P11 (todo acceso no autorizado genera alerta)**  
    `∀x∀r [(Accede(x,r) ∧ ¬TienePermiso(x,r)) → Alerta(x,r)]`

12. **P12 (todo recurso en prod debe estar cifrado)**  
    `∀r [(Recurso(r) ∧ ambiente(r)=prod) → Cifrado(r)]`

13. **P13 (todo recurso en prod registra logs centralizados)**  
    `∀r [(Recurso(r) ∧ ambiente(r)=prod) → LogCentralizado(r)]`

14. **P14 (debe existir responsable por recurso)**  
    `∀r [Recurso(r) → ∃x (Usuario(x) ∧ duenio(r)=x)]`

15. **P15 (consistencia de grupos permitidos por ambiente)**  
    `∀x∀g∀r [(Pertenece(x,g) ∧ TienePermiso(x,r)) → PermitidoAmbiente(g,ambiente(r))]`

16. **P16 (consistencia de grupos permitidos por zona)**  
    `∀x∀g∀r [(Pertenece(x,g) ∧ TienePermiso(x,r)) → PermitidoZona(g,zona(r))]`

17. **P17 (prod en local es inconsistente para recursos criticos)**  
    `∀r [((r=dbClientes ∨ r=apiPagos ∨ r=vaultSecrets) ∧ ambiente(r)=prod ∧ zona(r)=local) → ⊥]`

---

## 3) Ejemplo de procesamiento logico (resolucion de predicados)

### 3.1 Objetivo

Auditar si `luis` (invitado) puede acceder a `dbClientes`, asumiendo:

- `ambiente(dbClientes)=prod`
- `zona(dbClientes)=datacenter`
- `Pertenece(luis,invitados)`
- Hipotesis a refutar: `Accede(luis,dbClientes)`

### 3.2 Clausulas relevantes

De P1:

- `C1: ¬Pertenece(x,invitados) ∨ ambiente(r)≠prod ∨ ¬TienePermiso(x,r)`

De P4:

- `C2: ¬Accede(x,r) ∨ TienePermiso(x,r)`

Hechos:

- `C3: Pertenece(luis,invitados)`
- `C4: ambiente(dbClientes)=prod`
- `C5: Accede(luis,dbClientes)` (hipotesis)

### 3.3 Unificacion y resolucion

1. `C2` con `C5`, sustitucion `θ1={x/luis, r/dbClientes}`  
   Resultado: `C6: TienePermiso(luis,dbClientes)`
2. `C1` con `C3` y `C4`, sustitucion `θ2={x/luis, r/dbClientes}`  
   Resultado: `C7: ¬TienePermiso(luis,dbClientes)`
3. Resolver `C6` con `C7`  
   Resultado: `[]` (clausula vacia)

Conclusion: la hipotesis `Accede(luis,dbClientes)` produce contradiccion; por tanto, el acceso debe ser denegado por politica.

---

## 4) Skolemizacion (ejemplo formal)

Politica existencial:

`∀r [Recurso(r) → ∃x Responsable(x,r)]`

1. Eliminar implicacion:  
   `∀r [¬Recurso(r) ∨ ∃x Responsable(x,r)]`
2. Skolemizar `∃x` dependiente de `r`:  
   `∀r [¬Recurso(r) ∨ Responsable(f(r),r)]`

Aqui `f(r)` es una funcion de Skolem que asigna un responsable a cada recurso.

---

## 5) Tablas semanticas para contraejemplos

Regla objetivo:

`∀x [Pertenece(x,invitados) → ¬Accede(x,dbClientes)]`

Negacion para tableau:

`∃x [Pertenece(x,invitados) ∧ Accede(x,dbClientes)]`

Instancia testigo `k`:

- `Pertenece(k,invitados)`
- `Accede(k,dbClientes)`

Si no se puede derivar `¬Accede(k,dbClientes)`, queda rama abierta (contraejemplo).  
Si todas las ramas cierran, la politica se sostiene en el modelo.

---

## 6) Recomendacion de entrega

- Deja este archivo en `.md` para documentacion formal.
- Si tu profesor pide notacion mas tipografica, puedes generar una version PDF con LaTeX a partir del mismo contenido.
