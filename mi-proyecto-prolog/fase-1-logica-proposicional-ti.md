# Lógica Proposicional para Seguridad Informática (20 reglas)

## 1) Proposiciones atómicas

- `p`: El servidor de base de datos está activo.
- `q`: El firewall permite tráfico HTTP (puerto 80/443).
- `r`: El puerto 22 (SSH) está abierto a Internet.
- `s`: Hay una VPN activa para acceso administrativo.
- `t`: Existe riesgo de seguridad.
- `u`: El DNS responde correctamente.
- `v`: La conectividad de red es estable.
- `w`: Se genera una alerta de incidente.
- `x`: El antivirus está actualizado.
- `y`: El sistema tiene parches críticos aplicados.
- `z`: Se detecta malware en un endpoint.
- `a`: La autenticación multifactor (MFA) está habilitada.
- `b`: Hay intentos de inicio de sesión fallidos repetidos.
- `c`: La cuenta se bloquea automáticamente.
- `d`: Los respaldos recientes son válidos.
- `e`: El almacenamiento de respaldos está cifrado.
- `f`: El tráfico interno está segmentado (VLAN/ACL).
- `g`: Hay tráfico lateral sospechoso.
- `h`: El IDS/IPS está activo.
- `i`: Se detecta escaneo de puertos.
- `j`: Los logs de auditoría están centralizados.
- `k`: Se detecta acceso no autorizado.
- `l`: El certificado TLS es válido.
- `m`: La aplicación expone datos sensibles.
- `n`: Existe fuga potencial de información.
- `o`: El servicio crítico está disponible.

## 2) Reglas de negocio

- **R1:** Si `r` y no `s`, entonces `t`.
- **R2:** Si `p` y `q`, entonces `o`.
- **R3:** Si no `u`, entonces no `v`.
- **R4:** Si `t` o no `v`, entonces `w`.
- **R5:** Si no `x`, entonces `t`.
- **R6:** Si no `y`, entonces `t`.
- **R7:** Si `z`, entonces `t`.
- **R8:** Si no `a` y `b`, entonces `t`.
- **R9:** Si `b`, entonces `c`.
- **R10:** Si no `d`, entonces `t`.
- **R11:** Si `d`, entonces `e`.
- **R12:** Si no `f`, entonces `g`.
- **R13:** Si `g`, entonces `t`.
- **R14:** Si no `h`, entonces `t`.
- **R15:** Si `i` y no `h`, entonces `t`.
- **R16:** Si no `j`, entonces `t`.
- **R17:** Si `k`, entonces `w`.
- **R18:** Si no `l`, entonces `t`.
- **R19:** Si `m`, entonces `n`.
- **R20:** Si `n`, entonces `w`.

## 3) Traducción a lógica simbólica

- `R1`: `(r ∧ ¬s) → t`
- `R2`: `(p ∧ q) → o`
- `R3`: `¬u → ¬v`
- `R4`: `(t ∨ ¬v) → w`
- `R5`: `¬x → t`
- `R6`: `¬y → t`
- `R7`: `z → t`
- `R8`: `(¬a ∧ b) → t`
- `R9`: `b → c`
- `R10`: `¬d → t`
- `R11`: `d → e`
- `R12`: `¬f → g`
- `R13`: `g → t`
- `R14`: `¬h → t`
- `R15`: `(i ∧ ¬h) → t`
- `R16`: `¬j → t`
- `R17`: `k → w`
- `R18`: `¬l → t`
- `R19`: `m → n`
- `R20`: `n → w`

## 3.1) Tablas de verdad (reglas clave)

Se incluyen tablas de verdad para 4 reglas representativas. En todos los casos, la columna final valida la formula original.

### Tabla R1: `(r ∧ ¬s) → t`

| r | s | t | ¬s | r ∧ ¬s | (r ∧ ¬s) → t |
|---|---|---|----|--------|--------------|
| F | F | F | V  | F      | V            |
| F | F | V | V  | F      | V            |
| F | V | F | F  | F      | V            |
| F | V | V | F  | F      | V            |
| V | F | F | V  | V      | F            |
| V | F | V | V  | V      | V            |
| V | V | F | F  | F      | V            |
| V | V | V | F  | F      | V            |

### Tabla R2: `(p ∧ q) → o`

