:- module(auditoria_ti, [
    acceso_permitido/3,
    diagnostico_fallo/4,
    diagnostico_rapido/4,
    evaluar_acceso/4,
    trace_evaluar/4,
    trace_evaluar_sin_pausa/4
]).

% -------------------------------
% Base de conocimiento (hechos)
% -------------------------------

usuario(admin).
usuario(analista).

grupo(admin, admins).
grupo(analista, invitados).

servidor(s1).
servidor(s2).

ambiente(s1, prod).
ambiente(s2, test).

zona(s1, datacenter).
zona(s2, local).

servicio(s1, 443, https).
servicio(s2, 8080, api_test).

% Configuracion de seguridad por usuario
cuenta_activa(admin).
cuenta_activa(analista).

mfa_habilitado(admin).
vpn_activa(admin).

% Estado intencional para diagnostico de ejemplo:
% El usuario admin esta bloqueado, por eso no accede aunque tenga MFA/VPN.
cuenta_bloqueada(admin).

% Estado de red/firewall
firewall_permite(s2, 8080).
% No hay hecho firewall_permite(s1, 443), simulando bloqueo en el puerto 443.

% -------------------------------
% Reglas en clausulas de Horn
% -------------------------------

es_admin(U) :-
    grupo(U, admins).

es_invitado(U) :-
    grupo(U, invitados).

puerto_abierto(S, P) :-
    servicio(S, P, _),
    firewall_permite(S, P).

tiene_permiso(U, S, _P) :-
    es_admin(U),
    ambiente(S, prod).

tiene_permiso(U, S, _P) :-
    es_admin(U),
    ambiente(S, test).

tiene_permiso(U, S, _P) :-
    es_invitado(U),
    ambiente(S, test),
    zona(S, local).

cumple_controles_base(U, S) :-
    cuenta_activa(U),
    \+ cuenta_bloqueada(U),
    (ambiente(S, prod) -> (mfa_habilitado(U), vpn_activa(U)) ; true).

acceso_permitido(U, S, P) :-
    usuario(U),
    servidor(S),
    puerto_abierto(S, P),
    tiene_permiso(U, S, P),
    cumple_controles_base(U, S).

% --------------------------------------------
% Diagnostico de fallos (lista de causas)
% --------------------------------------------

causa_fallo(U, _S, _P, cuenta_bloqueada) :-
    cuenta_bloqueada(U).

causa_fallo(U, _S, _P, mfa_requerido) :-
    \+ mfa_habilitado(U).

causa_fallo(U, S, _P, vpn_requerida_prod) :-
    ambiente(S, prod),
    \+ vpn_activa(U).

causa_fallo(U, S, _P, permiso_insuficiente) :-
    \+ tiene_permiso(U, S, _).

causa_fallo(_U, S, P, puerto_bloqueado_en_firewall) :-
    servicio(S, P, _),
    \+ firewall_permite(S, P).

causa_fallo(_U, S, P, servicio_no_expuesto) :-
    \+ servicio(S, P, _).

diagnostico_fallo(U, S, P, Causas) :-
    findall(Causa, causa_fallo(U, S, P, Causa), Lista),
    sort(Lista, Causas),
    Causas \= [].

% ---------------------------------------------------
% Control de eficiencia con corte (!)
% Devuelve la primera falla critica encontrada.
% ---------------------------------------------------

primera_falla_critica(U, _S, _P, cuenta_bloqueada) :-
    cuenta_bloqueada(U), !.
primera_falla_critica(_U, S, P, puerto_bloqueado_en_firewall) :-
    servicio(S, P, _),
    \+ firewall_permite(S, P), !.
primera_falla_critica(U, S, _P, credenciales_incompletas_en_prod) :-
    ambiente(S, prod),
    (\+ mfa_habilitado(U) ; \+ vpn_activa(U)), !.
primera_falla_critica(U, S, _P, permiso_insuficiente) :-
    \+ tiene_permiso(U, S, _), !.
primera_falla_critica(_U, _S, _P, sin_falla_critica_detectada).

diagnostico_rapido(U, S, P, CausaPrincipal) :-
    primera_falla_critica(U, S, P, CausaPrincipal).

% Resultado principal para consultas complejas:
% - Si cumple politicas, confirma acceso.
% - Si no cumple, entrega lista de causas probables.
evaluar_acceso(U, S, P, resultado(cumple_politicas, acceso_autorizado)) :-
    acceso_permitido(U, S, P), !.
evaluar_acceso(U, S, P, resultado(no_cumple_politicas, Causas)) :-
    diagnostico_fallo(U, S, P, Causas), !.
evaluar_acceso(_U, _S, _P, resultado(no_cumple_politicas, [sin_datos_suficientes])).

% ---------------------------------------------------
% Herramientas de traza para ver unificacion/backtracking
% ---------------------------------------------------

% Traza normal (interactiva): permite avanzar paso a paso.
trace_evaluar(U, S, P, R) :-
    trace,
    evaluar_acceso(U, S, P, R),
    notrace.

% Traza sin pausa: imprime puertos Call/Exit/Redo/Fail sin detenerse.
trace_evaluar_sin_pausa(U, S, P, R) :-
    visible(+all),
    leash(-all),
    trace,
    evaluar_acceso(U, S, P, R),
    notrace.