| p | q | o | p ∧ q | (p ∧ q) → o |
|---|---|---|-------|-------------|
| F | F | F | F     | V           |
| F | F | V | F     | V           |
| F | V | F | F     | V           |
| F | V | V | F     | V           |
| V | F | F | F     | V           |
| V | F | V | F     | V           |
| V | V | F | V     | F           |
| V | V | V | V     | V           |

### Tabla R3: `¬u → ¬v`

| u | v | ¬u | ¬v | ¬u → ¬v |
|---|---|----|----|---------|
| F | F | V  | V  | V       |
| F | V | V  | F  | F       |
| V | F | F  | V  | V       |
| V | V | F  | F  | V       |

### Tabla R4: `(t ∨ ¬v) → w`

| t | v | w | ¬v | t ∨ ¬v | (t ∨ ¬v) → w |
|---|---|---|----|--------|--------------|
| F | F | F | V  | V      | F            |
| F | F | V | V  | V      | V            |
| F | V | F | F  | F      | V            |
| F | V | V | F  | F      | V            |
| V | F | F | V  | V      | F            |
| V | F | V | V  | V      | V            |
| V | V | F | F  | V      | F            |
| V | V | V | F  | V      | V            |

## 3.2) Formulas en FNC (resumen directo)

- `FNC(R1) = (¬r ∨ s ∨ t)`
- `FNC(R2) = (¬p ∨ ¬q ∨ o)`
- `FNC(R3) = (u ∨ ¬v)`
- `FNC(R4) = (¬t ∨ w) ∧ (v ∨ w)`
- `FNC(R5) = (x ∨ t)`
- `FNC(R6) = (y ∨ t)`
- `FNC(R7) = (¬z ∨ t)`
- `FNC(R8) = (a ∨ ¬b ∨ t)`
- `FNC(R9) = (¬b ∨ c)`
- `FNC(R10) = (d ∨ t)`
- `FNC(R11) = (¬d ∨ e)`
- `FNC(R12) = (f ∨ g)`
- `FNC(R13) = (¬g ∨ t)`
- `FNC(R14) = (h ∨ t)`
- `FNC(R15) = (¬i ∨ h ∨ t)`
- `FNC(R16) = (j ∨ t)`
- `FNC(R17) = (¬k ∨ w)`
- `FNC(R18) = (l ∨ t)`
- `FNC(R19) = (¬m ∨ n)`
- `FNC(R20) = (¬n ∨ w)`

## 4) Conversión a FNC paso a paso

Reglas usadas:  
1) `A → B ≡ ¬A ∨ B`  
2) De Morgan: `¬(A ∧ B) ≡ ¬A ∨ ¬B`, `¬(A ∨ B) ≡ ¬A ∧ ¬B`  
3) Distribución: `(A ∧ B) ∨ C ≡ (A ∨ C) ∧ (B ∨ C)`

### R1: `(r ∧ ¬s) → t`
1. `¬(r ∧ ¬s) ∨ t`  
2. `(¬r ∨ s) ∨ t`  
**FNC:** `(¬r ∨ s ∨ t)`

### R2: `(p ∧ q) → o`
1. `¬(p ∧ q) ∨ o`  
2. `(¬p ∨ ¬q) ∨ o`  
**FNC:** `(¬p ∨ ¬q ∨ o)`

### R3: `¬u → ¬v`
1. `¬(¬u) ∨ ¬v`  
2. `u ∨ ¬v`  
**FNC:** `(u ∨ ¬v)`

### R4: `(t ∨ ¬v) → w`
1. `¬(t ∨ ¬v) ∨ w`  
2. `(¬t ∧ v) ∨ w`  
3. `(¬t ∨ w) ∧ (v ∨ w)`  
**FNC:** `(¬t ∨ w) ∧ (v ∨ w)`

### R5: `¬x → t`
1. `¬(¬x) ∨ t`  
2. `x ∨ t`  
**FNC:** `(x ∨ t)`

### R6: `¬y → t`
1. `¬(¬y) ∨ t`  
2. `y ∨ t`  
**FNC:** `(y ∨ t)`

### R7: `z → t`
1. `¬z ∨ t`  
**FNC:** `(¬z ∨ t)`

### R8: `(¬a ∧ b) → t`
1. `¬(¬a ∧ b) ∨ t`  
2. `(a ∨ ¬b) ∨ t`  
**FNC:** `(a ∨ ¬b ∨ t)`

### R9: `b → c`
1. `¬b ∨ c`  
**FNC:** `(¬b ∨ c)`

### R10: `¬d → t`
1. `¬(¬d) ∨ t`  
2. `d ∨ t`  
**FNC:** `(d ∨ t)`

### R11: `d → e`
1. `¬d ∨ e`  
**FNC:** `(¬d ∨ e)`

### R12: `¬f → g`
1. `¬(¬f) ∨ g`  
2. `f ∨ g`  
**FNC:** `(f ∨ g)`

### R13: `g → t`
1. `¬g ∨ t`  
**FNC:** `(¬g ∨ t)`

### R14: `¬h → t`
1. `¬(¬h) ∨ t`  
2. `h ∨ t`  
**FNC:** `(h ∨ t)`

### R15: `(i ∧ ¬h) → t`
1. `¬(i ∧ ¬h) ∨ t`  
2. `(¬i ∨ h) ∨ t`  
**FNC:** `(¬i ∨ h ∨ t)`

### R16: `¬j → t`
1. `¬(¬j) ∨ t`  
2. `j ∨ t`  
**FNC:** `(j ∨ t)`

### R17: `k → w`
1. `¬k ∨ w`  
**FNC:** `(¬k ∨ w)`

### R18: `¬l → t`
1. `¬(¬l) ∨ t`  
2. `l ∨ t`  
**FNC:** `(l ∨ t)`

### R19: `m → n`
1. `¬m ∨ n`  
**FNC:** `(¬m ∨ n)`

### R20: `n → w`
1. `¬n ∨ w`  
**FNC:** `(¬n ∨ w)`

## FNC global del sistema

`(¬r ∨ s ∨ t) ∧ (¬p ∨ ¬q ∨ o) ∧ (u ∨ ¬v) ∧ (¬t ∨ w) ∧ (v ∨ w) ∧ (x ∨ t) ∧ (y ∨ t) ∧ (¬z ∨ t) ∧ (a ∨ ¬b ∨ t) ∧ (¬b ∨ c) ∧ (d ∨ t) ∧ (¬d ∨ e) ∧ (f ∨ g) ∧ (¬g ∨ t) ∧ (h ∨ t) ∧ (¬i ∨ h ∨ t) ∧ (j ∨ t) ∧ (¬k ∨ w) ∧ (l ∨ t) ∧ (¬m ∨ n) ∧ (¬n ∨ w)`

## 5) Resolución Proposicional

Utilizar el método de resolución para demostrar si una configuración específica de la red es segura o si presenta contradicciones lógicas.

### Caso A: Verificar si la configuración es segura

Definimos "segura" como `¬t` (no hay riesgo de seguridad).

**Hechos de configuración:**
- `s` (VPN activa)
- `¬r` (SSH no expuesto a Internet)
- `x` (antivirus actualizado)
- `y` (parches críticos aplicados)
- `h` (IDS/IPS activo)
- `j` (logs centralizados)
- `l` (certificado TLS válido)

**Cláusulas relevantes del sistema (FNC):**
- `C1`: `(¬r ∨ s ∨ t)`
- `C2`: `(x ∨ t)`
- `C3`: `(y ∨ t)`
- `C4`: `(h ∨ t)`
- `C5`: `(j ∨ t)`
- `C6`: `(l ∨ t)`

Con esos hechos no se puede derivar `t` por resolución; por tanto, el conjunto es **consistente** con `¬t`.

### Caso B: Detectar contradicción lógica (configuración insegura)

**Hechos de configuración:**
- `r` (SSH abierto)
- `¬s` (sin VPN)
- `¬t` (afirmación de que "es segura")

**Cláusula de la regla R1 en FNC:**
- `C7`: `(¬r ∨ s ∨ t)`

**Resolución paso a paso:**

1. Resolver `C7` con `r`:
   - De `(¬r ∨ s ∨ t)` y `r`, obtenemos `(s ∨ t)`.
2. Resolver `(s ∨ t)` con `¬s`:
   - De `(s ∨ t)` y `¬s`, obtenemos `t`.
3. Resolver `t` con `¬t`:
   - Obtenemos la cláusula vacía `□` (contradicción).

Conclusión: la configuración `{r, ¬s, ¬t}` es **inconsistente**; por lo tanto, no puede considerarse segura bajo las reglas definidas.
